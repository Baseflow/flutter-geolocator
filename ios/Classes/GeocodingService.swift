//
//  GeocodingService.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import CoreLocation
import Foundation

class GeocodingService : NSObject, TaskProtocol {
    private var _address: String?
    
    required init(context: TaskContext,
         completionHandler: ((String) -> ())?) {
        
        self.context = context
        self.completionHandler = completionHandler
        
        super.init()
        
        if let address = context.arguments as? String {
            _address = address
        } else {
            _address = nil
        }
    }
    
    let context: TaskContext
    let completionHandler: CompletionHandler?
    
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
    
    func stopTask() {
        guard let action = completionHandler else { return }
        action(context.taskID)
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
            
        }
    }
    
    private func processPlacemark(placemarks: [CLPlacemark]) {
        var locations: [NSDictionary] = []
        for placemark in placemarks {
            locations.append(placemark.toDictionary())
        }
        
        if locations.count > 0 {
            context.resultHandler(locations)
        }
    }
    
    private func handleError(code: String, message: String) {
        self.context.resultHandler(FlutterError.init(
            code: code,
            message: message,
            details: nil))
    }
    
}
