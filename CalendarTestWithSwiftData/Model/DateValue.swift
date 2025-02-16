//
//  DateValue.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/16.
//
import SwiftUI

struct DateValue: Identifiable {
    var id: String = UUID().uuidString
    var day: Int
    var date: Date
}
