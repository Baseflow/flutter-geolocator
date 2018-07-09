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
        var dict: Dictionary<String, Any> = [
            "name" : self.name ?? "",
            "isoCountryCode" : self.isoCountryCode ?? "",
            "country" : self.country ?? "",
            "thoroughfare" : self.thoroughfare ?? "",
            "subThoroughfare" : self.subThoroughfare ?? "",
            "postalCode" : self.postalCode ?? "",
            "administrativeArea" : self.administrativeArea ?? "",
            "subAdministrativeArea" : self.subAdministrativeArea ?? "",
            "locality" : self.locality ?? "",
            "subLocality" : self.subLocality ?? ""
        ]
        
        if let location = self.location {
            dict["location"] = location.toDictionary()
        }
        
        return dict as NSDictionary
    }
    
}
