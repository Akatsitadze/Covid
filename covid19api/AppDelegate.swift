//
//  AppDelegate.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        return true
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
                print("Permission granted: \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

}

