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
    
    private var chartLimitedColors: [Color] = [.red,
                                               .orange,
                                               .yellow,
                                               .green,
                                               .blue.opacity(50),
                                               .blue,
                                               .purple,
                                               .gray,
                                               .pink,
                                               .brown]
    
    init () {
        guard let allPurchaseCategoriesSet = getAllExpenses() else { return }
        let allPurchaseCategories = Array(allPurchaseCategoriesSet)
        let expensesDict = createExpenseDict(from: allPurchaseCategories)
        print("III\(allPurchaseCategories.count)")
        
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
        if UserDefaultsManager.shared.userModel?.currentMonthSpendings?.count != 0 ,
           let expenses = UserDefaultsManager.shared.userModel?.currentMonthSpendings {
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
            let filtered = UserDefaultsManager.shared.userModel!.currentMonthSpendings!.filter { $0.spentCategory == category }
            
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
    @State private var percentTapped = "UAH"
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            chartsCircleView
                .frame(width: 100, height: 200)
                .onChange(of: selectedTab, perform: { newValue in
                    chartDataObject = PieceOfPieContainer()
                    chartDataObject.chartData = chartDataObject.chartData.sorted{$0.amount > $1.amount}
                    self.chartDataObject.calcOfPath()
                })
                .onAppear() {
                    chartDataObject = PieceOfPieContainer()
                    chartDataObject.chartData = chartDataObject.chartData.sorted{$0.amount > $1.amount}
                    self.chartDataObject.calcOfPath()
                }
            chartListView
                .padding(8)
                .frame(width: 300, alignment: .leading)
        }
    }
}


extension PieChart {
    
        private var chartsCircleView: some View {
        ZStack{
            ForEach(0..<chartDataObject.chartData.count) { index in
                Circle()
                    .trim(from: index == 0 ? 0.0 : chartDataObject.chartData[index - 1].value/100,
                          to: chartDataObject.chartData[index].value/100)
                    .stroke(chartDataObject.chartData[index].color, lineWidth: 100)
                    .scaleEffect(index == indexOfTappedSlice ? 1.1 : 1.0)
                    .animation(.spring())
                    .onTapGesture{
                        indexOfTappedSlice = (indexOfTappedSlice == index ? -1 : index)
                        percentTapped = indexOfTappedSlice == index ? String(Int(chartDataObject.chartData[index].amount)) : "UAH"
                }
            }
            
            Circle()
                .stroke(.white, lineWidth: 50)
                .frame(width: 50, height: 50, alignment: .center)
            
            Text(percentTapped)
                .foregroundColor(.black)
                .fontWeight(Font.Weight.light)
            
            if percentTapped != "UAH" {
                Text("UAH")
                    .foregroundColor(.black)
                    .fontWeight(Font.Weight.light)
                    .font(.system(size: 10))
                    .offset(y: 15)
            }
        }
    }
    
    private var chartListView: some View {
        
        ScrollView(.vertical, showsIndicators: true){
            VStack(alignment: HorizontalAlignment.leading){
                ForEach(0..<chartDataObject.chartData.count) { index in
                    HStack{
                        RoundedRectangle(cornerRadius: index == indexOfTappedSlice ? 0 : 10)
                            .fill(chartDataObject.chartData[index].color)
                            .frame(width: 20, height: 20)
                            .animation(.spring())
                        
                        Text(String(format: "%.2f",
                                    Double(chartDataObject.chartData[index].percent)) + "%" + " \(chartDataObject.chartData[index].name)")
                        .font(indexOfTappedSlice == index ? Font.headline : Font.subheadline)
                    }
                    
                    .onTapGesture {
                        indexOfTappedSlice = (indexOfTappedSlice == index ? -1 : index)
                        percentTapped = indexOfTappedSlice == index ? String(Int(chartDataObject.chartData[index].amount)) : "UAH"
                    }
                }
            }
        }
        .padding(.bottom, 300)
    }
}
