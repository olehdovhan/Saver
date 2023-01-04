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























