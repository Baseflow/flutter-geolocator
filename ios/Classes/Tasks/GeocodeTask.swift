//
//  GeocodingService.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import CoreLocation
import Foundation

class GeocodeTask: Task {   
    required init(context: TaskContext,
         completionHandler: CompletionHandler?) {

        super.init(context: context,
                   completionHandler: completionHandler)
    }
    
    func geocodeCompletionHandler(placemarks: [CLPlacemark]?, errorCode: String, error: Error?) {
        if let marks = placemarks {
            self.processPlacemark(placemarks: marks);
        }
        
        if let err = error {
            self.handleError(
                code: errorCode,
                message: err.localizedDescription)
        }
        
        self.stopTask();
    }
    
    func processPlacemark(placemarks: [CLPlacemark]) {
        var locations: [NSDictionary] = []
        for placemark in placemarks {
            locations.append(placemark.toDictionary())
        }
        
        if locations.count > 0 {
            context.resultHandler(locations)
        } else {
            handleError(
                code: "ERROR_GEOCODING_ADDRESSNOTFOUND",
                message: "Could not find any result for the supplied address or coordinates.")
        }
    }
}

class ForwardGeocodeTask: GeocodeTask, TaskProtocol {
    private var _address: String?
    private var _locale: Locale?
    
    required init(context: TaskContext,
                  completionHandler: CompletionHandler?) {

        super.init(context: context,
                   completionHandler: completionHandler)
        
        parseArguments(arguments: context.arguments)
    }
    
    func parseArguments(arguments: Any?) {
        if let argumentMap = context.arguments as! NSDictionary? {
            _address = argumentMap["address"] as? String
            
            if let localeIdentifier = argumentMap["localeIdentifier"] {
                _locale = Locale(identifier: localeIdentifier as! String)
            }
        } else {
            _address = nil
        }
    }
    
    func startTask() {
        guard let address = _address else
        {
            handleError(
                code: "NO_ADDRESS_SUPPLIED",
                message: "Please supply a valid string containing the address to lookup")
            
            stopTask()
            return
        }
        
        geocodeAddress(address: address)
    }
    
    private func geocodeAddress(address: String) {
        
        let geocoding = CLGeocoder.init()
        if #available(iOS 11.0, *) {
            geocoding.geocodeAddressString(address, in: nil, preferredLocale: _locale) {(placemarks, error) in
                self.geocodeCompletionHandler(placemarks: placemarks, errorCode: "ERROR_GEOCODING_ADDRESS", error: error)
            }
        } else {
            var defaultLanguages: [String]?
            if let locale = _locale {
                defaultLanguages = UserDefaults.standard.array(forKey: "AppleLanguages") as? [String]
                UserDefaults.standard.set([locale.languageCode], forKey: "AppleLanguages")
            }
            
            geocoding.geocodeAddressString(address) { (placemarks, error) in
                self.geocodeCompletionHandler(placemarks: placemarks, errorCode: "ERROR_GEOCODING_ADDRESS", error: error)
                
                if self._locale != nil {
                    UserDefaults.standard.set(defaultLanguages, forKey: "AppleLanguages")
                }
            }
        }
    }
}

class ReverseGeocodeTask: GeocodeTask, TaskProtocol {
    private var _location: CLLocation?
    private var _locale: Locale?
    
    required init(context: TaskContext,
                  completionHandler: CompletionHandler?) {
        
        super.init(context: context,
                   completionHandler: completionHandler)
        
        parseArguments(arguments: context.arguments)
    }
    
    func parseArguments(arguments: Any?) {
        if let argumentMap = context.arguments as! NSDictionary? {
            let latitude = argumentMap["latitude"] as! CLLocationDegrees
            let longitude = argumentMap["longitude"] as! CLLocationDegrees
            
            _location = CLLocation.init(latitude: latitude, longitude: longitude)
            
            if let localeIdentifier = argumentMap["localeIdentifier"] {
                _locale = Locale(identifier: localeIdentifier as! String)
            }
        } else {
            _location = nil
        }
    }
    
    func startTask() {
        guard let location = _location else
        {
            handleError(
                code: "NO_COORDINATES_SUPPLIED",
                message: "Please supply valid latitude and longitude values.")
            
            stopTask()
            return
        }
        
        reverseToAddress(location: location)
    }
    
    private func reverseToAddress(location: CLLocation) {
        
        let geocoding = CLGeocoder.init()
        
        if #available(iOS 11.0, *) {
            geocoding.reverseGeocodeLocation(location, preferredLocale: _locale) { (placemarks, error) in
                self.geocodeCompletionHandler(placemarks: placemarks, errorCode: "ERROR_REVERSEGEOCODING_LOCATION", error: error)
            }
        } else {
            var defaultLanguages: [String]?
            if let locale = _locale {
                defaultLanguages = UserDefaults.standard.array(forKey: "AppleLanguages") as? [String]
                UserDefaults.standard.set([locale.languageCode], forKey: "AppleLanguages")
            }
            
            geocoding.reverseGeocodeLocation(location)  { (placemarks, error) in
                self.geocodeCompletionHandler(placemarks: placemarks, errorCode: "ERROR_REVERSEGEOCODING_LOCATION", error: error)
                
                if self._locale != nil {
                    UserDefaults.standard.set(defaultLanguages, forKey: "AppleLanguages")
                }
            }
        }
    }
}
