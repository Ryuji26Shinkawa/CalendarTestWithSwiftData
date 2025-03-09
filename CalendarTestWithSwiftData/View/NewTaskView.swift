//
//  NewTaskView.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/19.
//

import SwiftUI
import SwiftData

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query var taskMetaData: [TaskMetaData]
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskColor: Color = .cyan
    @Binding var currentDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            } // Button for dismiss
            .frame(maxWidth: .infinity, alignment: .leading)

            // タスク名
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                TextField("Go for a Walk!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(
                        .white.shadow(.drop(color: .black.opacity(0.25), radius: 2)),
                        in: .rect(cornerRadius: 10)
                    )
            } // Title block (First block)
            .padding(.top, 5)

            HStack(spacing: 12) {
                // タスク日付
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                } // Date block
                .padding(.top, 5)
//                .padding(.leading, -15)

                // タスク色
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    let colors = [Color.cyan, Color.mint, Color.yellow, Color.pink]
                    HStack(spacing: 0) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(color == taskColor ? 1 : 0)
                                    
                                }
                                .onTapGesture {
                                    withAnimation {
                                        taskColor = color
                                    }
                                }
                        }
                    }
                } // Task color block
                .padding(.top, 5)
            } // Second block

            Button {
                addTask(context: modelContext, for: self.taskDate)
                dismiss()
            } label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 12)
                    .background(taskColor, in: .rect(cornerRadius: 10))
            }
            .disabled(taskTitle.isEmpty)
            .opacity(taskTitle.isEmpty ? 0.5 : 1)
        }
        .padding(15)
        .onAppear {
            taskDate = currentDate
        }
    } // body

    private func addTask(context: ModelContext, for date: Date) {
        withAnimation {
            let newTask = Task(
                title: self.taskTitle,
                time: self.taskDate,
                colorList: ColorList(color: self.taskColor)
            )
            print("登録したタスク色:\(newTask.colorList)")
            // すでにタスクがある場合
            if let existingTaskMetaData = fetchTaskMetaData(context: context, for: date) {
                newTask.parent = existingTaskMetaData
                existingTaskMetaData.task.append(newTask)
                context.insert(existingTaskMetaData)
                try? context.save()
            } else { // まだタスクがない場合
                let newTaskMetaData = TaskMetaData(
                    task: [], taskDate: self.taskDate
                )
                newTask.parent = newTaskMetaData
                newTaskMetaData.task.append(newTask)
                context.insert(newTaskMetaData)
                try? context.save()
            }
        }
    } // addTask
    private func fetchTaskMetaData(context: ModelContext, for date: Date) -> TaskMetaData? {
        /// ユーザの現在のカレンダー設定を取得
        let calendar = Calendar.current
        /// 日付の開始時刻 (00:00:00)
        let startOfDay = calendar.startOfDay(for: date)
        /// 翌日の00:00:00/
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let descriptor = FetchDescriptor<TaskMetaData>(
            predicate: #Predicate { taskMetaData in
                taskMetaData.taskDate >= startOfDay && taskMetaData.taskDate < endOfDay
            },
            sortBy: [SortDescriptor(\TaskMetaData.taskDate, order: .forward)] // 日付順でソート
        )
        
        return try? context.fetch(descriptor).first  // 最初の一致データを返す
    } // fetchTaskMetaData
}

#Preview {
    NewTaskView(currentDate: Binding.constant(Date()))
}
