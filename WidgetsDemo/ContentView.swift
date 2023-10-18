//
//  ContentView.swift
//  WidgetsDemo
//
//  Created by Himanshu on 10/17/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var taskTitle: String = ""
    @State private var completionTime = Date.now
    @State private var showConfirmation: Bool = false
    @State private var taskViewWidth: CGFloat = 200
    @State private var taskViewHeight: CGFloat = 150
    
    @State var taskData: TaskModel?
    
    @State var deleteConfirmation: Bool = false
    @State var completeConfirmation: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
                
                Text("Enter Your Task & Time")
                    .padding(.top)
                    .padding(.bottom, 2)
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text("Give a descriptive name to your task and provide task completion time.")
                    .padding(.bottom, 10)
                    .font(.caption2)
                    .fontWeight(.light)
                
                Group {
                    TextField("Enter a task or activity...", text: $taskTitle)
                    DatePicker("Set completion Time", 
                               selection: $completionTime, 
                               in: Date.now...,
                               displayedComponents: .hourAndMinute)
                }
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(8)
                .font(.caption)
                
                Button(action: {
                    TaskDataModel
                        .shared
                        .saveTask(
                            task: TaskModel(taskTitle: taskTitle, completionTime: completionTime)
                        ) { saved in
                        if saved {
                            print("Task Started: \(saved)")
                            taskTitle = ""
                            completionTime = .now
                            taskData = TaskDataModel.shared.getTasks()
                        }
                    }
                }, label: {
                    Text("Start Task")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                })
                .padding()
                .background(!taskTitle.isEmpty ? .blue : .blue.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(taskTitle.isEmpty)
                
                if let taskData {
                    Divider()
                        .padding(.vertical)
                    
                    Text("Current Task")
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(taskData.taskTitle)")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .lineLimit(3)
                        Text("Completion Time: \(taskData.completionTime.formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .fontWeight(.light)
                            .lineLimit(2)
                    }
                    .padding()
                    .frame(width: taskViewWidth, height: taskViewHeight)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onLongPressGesture {
                        withAnimation {
                            taskViewWidth = 230
                            taskViewHeight = 170
                        }
                        showConfirmation = true
                    }
                }
                
                Spacer()
            }
        .frame(maxWidth: .infinity)
        .padding()
        .onAppear {
            taskData = TaskDataModel.shared.getTasks()
        }
        .confirmationDialog("Delete Task", isPresented: $deleteConfirmation) {
            Button("Delete", role: .destructive) {
                TaskDataModel.shared.clearData { cleared in
                    print("Task Deleted: \(cleared)")
                    taskData = TaskDataModel.shared.getTasks()
                }
            }
            Button("Cancel", role: .cancel) {
                withAnimation {
                    taskViewWidth = 200
                    taskViewHeight = 150
                }
            }
        } message: { Text("Are you sure you want to delete this Task?") }
        .confirmationDialog("Mark Task as Completed", isPresented: $completeConfirmation) {
            Button("Finish") {
                TaskDataModel.shared.clearData { cleared in
                    print("Task Finished: \(cleared)")
                    taskData = TaskDataModel.shared.getTasks()
                }
            }
            Button("Cancel", role: .cancel) {
                withAnimation {
                    taskViewWidth = 200
                    taskViewHeight = 150
                }
            }
        } message: { Text("Mark this Task as finished") }
        .confirmationDialog("Change background", isPresented: $showConfirmation) {
            Button("Delete Task", role: .destructive) {
                deleteConfirmation.toggle()
            }
            Button("Finish Task") {
                // temporary functionality, note: we're not saving completed tasks
                completeConfirmation.toggle()
            }
            Button("Dismiss", role: .cancel) {
                withAnimation {
                    taskViewWidth = 200
                    taskViewHeight = 150
                }
            }
        } message: {}
    }
}

#Preview {
    ContentView()
}
