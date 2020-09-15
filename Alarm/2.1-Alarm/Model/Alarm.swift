//
//  Alarm.swift
//  2.1-Alarm
//
//  Created by Jason Koceja on 9/14/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import Foundation

class Alarm : Codable {
    var fireDate: Date
    var name: String
    var enabled: Bool
    let uuid: String
    var fireTimeAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self.fireDate)
    }
    
    init(fireDate: Date, name: String, enabled: Bool) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = UUID().uuidString
    }

}

extension Alarm : Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate &&
            lhs.name == rhs.name &&
            lhs.enabled == rhs.enabled &&
            lhs.uuid == rhs.uuid
    }
}
