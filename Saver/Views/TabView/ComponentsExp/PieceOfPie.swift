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
//
////ObservableObject - протокол використовується з класами
class PieceOfPieContainer: ObservableObject{
    //Спостерігаємий об'єкт.  @Published - оболочка(обгортка) для об'єкта, що б він став спостерігаємим
    @Published var chartData = [
        PieceOfPie(color: .blue, percent: 0, amount: 2350, value: 0, name: "Products"),
        PieceOfPie(color: .green, percent: 0, amount: 3550, value: 0, name: "Transport"),
        PieceOfPie(color: .yellow, percent: 0, amount: 3150, value: 0, name: "Clouthing"),
        PieceOfPie(color: .orange, percent: 0, amount: 3150, value: 0, name: "Restaurant"),
        PieceOfPie(color: .cyan, percent: 0, amount: 2350, value: 0, name: "Products"),
        PieceOfPie(color: .pink, percent: 0, amount: 5550, value: 0, name: "Transport"),
        PieceOfPie(color: .gray, percent: 0, amount: 7150, value: 0, name: "Clouthing"),
        PieceOfPie(color: .red, percent: 0, amount: 1150, value: 0, name: "Restaurant"),
        PieceOfPie(color: .yellow, percent: 0, amount: 3450, value: 0, name: "Clouthing"),
        PieceOfPie(color: .orange, percent: 0, amount: 3850, value: 0, name: "Restaurant"),
        PieceOfPie(color: .cyan, percent: 0, amount: 1000, value: 0, name: "Products"),
        PieceOfPie(color: .pink, percent: 0, amount: 750, value: 0, name: "Transport"),
    ]
    
    //var
    
    //медо, що визначає значення кожної властивості value і передає їх в масив
    func calcOfPath(){
        var totalAmount: CGFloat = 0
        var value: CGFloat = 0
        
        for category in 0..<chartData.count{
            totalAmount += chartData[category].amount
        }
        
        for category in 0..<chartData.count{
            chartData[category].percent = (chartData[category].amount * 100) / totalAmount
            
            value += chartData[category].percent
            chartData[category].value = value
        }

    }
}




//
struct PieChart: View {
    // @ObservedObject - оболочка для зберігання екземпляра спостерігаємого об'єкта
    @ObservedObject var chartDataObject = PieceOfPieContainer()
    @State  private var indexOfTappedSlice = -1
    @State private var percentTapped = "UAH"
    
    var body: some View {
        
        VStack{
            chartsCircleView
                .frame(width: 100, height: 200)
            //запуск анімації коли вид з'явиться на екрані
                .onAppear() {
                    chartDataObject.chartData = chartDataObject.chartData.sorted{$0.amount > $1.amount}
                    self.chartDataObject.calcOfPath()
                }
            
            chartListView
                .padding(8)
                .frame(width: 300, alignment: .leading)
                
        
        }
    }
}
//
struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart()
    }
}
//
//
//
extension PieChart{
    
    //змінна яка поврне нашу діаграму
    
    
    private var chartsCircleView: some View{
        
        //створюємо коло з розділенням на елементи
 
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
            
            VStack{
                
            }
            
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
    //список
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
            
            .onTapGesture{
                
                indexOfTappedSlice = (indexOfTappedSlice == index ? -1 : index)
                percentTapped = indexOfTappedSlice == index ? String(Int(chartDataObject.chartData[index].amount)) : "UAH"
            }
        }
        }
        }
        
        .padding(.bottom, 300)
        
    
    }
}

