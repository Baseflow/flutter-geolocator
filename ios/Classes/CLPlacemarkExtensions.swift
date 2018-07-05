//
//  CLPlacemarkExtensions.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    public func toDictionary() -> NSDictionary {
        return [
            "latitude" : self.location!.coordinate.latitude,
            "longitude" : self.location!.coordinate.longitude,
            "altitude" : self.location!.altitude
        ]
    }
}
