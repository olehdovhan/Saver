//
//  SpendingsCalendarViewModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 03.01.2023.
//

import SwiftUI

class SpendingsCalendarViewModel: ObservableObject {
    
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var monthOffset: CGSize = .zero
    @Published var dayOffset: CGSize = .zero
    
    var tasks: [TaskMetaData] = []
    
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
    
    var dayOfWeakArray: [String] { [sun, mon,tue, wed, thu, fri, sat] }
    var selectedDayOfWeak: String {
        let selectedDayOfWeak = dayOfWeakFormat.string(from: selectedDate)
        return selectedDayOfWeak
    }
    
    var offsetDayOfWeek: CGSize {
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
    
    init() {
        // fill tasks
        if let spendings = UserDefaultsManager.shared.userModel?.currentMonthSpendings {
            for spending in spendings {
                let thisDaySpents = spendings.filter({isSameDay(date1: $0.expenseDate,
                                                                date2: spending.expenseDate)})
                print(thisDaySpents.count)
                var tsks: [Task] = []
                for spent in thisDaySpents {
                    let task = Task(title: spent.spentCategory,
                                    valueUSD: String(Int(spent.amount)))
                    tsks.append(task)
                }
               let tsk = TaskMetaData(tasks: tsks,
                                      taskDate: spending.expenseDate)
                tasks.append(tsk)
            }
        }
//        tasks = [
////            TaskMetaData(tasks: [
////                Task(title: "To the bank card", valueUSD: "+300.00"),
////                Task(title: "To the bank card", valueUSD: "+154.89"),
////                Task(title: "Product", valueUSD: "-900.00")
////            ], taskDate: getSampleDate(offset: 0)),
//
//            TaskMetaData(tasks: [
//                Task(title: "Product", valueUSD: "+200.00")
//            ], taskDate: getSampleDate(offset: -2)),
//
//            TaskMetaData(tasks: [
//                Task(title: "Product", valueUSD: "+700.00")
//            ], taskDate: getSampleDate(offset: 15)),
//            //
//            TaskMetaData(tasks: [
//                Task(title: "To the bank card", valueUSD: "-1200.00")
//            ], taskDate: getSampleDate(offset: 0)),
//            //
//            TaskMetaData(tasks: [
//                Task(title: "To the bank card", valueUSD: "100.00")
//            ], taskDate: getSampleDate(offset: +18))
//            ]
    }
    //sample Date for Testing...
    func getSampleDate(offset: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: offset, to: Date())
        return date ?? Date()
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

    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.date(byAdding: .month,
                                               value: currentMonth,
                                             to: Date())
        else { return Date() }
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
