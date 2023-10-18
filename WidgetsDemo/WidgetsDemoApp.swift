//
//  WidgetsDemoApp.swift
//  WidgetsDemo
//
//  Created by Himanshu on 10/17/23.
//

import SwiftUI

@main
struct WidgetsDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    // app delegate:
        
    class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
        func application(_ application: UIApplication, 
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            let notificationCenter = UNUserNotificationCenter.current()
            // if You do not set delegate, does not work.
            notificationCenter.delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, _) in
                if !accepted {
                    print("Notification access denied")
                }
            }
            
            return true
        }
        
        // called after user has tapped on notification ballon.
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler:
                                    @escaping (UNNotificationPresentationOptions) -> Void) {
            TaskDataModel.shared.clearData { _ in
                completionHandler([.banner, .list, .badge, .sound])
            }
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            TaskDataModel.shared.clearData { _ in
                completionHandler()
            }
        }
    }
    
}
