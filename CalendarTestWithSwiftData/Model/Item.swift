//
//  Item.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/11.
//

import Foundation
import SwiftData

@Model
final class Item {
    // CloudKitを使う場合は初期値を入れる必要がある
    var timestamp: Date = Date.now

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
