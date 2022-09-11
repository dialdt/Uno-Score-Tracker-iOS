//
//  UnoDataManager.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 21/08/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

struct UnoGlobalFunctions {
    
    static func convertTimestampToTimeInterval(using data: Timestamp) -> TimeInterval {
        //var outputDate: Date = Date(timeIntervalSince1970: 0)
        if let timestamp = data as? Timestamp {
            let date = timestamp.dateValue()
            let timeInSeconds = timestamp.seconds
            //print("time in seconds", timeInSeconds)
            return TimeInterval(timeInSeconds)
        }
    }

}
