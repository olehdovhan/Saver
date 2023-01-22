//
//  Date+Extension.swift
//  Saver
//
//  Created by Oleh Dovhan on 03.01.2023.
//

import SwiftUI

// MARK: - GetAllDates
extension Date {
func getAllDates() -> [Date] {
    
    let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    
    let range = calendar.range(of: .day, in: .month, for: startDate)!
    
    return range.compactMap{ day -> Date in
        return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
    }
}
}
