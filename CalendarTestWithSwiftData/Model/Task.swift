//
//  Task.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/16.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
    var color: Color = .cyan
}

struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}

/// 今日から指定した日数分だけシフトした日付を返す
func getSampleData(offset: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}

/// サンプルデータ
var tasks: [TaskMetaData] = [
    TaskMetaData(
        task: [
            Task(title: "Talk to iJustine"),
            Task(title: "iPhone13 Great Design Change"),
            Task(title: "Nothing Much Workout"),
        ],
        taskDate: getSampleData(offset: 1)
    ),
    TaskMetaData(
        task: [
            Task(title: "Talk to Jenna Ezarik")
        ],
        taskDate: getSampleData(offset: -3)
    ),
    TaskMetaData(
        task: [
            Task(title: "Meeting with Tim Cook"),
        ],
        taskDate: getSampleData(offset: -8)
    )
]
