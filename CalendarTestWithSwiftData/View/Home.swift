//
//  Home.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/16.
//

import SwiftUI
import SwiftData

struct Home: View {
    /// コンテクスト
    @Environment(\.modelContext) private var modelContext
    /// クエリ
    @Query var taskMetaData: [TaskMetaData]
    @State var currentDate: Date = Date()
    @State var isShowNewTaskView: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                CustomDatePicker(currentDate: $currentDate)
            }
            .padding(.vertical)
        }
        // Safe Area View
        .safeAreaInset(edge: .bottom) {
            HStack {
                // Add Button
                Button {
                    isShowNewTaskView.toggle()
                } label: {
                    Text("Add Task")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange, in: Capsule())
                        
                }
                // Add Remainder
                Button {
                    
                } label: {
                    Text("Add Remainder")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple, in: Capsule())
                        
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .foregroundStyle(.white)
            .background(.ultraThinMaterial)
        } // safeAreaInset
        .sheet(isPresented: $isShowNewTaskView) {
            NewTaskView(currentDate: $currentDate)
                .presentationDetents([.height(300)]) // サイズ指定でハーフモーダル
                .interactiveDismissDisabled() // 特定の条件下でsheetを閉じるの禁止
                .presentationCornerRadius(30)
        }
    } // body
}

#Preview {
    Home()
        .modelContainer(for: [TaskMetaData.self ,Task.self])
}
