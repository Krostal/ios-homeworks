

import UIKit

final class LocalNotificationsService: NSObject {
    
    private let center = UNUserNotificationCenter.current()
    
    func registerForLatestUpdatesIfPossible() {
        
        registerUpdatesCategory()
        
        center.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { (granted, error) in
            if granted {
                self.addNotification()
            } else {
                print("Access to notifications not granted")
            }
        }
    }
    
    private func addNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "'Navigation' " + "updates".localized
        content.body = "Check out the latest updates".localized
        content.categoryIdentifier = "updates"
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
    }
    
//    func checkStatus(completion: @escaping (Bool) -> Void) {
//        center.getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//            case .notDetermined:
//                return completion(false)
//            case .denied:
//                return completion(false)
//            case .authorized:
//                return completion(true)
//            case .provisional:
//                return completion(true)
//            case .ephemeral:
//                return completion(false)
//            @unknown default:
//                return completion(false)
//            }
//        }
//    }
    
    func registerUpdatesCategory() {
        
        let actionDelete = UNNotificationAction(identifier: "actionDelete", title: "delete".localized, options: [])
        
        let updatesCategory = UNNotificationCategory(identifier: "updates", actions: [actionDelete], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([updatesCategory])
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.categoryIdentifier == "updates" {
            center.removeDeliveredNotifications(withIdentifiers: ["updates"])
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler()
    }
}
