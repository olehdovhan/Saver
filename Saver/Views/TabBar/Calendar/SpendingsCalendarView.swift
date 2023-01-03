//
//  CustomDatePicker3.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 20.12.2022.
//

import SwiftUI

struct SpendingsCalendarView: View {
    
    @ObservedObject private var viewModel = SpendingsCalendarViewModel()
    
    var body: some View {
        VStack(spacing: 10){
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        viewModel.currentMonth -= 1
                    }
                } label: {
                    Text(viewModel.pastMonthDate, format: Date.FormatStyle().month(.abbreviated))
                        .font(.custom("NotoSans-Regular", size: 14, relativeTo: .body))
                }
                Spacer()
                Text(viewModel.selectedDate, format: Date.FormatStyle().month(.abbreviated))
                    .font(.custom("NotoSans-Bold", size: 18, relativeTo: .body))
                Spacer()
                Button {
                    withAnimation {
                        viewModel.currentMonth += 1
                    }
                } label: {
                    Text(viewModel.futureMonthDate, format: Date.FormatStyle().month(.abbreviated))
                        .font(.custom("NotoSans-Regular", size: 14, relativeTo: .body))
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(hex: "EDECEC"))
                    .frame(height: 5)
                
                RoundedRectangle(cornerRadius: 50)
                    .fill(LinearGradient(colors: [Color(hex: "#90DE58"), Color(hex: "#5CCCCC")], startPoint: .leading, endPoint: .trailing))
                    .frame(width: UIScreen.main.bounds.width / 5, height: 5)
                    .offset(x: viewModel.monthOffset.width)
            }
            // Days of Week...
            HStack(spacing: 0) {
                ForEach(viewModel.dayOfWeakArray, id: \.self) { day in
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
                ForEach(viewModel.extractDate()) {value in
                    cardView(value: value)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(viewModel.isSameDay(date1: value.date,
                                                  date2: viewModel.selectedDate) ? .green : .gray.opacity(0.3),
                                        lineWidth: viewModel.isSameDay(date1: value.date,
                                                             date2: viewModel.selectedDate) ? 2 : 1)
                        }
                        .onTapGesture {
                            print("value = \(value)")
                            print("selectedDate = \(value.date)")
                            viewModel.selectedDate = value.date
                            let kkk = transactions[2].date
                            let check = viewModel.isSameDay(date1: kkk ,
                                                            date2: viewModel.selectedDate)
                            print(check)
                        }
                }
            }
            .offset(x: viewModel.monthOffset.width)
            .gesture(monthDragGesture)
            
            VStack(spacing: 7) {
                Text(viewModel.selectedDate, format: Date.FormatStyle().month(.abbreviated).day())
                    .font(.custom("NotoSans-SemiBold", size: 18, relativeTo: .body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color(hex: "EDECEC"))
                        .frame(height: 5)
                    
                    HStack{
                        
                        RoundedRectangle(cornerRadius: 50)
                            .fill(LinearGradient(colors: [Color(hex: "#90DE58"), Color(hex: "#5CCCCC")], startPoint: .leading, endPoint: .trailing))
                            .frame(width: viewModel.lengthDay, height: 5)
                            .offset(x: viewModel.offsetDayOfWeek.width)
                        Spacer()
                    }
                }
                VStack(spacing: 12){
                    if let task = viewModel.tasks.first(where: { task in
                        return viewModel.isSameDay(date1: task.taskDate,
                                                   date2: viewModel.selectedDate)
                    }){
                        
                        ForEach(task.tasks) { task in
                            HStack(spacing: 0){
                                HStack{
                                    let timeTask12 = task.time.addingTimeInterval(CGFloat.random(in: 0...5000))
                                
                                    Text(viewModel.timeFormat24.string(from: timeTask12))
                                        .foregroundColor(Color(hex: "A9A9A9"))
                                    .multilineTextAlignment(.leading)
                                    .font(.custom("Lato-Regular", size: 16, relativeTo: .body))
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
                         Text("No Transaction Found")
                            .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                    }
                }
                .padding(.top, 22)
                .offset(x: viewModel.dayOffset.width)
                .gesture(dayDragGesture)
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 30)
        .onChange(of: viewModel.currentMonth) { newValue in
            withAnimation {
                viewModel.selectedDate = viewModel.getCurrentMonth()
            }
        }
    }
    
    var monthDragGesture: some Gesture{
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged({ value in
                withAnimation(Animation.linear(duration: 0.5)) {
                    if abs(value.translation.width) < UIScreen.main.bounds.width / 3 {
                        self.viewModel.monthOffset = value.translation
                    }
                }
            })
            .onEnded({ value in
                if value.translation.width > 0 {
                    if value.translation.width > 100{
                        print("future")
                        self.viewModel.currentMonth += 1
                    }
                } else if value.translation.width < 0 {
                    if value.translation.width < 100 {
                        self.viewModel.currentMonth -= 1
                    }
                }
                withAnimation(Animation.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.7)) {
                    self.viewModel.monthOffset = .zero
                }
            })
    }
    
    var dayDragGesture: some Gesture{
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged({ value in
                withAnimation(Animation.linear(duration: 0.5)) {
                    if abs(value.translation.width) < UIScreen.main.bounds.width / 3 {
                        self.viewModel.dayOffset = value.translation
                    }
                }
            })
            .onEnded({ value in
                if value.translation.width > 0 {
                    if value.translation.width > 100{
                        self.viewModel.selectedDate = viewModel.futureDayDate
                    }
                } else if value.translation.width < 0 {
                    if value.translation.width < 100 {
                        self.viewModel.selectedDate = viewModel.pastDayDate
                    }
                }
                withAnimation(Animation.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.7)) {
                    self.viewModel.dayOffset = .zero
                }
            })
    }
    
    @ViewBuilder
    func cardView(value: DateValue) -> some View {

        VStack{
            if value.day != -1 {
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
                                viewModel.isSameDay(date1: $0.date, date2: viewModel.selectedDate)
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
}

struct CustomDatePicker3_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

