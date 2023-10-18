//
//  WidgetsExtension.swift
//  WidgetsExtension
//
//  Created by Himanshu on 10/17/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(taskInfo: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = TaskDataModel.shared.getTasks()
        completion(SimpleEntry(taskInfo: entry))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries = TaskDataModel.shared.getTasks()
        let timeline = Timeline(
            entries: [SimpleEntry(taskInfo: entries)], 
            policy: .after(entries?.completionTime ?? Date.now)
        )
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
    let taskInfo: TaskModel?
}

struct WidgetsExtensionEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let task = entry.taskInfo?.taskTitle, let time = entry.taskInfo?.completionTime {
                
                Gauge(value: 0.7, label: {
                Text("Task: \(task)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
                Text("Complete before \(time.formatted(date: .omitted, time: .shortened))")
                    .padding(.top, 10)
                    .font(.caption)
                    .lineLimit(2)
            } else {
                Text("You don't have any ongoing Activity or Task")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

        }
    }
}

struct WidgetsExtension: Widget {
    let kind: String = "WidgetsExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetsExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetsExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,

            // Add Support to Lock Screen widgets
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

#Preview(as: .systemSmall) {
    WidgetsExtension()
} timeline: {
    SimpleEntry(taskInfo: TaskModel(taskTitle: "Task 1", completionTime: Date.now))
}
