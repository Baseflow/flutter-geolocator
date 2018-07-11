//
//  Codec.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 11/07/2018.
//

import Foundation

struct Codec {
    private static let jsonDecoder = JSONDecoder()
    
    static func decodeLocationOptions(from arguments: Any?) -> LocationOptions {
        return try! jsonDecoder.decode(LocationOptions.self, from: (arguments as! String).data(using: .utf8)!)
    }
}
