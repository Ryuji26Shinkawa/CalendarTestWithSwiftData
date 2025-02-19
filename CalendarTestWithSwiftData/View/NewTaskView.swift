//
//  NewTaskView.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/19.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskColor: Color = .cyan
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
    }
}

#Preview {
    NewTaskView()
}
