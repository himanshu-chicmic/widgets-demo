//
//  TaskModel.swift
//  TestPlaygroundSwiftUI
//
//  Created by Himanshu on 10/16/23.
//

import SwiftUI
import WidgetKit

struct TaskModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    let taskTitle: String
    let completionTime: Date
    var isCompleted: Bool = false
}

class TaskDataModel {
    static let shared = TaskDataModel()
    private var userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.example.WidgetsDemo")!
    // read data
    func getTasks() -> TaskModel? {
        if let data = userDefaults.object(forKey: "taskData") as? Data,
           let task = try? JSONDecoder().decode(TaskModel.self, from: data) {
             return task
        }
        return nil
    }
    // update data
    func saveTask(task: TaskModel, saved: (Bool) -> Void) {
        if let encoded = try? JSONEncoder().encode(task) {
            userDefaults.setValue(encoded, forKey: "taskData")
            userDefaults.synchronize()
            setTaskCompletionNotification(task: task)
            WidgetCenter.shared.reloadAllTimelines()
            saved(true)
        }
    }
    // clear user defaults
    func clearData(cleared: (Bool) -> Void) {
        userDefaults.removeObject(forKey: "taskData")
        WidgetCenter.shared.reloadAllTimelines()
        cleared(true)
    }
    // setup notifcation
    func setTaskCompletionNotification(task: TaskModel) {
        // get the notification center
        let center =  UNUserNotificationCenter.current()

        // create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Task Time Out"
        content.subtitle = task.taskTitle
        content.body = "Your task list is empty now, try adding new tasks."
        content.sound = UNNotificationSound.default

        // notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: task.completionTime.timeIntervalSinceNow,
            repeats: false
        )

        // create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)

        // add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
}
