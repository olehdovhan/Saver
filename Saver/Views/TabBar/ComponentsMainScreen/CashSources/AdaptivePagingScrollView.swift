//
//  AdaptivePagingScrollView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 29.12.2022.
//

import SwiftUI

struct AdaptivePagingScrollView: View {

    private let items: AnyView
    private let itemPadding: CGFloat
    private let itemSpacing: CGFloat
    private let itemWidth: CGFloat
    private let itemsAmount: Int
    private let contentWidth: CGFloat

    private let scrollDampingFactor: CGFloat = 0.66

    @Binding var currentPageIndex: Int
    
    @State var firstZ: Double = 3
    @Binding var addCashSourceViewShow: Bool
    @Binding var incomeViewShow: Bool
    @Binding var expenseViewShow: Bool
    @Binding var purchaseType: String
    @Binding var cashSource: String
    @Binding var cashSourceReceiver: String
    @Binding var cashSources: [CashSource]
    @Binding var draggingScroll: Bool
    @Binding var limitCashSourcesViewShow: Bool
    private let leadingOffset: CGFloat

    @Binding var currentScrollOffset: CGFloat
    @State private var gestureDragOffset: CGFloat = 0

    private func countOffset(for pageIndex: Int) -> CGFloat {

        let activePageOffset = CGFloat(pageIndex) * (itemWidth + itemPadding)
        return leadingOffset - activePageOffset
    }

    private func countPageIndex(for offset: CGFloat) -> Int {

        guard itemsAmount > 0 else { return 0 }

        let offset = countLogicalOffset(offset)
        let floatIndex = (offset)/(itemWidth + itemPadding)

        var index = Int(round(floatIndex))
        if max(index, 0) > itemsAmount {
            index = itemsAmount
        }
        return min(max(index, 0), itemsAmount - 1)
    }

    private func countCurrentScrollOffset() -> CGFloat {
        return countOffset(for: currentPageIndex) + gestureDragOffset
    }

    private func countLogicalOffset(_ trueOffset: CGFloat) -> CGFloat {
        return (trueOffset-leadingOffset) * -1.0
    }

    init<A: View>(
        addCashSourceViewShow: Binding<Bool>,
        incomeViewShow: Binding<Bool>,
        expenseViewShow: Binding<Bool>,
        purchaseType: Binding<String>,
        cashSource: Binding<String>,
        cashSourceReceiver: Binding<String>,
        cashSources: Binding<Array<CashSource>>,
        
        
        currentPageIndex: Binding<Int>,
        draggingScroll: Binding<Bool>,
        itemsAmount: Int,
        itemWidth: CGFloat,
        itemPadding: CGFloat,
        pageWidth: CGFloat,
        limitCashSourcesViewShow: Binding<Bool>,
        currentScrollOffset: Binding<CGFloat>,
        @ViewBuilder content: () -> A) {

        let views = content()
        self.items = AnyView(views)
      
        self._addCashSourceViewShow = addCashSourceViewShow
        self._incomeViewShow = incomeViewShow
        self._expenseViewShow = expenseViewShow
        self._purchaseType = purchaseType
        self._cashSource = cashSource
        self._cashSourceReceiver = cashSourceReceiver
        self._cashSources = cashSources
            
        self._currentPageIndex = currentPageIndex
          
        self._draggingScroll = draggingScroll
        self.itemsAmount = itemsAmount
        self.itemSpacing = itemPadding
      
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
        self.contentWidth = (itemWidth+itemPadding)*CGFloat(itemsAmount)

      //  let itemRemain = (pageWidth-itemWidth-2*itemPadding)/2
        self.leadingOffset =   itemPadding
            self._limitCashSourcesViewShow = limitCashSourcesViewShow
//            self._leadingOffsetScroll = leadingOffsetScroll
            self._currentScrollOffset = currentScrollOffset
            
    }

    var body: some View {
            GeometryReader { viewGeometry in
                
                HStack(alignment: .top, spacing: itemSpacing) {
                    
                        items.frame(width: itemWidth)
                        
                        Button {
                            if cashSources.count < 6 {
                                addCashSourceViewShow = true
                            } else {
                                limitCashSourcesViewShow = true
                            }
                        } label: {
                            VStack {
                                Spacer().frame(width: UIScreen.main.bounds.width * 0.1744, height: 35)
                                Image("iconPlus")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .myShadow(radiusShadow: 5)
                                Spacer().frame(width:  UIScreen.main.bounds.width * 0.1744, height: 15)
                            }
                        }
//                        .zIndex(1)
                    
                }
            }
            .onAppear {
                currentScrollOffset =  countOffset(for: currentPageIndex)
//                print("III  itemSpacing \(itemPadding) coef \(itemPadding/UIScreen.main.bounds.width)")
//                print("III  contentWidth \(contentWidth) coef \(contentWidth/UIScreen.main.bounds.width)")
//                print("III  itemPadding \(itemPadding) coef \(itemPadding/UIScreen.main.bounds.width)")
//                print("III  leadingOffset \(leadingOffset) coef \(leadingOffset/UIScreen.main.bounds.width)")
//                print("III  currentScrollOffset \(currentScrollOffset) coef \(currentScrollOffset/UIScreen.main.bounds.width)")
//                print("III  gestureDragOffset \(gestureDragOffset) coef \(gestureDragOffset/UIScreen.main.bounds.width)")
                
                
            }
            .background(Color.white.opacity(0.0025)) // hack - this allows gesture recognizing even when background is transparent
            .frame(width: contentWidth)
            .offset(x: self.currentScrollOffset, y: 0)
            .simultaneousGesture(
                DragGesture(minimumDistance: 1, coordinateSpace: .local)
                    .onChanged { value in
//                        if !expenseViewShow{
                        if draggingScroll == false {
                            gestureDragOffset = value.translation.width
                            currentScrollOffset = countCurrentScrollOffset()
//                        }
                                    }
                    }
                    .onEnded { value in
//                                                if !expenseViewShow{
                        let cleanOffset = (value.predictedEndTranslation.width - gestureDragOffset)
                        let velocityDiff = cleanOffset * scrollDampingFactor
                        
                        var newPageIndex = countPageIndex(for: currentScrollOffset + velocityDiff)
                        
                        let currentItemOffset = CGFloat(currentPageIndex) * (itemWidth + itemPadding)
                        
                        if currentScrollOffset < -(currentItemOffset),
                           newPageIndex == currentPageIndex {
                            newPageIndex += 1
                        }
                        
                        gestureDragOffset = 0
                        
                        withAnimation(.interpolatingSpring(mass: 0.1,
                                                           stiffness: 20,
                                                           damping: 1.5,
                                                           initialVelocity: 0)) {
                            self.currentPageIndex = newPageIndex
                            self.currentScrollOffset = self.countCurrentScrollOffset()
                        }
                    }
            )
    }
}

