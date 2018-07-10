//
//  GeocodingService.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import CoreLocation
import Foundation

class GeocodeTask: NSObject {
    private var _address: String?
    
    required init(context: TaskContext,
         completionHandler: CompletionHandler?) {
        
        self.taskID = UUID.init()
        self.context = context
        self.completionHandler = completionHandler
    }
    
    let taskID: UUID
    let context: TaskContext
    let completionHandler: CompletionHandler?
   
    func stopTask() {
        guard let action = completionHandler else { return }
        action(taskID)
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
    
    func handleError(code: String, message: String) {
        self.context.resultHandler(FlutterError.init(
            code: code,
            message: message,
            details: nil))
    }
    
}

class ForwardGeocodeTask: GeocodeTask, TaskProtocol {
    private var _address: String?
    
    required init(context: TaskContext,
                  completionHandler: CompletionHandler?) {

        super.init(context: context,
                   completionHandler: completionHandler)
        
        parseAddress(arguments: context.arguments)
    }
    
    func parseAddress(arguments: Any?) {
        if let address = context.arguments as? String {
            _address = address
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
        geocoding.geocodeAddressString(address) { (placemarks, error) in
            if let marks = placemarks {
                self.processPlacemark(placemarks: marks);
                return
            }
            
            if let err = error {
                self.handleError(
                    code: "ERROR_GEOCODING_ADDRESS",
                    message: err.localizedDescription)
            }
            
            stopTask();
        }
    }
}

class ReverseGeocodeTask: GeocodeTask, TaskProtocol {
    private var _location: CLLocation?
    
    required init(context: TaskContext,
                  completionHandler: CompletionHandler?) {
        
        super.init(context: context,
                   completionHandler: completionHandler)
        
        parseLocation(arguments: context.arguments)
    }
    
    func parseLocation(arguments: Any?) {
        if let location = context.arguments as! NSDictionary? {
            let latitude = location.object(forKey: "latitude") as! CLLocationDegrees
            let longitude = location.object(forKey: "longitude") as! CLLocationDegrees
            
            _location = CLLocation.init(latitude: latitude, longitude: longitude)
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
        geocoding.reverseGeocodeLocation(location) { (placemarks, error) in
            if let marks = placemarks {
                self.processPlacemark(placemarks: marks);
                return
            }
            
            if let err = error {
                self.handleError(
                    code: "ERROR_REVERSEGEOCODING_LOCATION",
                    message: err.localizedDescription)
            }
            
            stopTask();
        }
    }
}
