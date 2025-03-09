//
//  ColorList.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/26.
//
import SwiftUI
///  SwiftData保存用のカラーリスト、Codableに対応
enum ColorList: String, CaseIterable, Codable {
    case cyan
    case mint
    case yellow
    case pink

    init(color: Color) {
        switch color {
        case .cyan:
            self = .cyan
        case .mint:
            self = .mint
        case .yellow:
            self = .yellow
        case .pink:
            self = .pink
        default:
            self = .cyan
        }
    }
}
