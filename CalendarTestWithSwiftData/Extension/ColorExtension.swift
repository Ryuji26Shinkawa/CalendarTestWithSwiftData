//
//  Color.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/23.
//
import SwiftUI

extension Color {
    /// 指定のColorListから色を生成する
    init (_ colorList: ColorList) {
        switch colorList {
        case .cyan:
            self.self = Color.cyan
        case .mint:
            self.self = Color.mint
        case .pink:
            self.self = Color.pink
        case .yellow:
            self.self = Color.yellow
        }
    }
}
