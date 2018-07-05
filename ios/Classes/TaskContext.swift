//
//  TaskContext.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import Foundation

typealias ResultHandler = (_ result: Any) -> ()

class TaskContext : NSObject {
    
    init(taskID: String, resultHandler: @escaping ResultHandler, arguments: Any?) {
        self.taskID = taskID
        self.resultHandler = resultHandler
        self.arguments = arguments
    }
    
    let taskID: String
    let arguments: Any?
    let resultHandler: ResultHandler
}
