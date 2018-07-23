//
//  LocationOptions.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 11/07/2018.
//

import Foundation
import CoreLocation

struct LocationOptions : Codable {
    init() {
        self.accuracy = GeolocationAccuracy.best
        self.distanceFilter = 0
    }
    
    var accuracy: GeolocationAccuracy
    var distanceFilter: CLLocationDistance
}

enum GeolocationAccuracy : String, Codable {
    case lowest = "lowest"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case best = "best"
    case bestForNavigation = "bestForNavigation"
    
    var clValue: CLLocationAccuracy {
        switch self {
        case .lowest:
            return kCLLocationAccuracyThreeKilometers
        case .low:
            return kCLLocationAccuracyKilometer
        case .medium:
            return kCLLocationAccuracyHundredMeters
        case .high:
            return kCLLocationAccuracyNearestTenMeters
        case .best:
            return kCLLocationAccuracyBest
        case .bestForNavigation:
            return kCLLocationAccuracyBestForNavigation
        }
    }
}
