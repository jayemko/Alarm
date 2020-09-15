//
//  AlarmController.swift
//  2.1-Alarm
//
//  Created by Jason Koceja on 9/14/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit

protocol AlarmScheduler : AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    // MARK: - Alarm Scheduler Protocol
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm!"
        content.subtitle = "Times up"
        content.body = alarm.name
        content.badge = 1
        content.sound = .default
        
        let notificationIdentifier = alarm.uuid
        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents(in: .current, from: alarm.fireDate)
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: alarm.fireDate)
        dateComponents.minute = calendar.component(.minute, from: alarm.fireDate)
        dateComponents.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Function: \(#function), line: \(#line)")
            print(request.description)
            print(error ?? "There was an error")
            print(error?.localizedDescription ?? "There was an error")
            print("There was an error with creating a scheduled notification")
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        //
        let indentifier = alarm.uuid
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [indentifier])
    }
}


class AlarmController : AlarmScheduler {
    
    static var shared: AlarmController = AlarmController()
    var alarms: [Alarm] = []
    
    init(){
        // debug with mock alarms
        self.alarms = mockAlarms
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            AlarmController.shared.scheduleUserNotifications(for: alarm)
        } else {
            AlarmController.shared.cancelUserNotifications(for: alarm)
        }
        saveToPersistentStorage()
    }
    
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        saveToPersistentStorage()
        if enabled {
            scheduleUserNotifications(for: newAlarm)
        }
        return newAlarm
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStorage()
        if enabled {
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        }
    }
    
    func delete(alarm: Alarm){
        guard let index = alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: index)
        saveToPersistentStorage()
    }
    
    var mockAlarms: [Alarm] {
        let alarm1 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 3600), name: "Work", enabled: true)
        let alarm2 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 7200), name: "School", enabled: false)
        let alarm3 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 10800), name: "Eat", enabled: false)
        let alarm4 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 21600), name: "Sleep", enabled: true)
        return [alarm1, alarm2, alarm3, alarm4]
    }
    
    func fileUrl() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls[0].appendingPathComponent("alarms.json")
        return fileUrl
    }

    func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsondAlarms = try jsonEncoder.encode(alarms)
            try jsondAlarms.write(to: fileUrl())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }

    func loadFromPersistentStorage() {
        let jsonDecoder = JSONDecoder()

        do {
            let jsonData = try Data(contentsOf: fileUrl())
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: jsonData)
            alarms = decodedAlarms
        }catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
