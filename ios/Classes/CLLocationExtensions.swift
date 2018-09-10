//
//  CLLocationExtensions.swift
//  flutter_geolocator
//
//  Created by Maurits Beusekom on 08/06/2018.
//

import Foundation
import CoreLocation

extension CLLocation {
    public func toDictionary() -> NSDictionary {
        return [
            "latitude" : self.coordinate.latitude,
            "longitude" : self.coordinate.longitude,
            "timestamp" : CLLocation.currentTimeInMilliSeconds(dateToConvert: self.timestamp),
            "altitude" : self.altitude,
            "accuracy" : self.horizontalAccuracy,
            "speed" : self.speed,
            "speed_accuracy" : 0.0
        ]
    }
    
    private static func currentTimeInMilliSeconds(dateToConvert: Date)-> Int
    {
        let since1970 = dateToConvert.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}
