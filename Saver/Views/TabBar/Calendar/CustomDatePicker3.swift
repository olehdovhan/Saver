//
//  CustomDatePicker3.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 20.12.2022.
//

import SwiftUI
import UIKit

struct CustomDatePicker3: View {
    
    @State var selectedDate: Date = Date()
    @State var currentMonth: Int = 0
    
    @State var monthOffset: CGSize = .zero
    @State var dayOffset: CGSize = .zero
    
    let lengthDay = UIScreen.main.bounds.width / 8
    
    var futureMonthDate: Date {
        var dateComponent = DateComponents()
        dateComponent.month = +1
        return calendar.date(byAdding: dateComponent, to: selectedDate)!
    }
    
    var pastMonthDate: Date {
        var dateComponent = DateComponents()
        dateComponent.month = -1
        return calendar.date(byAdding: dateComponent, to: selectedDate)!
    }
    
    var futureDayDate: Date {
        var dateComponent = DateComponents()
        dateComponent.day = +1
        return calendar.date(byAdding: dateComponent, to: selectedDate)!
    }
    
    var pastDayDate: Date {
        var dateComponent = DateComponents()
        dateComponent.day = -1
        return calendar.date(byAdding: dateComponent, to: selectedDate)!
    }
    
    var dayOfWeakFormat : DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        return formatter
    }
    
    var  timeFormat24: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var sun: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 01))!)
    }
    var mon: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 02))!)
    }
    var tue: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 03))!)
    }
    var wed: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 04))!)
    }
    var thu: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 05))!)
    }
    var fri: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 06))!)
    }
    var sat: String{
        dayOfWeakFormat.string(from: calendar.date(from: DateComponents(year: 2022, month: 05, day: 07))!)
    }
    
    var selectedDayOfWeak: String{
        let selectedDayOfWeak = dayOfWeakFormat.string(from: selectedDate)
        return selectedDayOfWeak
    }
    
    var offsetDayOfWeek: CGSize{
        var offsetDay = CGSize()
        
        switch selectedDayOfWeak {
        case mon: offsetDay.width = lengthDay * 1
        case tue: offsetDay.width = lengthDay * 2
        case wed: offsetDay.width = lengthDay * 3
        case thu: offsetDay.width = lengthDay * 4
        case fri: offsetDay.width = lengthDay * 5
        case sat: offsetDay.width = lengthDay * 6
        default: offsetDay.width = 0
        }
        
        return offsetDay
    }
    
    
    var body: some View {
        VStack(spacing: 10){

            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Text(pastMonthDate, format: Date.FormatStyle().month(.abbreviated))
                        .font(.custom("NotoSans-Regular", size: 14, relativeTo: .body))
                }
                Spacer()
                
                
                Text(selectedDate, format: Date.FormatStyle().month(.abbreviated))
                    .font(.custom("NotoSans-Bold", size: 18, relativeTo: .body))
                
                Spacer()
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Text(futureMonthDate, format: Date.FormatStyle().month(.abbreviated))
                        .font(.custom("NotoSans-Regular", size: 14, relativeTo: .body))
                }
            }
            
            ZStack{
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(hex: "EDECEC"))
                    .frame(height: 5)
                
                RoundedRectangle(cornerRadius: 50)
                    .fill(LinearGradient(colors: [Color(hex: "#90DE58"), Color(hex: "#5CCCCC")], startPoint: .leading, endPoint: .trailing))
                    .frame(width: UIScreen.main.bounds.width / 5, height: 5)
                    .offset(x: monthOffset.width)
            }
//            .padding(.horizontal, 30)
            
            // Days of Weak...
            let dayOfWeakArray: [String] = [sun, mon,tue, wed, thu, fri, sat]
            HStack(spacing: 0) {
                ForEach(dayOfWeakArray, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }

            //Dates
            // Lazy Grid...
            let columns = Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 7 )
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(extractDate()) {value in
                    cardView(value: value)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isSameDay(date1: value.date, date2: selectedDate) ? .green : .gray.opacity(0.3), lineWidth: isSameDay(date1: value.date, date2: selectedDate) ? 2 : 1)
                        }
                        .onTapGesture {
                            print("value = \(value)")
                            print("selectedDate = \(value.date)")
                            selectedDate = value.date
                            let kkk = transactions[2].date
                            let check = isSameDay(date1: kkk , date2: selectedDate)
                            print(check)
                        }
                }
            }
            .offset(x: monthOffset.width)
            .gesture(monthDragGesture)
            
            VStack(spacing: 7) {
                Text(selectedDate, format: Date.FormatStyle().month(.abbreviated).day())
                    .font(.custom("NotoSans-SemiBold", size: 18, relativeTo: .body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color(hex: "EDECEC"))
                        .frame(height: 5)
                    
                    HStack{
                        
                        RoundedRectangle(cornerRadius: 50)
                            .fill(LinearGradient(colors: [Color(hex: "#90DE58"), Color(hex: "#5CCCCC")], startPoint: .leading, endPoint: .trailing))
                            .frame(width: lengthDay, height: 5)
                            .offset(x: offsetDayOfWeek.width)
                        Spacer()
                    }
                }
                VStack(spacing: 12){
                    if let task  = tasks.first(where: { task in
                        return isSameDay(date1: task.taskDate, date2: selectedDate)
                    }){
                        
                        //Список трансакцій, коли вони є
                        ForEach(task.tasks) { task in
                            HStack(spacing: 0){
                                HStack{
                                    let timeTask12 = task.time.addingTimeInterval(CGFloat.random(in: 0...5000))
                                
                                    Text(timeFormat24.string(from: timeTask12))
                                        .foregroundColor(Color(hex: "A9A9A9"))
                                    .multilineTextAlignment(.leading)
                                    .font(.custom("Lato-Regular", size: 16, relativeTo: .body))
    //
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width/7)
                                
                                Spacer().frame(width: 5)
                                
                                HStack{
                                    Text(task.valueUSD + "$")
                                    .foregroundColor(
                                        (Float(task.valueUSD) ?? 0) < 0.0 ?  Color.myRed :  Color.myGreen
                                    )
                                    .multilineTextAlignment(.leading)
                                    .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                                    
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width/4)
                                
                                Spacer().frame(width: 5)
                                
                                HStack{
                                    Text(task.title)
                                    .foregroundColor(
                                    (Float(task.valueUSD) ?? 0) < 0.0 ?  Color.myRed :  Color.myGreen
                                    )
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                        }
                       
                    }
                    else {
                        //Коли трансакцій нема
                         Text("No Transaction Found")
                            .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                    }
                }
                .padding(.top, 22)
                .offset(x: dayOffset.width)
                .gesture(dayDragGesture)
                
            }
            
            
            .padding(.top, 10)
        }
        .padding(.horizontal, 30)
        .onChange(of: currentMonth) { newValue in
            //updating Month...
            withAnimation {
                selectedDate = getCurrentMonth()
            }
        }
        

    }
    var monthDragGesture: some Gesture{
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged({ value in
                withAnimation(Animation.linear(duration: 0.5)) {
                    if abs(value.translation.width) < UIScreen.main.bounds.width / 3 {
                        self.monthOffset = value.translation
                    }
                }
            })
            .onEnded({ value in
                if value.translation.width > 0 {
                    if value.translation.width > 100{
                        print("future")
                        self.currentMonth += 1
                    }
                } else if value.translation.width < 0 {
                    if value.translation.width < 100 {
                        self.currentMonth -= 1
                    }
                }
                withAnimation(Animation.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.7)) {
                    self.monthOffset = .zero
                }
            })
    }
    
    var dayDragGesture: some Gesture{
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged({ value in
                withAnimation(Animation.linear(duration: 0.5)) {
                    if abs(value.translation.width) < UIScreen.main.bounds.width / 3 {
                        self.dayOffset = value.translation
                    }
                }
            })
            .onEnded({ value in
                if value.translation.width > 0 {
                    if value.translation.width > 100{
                        self.selectedDate = futureDayDate
                    }
                } else if value.translation.width < 0 {
                    if value.translation.width < 100 {
                        self.selectedDate = pastDayDate
                    }
                }
                withAnimation(Animation.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.7)) {
                    self.dayOffset = .zero
                }
            })
    }
    
    //віконце для відображення кожного дня в календпрю місяця з відміткою про нявність витрат та доходів
    @ViewBuilder
    func cardView(value: DateValue) -> some View {

        VStack{
            if value.day != -1 { // -1 day створювався для відображення пустих віконців (днів інших місяців)
                ZStack{
                    VStack{
                        
                        HStack{
                            Spacer()
                                .frame(width: 5)
                            Text("\(value.day)")
                                .font(.custom("Lato-Medium", size: 15, relativeTo: .body))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        VStack{
                            Spacer()
                            let transactionSelectedDay: [TransactionModel] = transactions.filter({
                                isSameDay(date1: $0.date, date2: selectedDate)
                            })
                            
                            let typeExp = transactionSelectedDay.filter({$0.transactionType == .expense})
                            if !typeExp.isEmpty {
                                Circle()
                                    .fill(Color.myRed)
                                    .frame(width: 8, height: 8)
                            }
                            
                            let typeInc = transactionSelectedDay.filter({$0.transactionType == .income})
                            if !typeInc.isEmpty {
                                Spacer().frame(height: 5)
                                Circle()
                                    .fill(Color.myGreen)
                                    .frame(width: 8, height: 8)
                            }
                            Spacer().frame(height: 5)
                        }
                        Spacer().frame(width: 5)
                    }
                }
            }
        }
        .padding(.vertical, 0)
        .frame(height: 60, alignment: .top)
        
        
        
        
    }
    //checking dates...
    func isSameDay(date1: Date, date2: Date) -> Bool{
        let isSameDay = calendar.isDate(date1, inSameDayAs: date2)
        return isSameDay
    }
    
    //extracting Year AndMonth for display...
    func extraData()->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: selectedDate)
        return date.components(separatedBy: " ")
        
        
    }

    
    
   
    
    func getCurrentMonth()->Date {
        
        guard
            let currentMonth = calendar.date(byAdding: .month,
                                             value: self.currentMonth,
                                             to: Date())
        else {return Date()}
        
        return currentMonth
    }
    
  
    
    
    func extractDate() -> [DateValue]  {
        //Getting Current Month Date...
        let currentMonth = getCurrentMonth()
        
        

        var days = currentMonth.getAllDates().compactMap { date ->  DateValue in
            //getting day...
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        //adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        
        for _ in 1..<firstWeekday {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
        
    }
    
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ssa"

        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"

        let time24 = df.string(from: date!)
        print(time24)
        return time24
    }
    
}

struct CustomDatePicker3_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

//Extending Date to get Current Month Dates..
extension Date {
//для початку місяця з 1 дня
func getAllDates() -> [Date] {
   
    //getting start Date...
    let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    
    let range = calendar.range(of: .day, in: .month, for: startDate)!
//        range.removeLast()
    
    //getting date
    
    return range.compactMap{ day -> Date in
        
        return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
    }
    
}
}
