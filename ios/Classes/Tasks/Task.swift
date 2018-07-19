//
//  Task.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 18/07/2018.
//

import Foundation

class Task: NSObject {
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
    
    func handleError(code: String, message: String) {
        self.context.resultHandler(FlutterError.init(
            code: code,
            message: message,
            details: nil))
    }
    
}
