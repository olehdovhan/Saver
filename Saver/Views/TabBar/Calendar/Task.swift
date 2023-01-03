//
//  Task.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 20.12.2022.
//

import Foundation

import SwiftUI

//Task Model and Sample Tasks...

struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
    var valueUSD: String
}

//Total Task Meta View
struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var tasks: [Task]
    var taskDate: Date

}

//sample Date for Testing...
func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}
    
//var tasks: [TaskMetaData] = [
//TaskMetaData(tasks: [
//    Task(title: "To the bank card", valueUSD: "+300.00"),
//    Task(title: "To the bank card", valueUSD: "+154.89"),
//    Task(title: "Product", valueUSD: "-900.00")
//], taskDate: getSampleDate(offset: 0)),
//
//TaskMetaData(tasks: [
//    Task(title: "Product", valueUSD: "+200.00")
//], taskDate: getSampleDate(offset: -2)),
//
//TaskMetaData(tasks: [
//    Task(title: "Product", valueUSD: "+700.00")
//], taskDate: getSampleDate(offset: 15)),
////
//TaskMetaData(tasks: [
//    Task(title: "To the bank card", valueUSD: "-1200.00")
//], taskDate: getSampleDate(offset: 0)),
////
//TaskMetaData(tasks: [
//    Task(title: "To the bank card", valueUSD: "100.00")
//], taskDate: getSampleDate(offset: +18))
//]






















