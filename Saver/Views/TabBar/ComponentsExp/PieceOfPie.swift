//
//  PieceOfPie.swift
//  Saver
//
//  Created by Пришляк Дмитро on 01.09.2022.
//
import Foundation
import SwiftUI

struct PieceOfPie{
    let id = UUID()
    let color: Color
    var percent: CGFloat
    let amount: CGFloat
    var value: CGFloat
    var name: String
}

class PieceOfPieContainer: ObservableObject {
    
    @Published var chartData: [PieceOfPie] = []
    
    private var chartLimitedColors: [Color] = [
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .gray,
        .pink,
        Color(hex: "#00FFFF"),
        Color(hex: "#7CFC00"),
        Color(hex: "800080"),
        Color(hex: "4682B4"),
        Color(hex: "000080"),
        Color(hex: "FF00FF")
    ]
    
    init () {
        guard let allPurchaseCategoriesSet = getAllExpenses() else { return }
        let allPurchaseCategories = Array(allPurchaseCategoriesSet)
        let expensesDict = createExpenseDict(from: allPurchaseCategories)
        //        print("III\(allPurchaseCategories.count)")
        
        for (index, category) in allPurchaseCategories.enumerated() {
            let piece = PieceOfPie(color: chartLimitedColors[index],
                                   percent: 0,
                                   amount: CGFloat(expensesDict[category] ?? 0.0),
                                   value: 0,
                                   name: category)
            chartData.append(piece)
        }
    }
    
    func getAllExpenses() -> Set<String>? {
        if FirebaseUserManager.shared.userModel?.currentMonthSpendings?.count != 0 ,
           let expenses = FirebaseUserManager.shared.userModel?.currentMonthSpendings {
            var categoriesSet: Set<String> = []
            for expense in expenses {
                categoriesSet.insert(expense.spentCategory)
            }
            return categoriesSet
        }
        return nil
    }
    
    func createExpenseDict(from categories: [String] ) -> [String: Double] {
        var dict: [String: Double] = [:]
        for category in categories {
            var sum: Double = 0.0
            let filtered = FirebaseUserManager.shared.userModel!.currentMonthSpendings!.filter { $0.spentCategory == category }
            
            for item in filtered {
                sum += item.amount
            }
            dict[category] = sum
        }
        return dict
    }
    
    func calcOfPath(){
        var totalAmount: CGFloat = 0
        var value: CGFloat = 0
        
        for category in 0..<chartData.count {
            totalAmount += chartData[category].amount
        }
        
        for category in 0..<chartData.count{
            chartData[category].percent = (chartData[category].amount * 100) / totalAmount
            value += chartData[category].percent
            chartData[category].value = value
        }
    }
}

struct PieChart: View {
    
    @State var chartDataObject = PieceOfPieContainer()
    @State private var indexOfTappedSlice = -1
    @State private var percentTapped = Locale.current.currencyCode ?? "USD"
    @Binding var selectedTab: Int
    @Binding var isPercent: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            chartsCircleView
                .shadow(radius: 5)
                .frame(width: wRatio(90), height: wRatio(180))
                .padding(.bottom, 20)
                .onChange(of: selectedTab, perform: { newValue in
                    if selectedTab == 1{
                        chartDataObject = PieceOfPieContainer()
                        chartDataObject.chartData = chartDataObject.chartData.sorted{$0.amount > $1.amount}
                        self.chartDataObject.calcOfPath()
                        indexOfTappedSlice = -1
                    }
                })
                .onAppear() {
                    chartDataObject = PieceOfPieContainer()
                    chartDataObject.chartData = chartDataObject.chartData.sorted{$0.amount > $1.amount}
                    self.chartDataObject.calcOfPath()
                }
            LinearGradient(colors: [.myGreen, .myBlue],
                           startPoint: .leading,
                           endPoint: .trailing)
            .frame(width: UIScreen.main.bounds.width, height: 3)
            
            chartListView
                .padding(.bottom, wRatio(85))
                
//                .frame(width: 300, alignment: .leading)
        }
    }
}


extension PieChart {
    
    private var chartsCircleView: some View {
        ZStack{
            ForEach(0..<chartDataObject.chartData.count, id: \.self) { index in
                Circle()
                    .trim(from: index == 0 ? 0.0 : chartDataObject.chartData[index - 1].value/100,
                          to: chartDataObject.chartData[index].value/100)
                    .stroke(chartDataObject.chartData[index].color, lineWidth: wRatio(90))
//                    .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 0)
                    .scaleEffect(index == indexOfTappedSlice ? 1.1 : 1.0)
                  .animation(.spring())
                    .onTapGesture {
                        indexOfTappedSlice = (indexOfTappedSlice == index ? -1 : index)
                        percentTapped = indexOfTappedSlice == index ? String(Int(chartDataObject.chartData[index].amount)) : Locale.current.currencyCode ?? "USD"
                    }
            }.rotationEffect(.degrees(-90))
            
            Circle()
                .fill(.white)
//                .stroke(.white, lineWidth: wRatio(40))
                .frame(width: wRatio(80), height: wRatio(80), alignment: .center)
                .shadow(radius: 5)
            
            Text(percentTapped)
                .foregroundColor(.black)
                .fontWeight(Font.Weight.light)
                .disabled(true)
            
            if percentTapped != (Locale.current.currencyCode ?? "USD") {
                Text(Locale.current.currencyCode ?? "USD")
                    .foregroundColor(.black)
                    .fontWeight(Font.Weight.light)
                    .font(.system(size: 10))
                    .offset(y: 15)
            }
        }
    }
    
    private var chartListView: some View {
        
        ScrollView(.vertical, showsIndicators: true){
            VStack(alignment: .leading){
                Spacer().frame(width: 3)
                ForEach(0..<chartDataObject.chartData.count, id: \.self) { index in
                    
                        HStack(spacing: 0){
                            //value of amount or percent
                            HStack{
                                Spacer()
                                
                                if isPercent{
                                    Text(String(format: "%.2f", Double(chartDataObject.chartData[index].percent)) + "%")
                                } else {
                                    Text(String(Int(chartDataObject.chartData[index].amount)) + " " + (Locale.current.currencyCode ?? "USD"))
                                }
                                
                                Spacer().frame(width: 5)
                                
                            }
//                            .background(.blue.opacity(0.3))
                            .frame(width: wRatio(120))
                            
                            Circle()
                                .fill(chartDataObject.chartData[index].color)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 10, height: 10)
                                        .scaleEffect(index == indexOfTappedSlice ? 0 : 1)
                                        .animation(.spring())
                                    )
                            
                            //name of purchase category
                            HStack{
                                Spacer().frame(width: 5)
                                
                                Text(" \(chartDataObject.chartData[index].name)")
                                
                                Spacer()
                            }
//                            .background(.blue.opacity(0.3))
                            .frame(width: wRatio(240))
                            
                            Spacer()
                        }
                        .frame(width: wRatio(380))
                        .font(.custom(indexOfTappedSlice == index ? "Lato-Bold" : "Lato-Regular" , size: 16))
                    
                    .onTapGesture {
                        indexOfTappedSlice = (indexOfTappedSlice == index ? -1 : index)
                        percentTapped = indexOfTappedSlice == index ? String(Int(chartDataObject.chartData[index].amount)) : Locale.current.currencyCode ?? "USD"
                    }
                }
                
                Spacer().frame(width: 10)
            }
        }
        
        
        
//        .preferredColorScheme(.dark)
//        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.blue, lineWidth: 1))
        
    }
}



