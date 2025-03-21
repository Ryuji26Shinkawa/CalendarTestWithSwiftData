//
//  CustomDatePicker.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/16.
//

import SwiftUI
import SwiftData

struct CustomDatePicker: View {
    @Environment(\.modelContext) private var modelContext
    @Query var taskMetaData: [TaskMetaData]
    @State var currentMonth: Int = 0
    @State private var isEditing: Bool = false
    @State private var selectedTasks: [Task] = []
    @Binding var currentDate: Date

    var body: some View {
        VStack(spacing: 35) {
            // Header
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    // Year
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    // Month
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                Spacer(minLength: 0)
                // Back Button
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                // Next Button
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            // Day View
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }

            // Dates
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 50) {
                ForEach(extractDate()) { value in
                    // Each date View
                    CardView(value: value)
                    // Reverses the tapped area
                        .background(
                            Capsule()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(day1: value.date, day2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                } // ForEach
            } // LazyVGrid

            // Tasks 保存したタスクを表示する
            VStack(spacing: 20) {
                HStack {
                    Text("Task")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading )
                        .padding(.vertical, 20)
                    // 選択したタスクを削除するボタン
                    if !selectedTasks.isEmpty {
                        Button("delete") {
                            deleteSelectedTasks()
                            isEditing = false
                        }
                        .foregroundStyle(.red)
                        .transition(.move(edge: .trailing).combined(with: .opacity)) // 右からフェードイン
                    }
                    // 編集モードに切り替えるボタン
                    Button(isEditing ? "done" : "edit") {
                        isEditing.toggle()
                    }
                }
                // If the selected date and the date of the task are the same, display the task
                if let task = taskMetaData.first(where: { task in
                    return isSameDay(day1: task.taskDate, day2: currentDate)
                }) {
                    ForEach(task.task) { task in
                        HStack {
                            // 選択ボタンの表示
                            if isEditing {
                                Button {
                                    toggleSelection(task)
                                } label: {
                                    // チェック付きは"checkmark.circle.fill"で赤色
                                    Image(systemName: selectedTasks.contains(where: { $0 == task }) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedTasks.contains(where: { $0 == task }) ? .red :.gray)
                                        .font(.title3)
                                }
                                .transition(.opacity) // アニメーション付き
                                .onDisappear {
                                    // ボタンが非表示になったら選択していたタスクをリセット
                                    selectedTasks.removeAll()
                                }
                            }
                            // タスクの表示
                            VStack(alignment: .leading, spacing: 10) {
                                // Date型を.time(Text形式)で表示
                                Text(task.time, style: .time)
                                Text(task.title)
                                    .font(.title2.bold())
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Color(task.colorList)
                                    .opacity(0.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            )
                        }
                    }
                } else {
                    Text("No Task Found")
                }
            }
            .padding()
            .animation(.default, value: isEditing) // アニメーション適用
            .animation(.default, value: selectedTasks) // アニメーション適用
        } // Main VStack
        .onChange(of: currentMonth) {
            // update Month
            currentDate = getCurrentMonth()
        } // onChange
        .onChange(of: isEditing) { _, isEditing in
            // 編集モードが終わったら、選択したタスクを削除
            if isEditing == false {
                selectedTasks.removeAll()
            }
        }
    } // body

    @ViewBuilder
    private func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = taskMetaData.first(where: { task in
                    return isSameDay(day1: task.taskDate, day2: value.date)
                }) {
                    // タスクがある場合
                    // 日付が選択されたなら、数字を白反転
                    Text("\(value.day)")
                        .font(.title3)
                        .foregroundStyle(isSameDay(day1: task.taskDate, day2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    // タスク有無表示の⚫︎
                    Circle()
                        .fill(isSameDay(day1: task.taskDate, day2: currentDate) ? .white : Color.pink)
                        .frame(width: 8, height: 8)
                } else {
                    // タスクがない場合
                    // 自身が選択された日付なら、数字を白反転
                    Text("\(value.day)")
                        .font(.title3)
                        .foregroundStyle(isSameDay(day1: value.date, day2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }

    // checking dates
    private func isSameDay(day1: Date, day2: Date) -> Bool {
        let calender = Calendar.current
        return calender.isDate(day1, inSameDayAs: day2)
    }

    // extrating Year and Month for display
    private func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    /// 今月の情報を取得
    private func getCurrentMonth() -> Date {
        let calender = Calendar.current
        // Getting current Month
        guard let currentMonth = calender.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }

    private func extractDate() -> [DateValue] {
        let calender = Calendar.current
        // Getting current Month
        let currentMonth = getCurrentMonth()

        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            // getting date
            let day = calender.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        // adding offset days to get exact week day
        let firstWeekDay = calender.component(.weekday, from: days.first?.date ?? Date())
        // weekday分を取得した月の日数の始めに追加する
        // 日付の数字(day)は表示させないため全て-1とする
        for _ in 0..<(firstWeekDay - 1) {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }

        return days
    }
    /// 選択の切り替え
    private func toggleSelection(_ task: Task) {
        if selectedTasks.contains(task) {
            selectedTasks.removeAll(where: {$0 == task})
        } else {
            selectedTasks.append(task)
        }
    }
    /// 選択したタスクをまとめて削除
    private func deleteSelectedTasks() {
        for task in selectedTasks {
            modelContext.delete(task)
        }
        selectedTasks.removeAll() // 選択をリセット
    }
}

#Preview {
    CustomDatePicker(currentDate: Binding.constant(Date())
//                     taskMetaData: [
//                        TaskMetaData(
//                            task: [
//                                Task(title: "Talk to iJustine", time: Date.now, colorList: .cyan),
//                                Task(title: "iPhone13 Great Design Change", time: Date.now, colorList: .cyan),
//                                Task(title: "Nothing Much Workout", time: Date.now, colorList: .cyan),
//                            ],
//                            taskDate: getSampleData(offset: 1)
//                        ),
//                        TaskMetaData(
//                            task: [
//                                Task(title: "Talk to Jenna Ezarik", time: Date.now, colorList: .cyan)
//                            ],
//                            taskDate: getSampleData(offset: -3)
//                        ),
//                        TaskMetaData(
//                            task: [
//                                Task(title: "Meeting with Tim Cook", time: Date.now, colorList: .cyan),
//                            ],
//                            taskDate: getSampleData(offset: -8)
//                        )
//                     ]
    )
}

extension Date {
    ///
    func getAllDates() ->  [Date] {
        let calender = Calendar.current
        // getting start day
        // 年と月だけを指定して月初を出す
        let startDay = calender.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        // 月初から1ヶ月の範囲を洗い出す
        let range = calender.range(of: .day, in: .month, for: startDay)!
        // getting date
        return range.compactMap { day -> Date in
            calender.date(byAdding: .day, value: day - 1, to: startDay)!
        }
    }
}
