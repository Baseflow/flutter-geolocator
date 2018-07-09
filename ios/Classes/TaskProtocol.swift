//
//  TaskProtocol.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 03/07/2018.
//

import Foundation

typealias CompletionHandler = (_ taskID: UUID) -> ()

protocol TaskProtocol {
    init(context: TaskContext, completionHandler: CompletionHandler?)
    
    var taskID: UUID { get }
    var context: TaskContext { get }
    var completionHandler: CompletionHandler? { get }
    
    func startTask() -> Void
    func stopTask() -> Void
}
