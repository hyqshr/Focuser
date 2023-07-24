////
////  Notification.swift
////  Dad Jokes
////
////  Created by Yiqiu Huang on 7/23/23.
////
//
import Foundation
import Cocoa
import UserNotifications

class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
    let un = UNUserNotificationCenter.current()

    func pushWorkTimeDone() -> Void {
        un.requestAuthorization(options: [.alert, .sound]) {(authorized, error) in
            if authorized{
                print("Success Authorized! ")
            }else if !authorized{
                print("Not Authorized!")
            }
            else{
                print(error?.localizedDescription as Any)
            }
        }

        un.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .authorized{
                let content = UNMutableNotificationContent()

                content.title = "Break time!"
                content.subtitle = "Let's sip a water"
                content.body = "Work time done"
                content.sound = UNNotificationSound.default

                let id = "WorkTimeDone"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                self.un.add(request) {(error) in
                    if error != nil {print(error?.localizedDescription as Any)}
                }

            }

        }

    }


    func pushBreakTimeDone() -> Void {
        un.requestAuthorization(options: [.alert, .sound]) {(authorized, error) in
            if authorized{
                print("Success Authorized! ")
            }else if !authorized{
                print("Not Authorized!")

            }
            else{
                print(error?.localizedDescription as Any)
            }
        }

        un.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .authorized{
                let content = UNMutableNotificationContent()

                content.title = "Time to accomplish more!"
                content.subtitle = "Maybe change to a funny task..."
                content.body = "Enjoy da work"
                content.sound = UNNotificationSound.default

                let id = "BreakTimeDown"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                self.un.add(request) {(error) in
                    if error != nil {print(error?.localizedDescription as Any)}
                }

            }

        }

    }
}
