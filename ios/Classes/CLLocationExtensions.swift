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
            "altitude" : self.altitude,
            "accuracy" : self.horizontalAccuracy,
            "speed" : self.speed,
            "speed_accuracy" : 0.0
        ]
    }
}
