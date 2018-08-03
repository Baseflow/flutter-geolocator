//
//  TaskContext.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import Foundation

typealias ResultHandler = (_ result: Any?) -> ()

class TaskContext : NSObject {
    
    init(resultHandler: @escaping ResultHandler, arguments: Any?) {
        self.resultHandler = resultHandler
        self.arguments = arguments
    }
    
    let arguments: Any?
    let resultHandler: ResultHandler
}
