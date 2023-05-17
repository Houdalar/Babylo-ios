//
//  NotificationManager.swift
//  Babylo
//
//  Created by Babylo  on 7/5/2023.
//

import Foundation
import UserNotifications


class NotificationManager : NSObject , UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    private override init() {
            super.init()
        }
    
    func requestAuthorization() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("Failed to request authorization for notifications: \(error.localizedDescription)")
                }
            }
            
            UNUserNotificationCenter.current().delegate = self
        }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])
        }

}
