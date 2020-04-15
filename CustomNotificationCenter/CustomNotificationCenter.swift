//
//  CustomNotificationCenter.swift
//  CustomNotificationCenter
//
//  Created by Syed, Waseem on 10/29/19.
//  Copyright © 2019 Syed, Waseem. All rights reserved.
//

import Foundation

protocol CustomNotificationCenterProtocol: class {
    func post(name: String, object: Any?, userInfo: [AnyHashable : Any]?)
    func addObserver(forName name: String, object: Any?, queue: OperationQueue?, completion: (CustomNotification) -> Void)
    func removeObservers(name: String)
}

struct CustomNotification {
    var name: String
    var userInfo: [AnyHashable: Any]?
}

struct CustomObserver {
    var name: String
}

class CustomNotificationCenter: CustomNotificationCenterProtocol {
    static let shared = CustomNotificationCenter()
    
    private init() {}
    
    var notificationsMap: [String: CustomNotification]  = [:]
    
    // Preserving thread safety for Observers
    private var queue = DispatchQueue(label: "observerMapQueue", qos:   .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    
    private var _observersMap: [String : [CustomObserver]] = [:]
    private var observersMap: [String : [CustomObserver]] {
        get {
            var map: [String : [CustomObserver]] = [:]
            queue.async {
                map = self._observersMap
            }
            return map
        } set {
            queue.sync(flags: .barrier) {
                _observersMap = newValue
            }
        }
    }

    
    func post(name: String, object: Any?, userInfo: [AnyHashable : Any]?) {
        notificationsMap[name] = CustomNotification(name: name, userInfo: userInfo)
    }
    
    func addObserver(forName name: String, object: Any?, queue: OperationQueue?, completion: (CustomNotification) -> Void) {
        guard let notification = notificationsMap[name] else {
            assertionFailure("Notification is not Posted")
            return
        }
        
        let currentObserver = CustomObserver(name: name)
        
        if observersMap[name] == nil {
            observersMap[name] = [currentObserver]
        } else {
            observersMap[name]!.append(currentObserver)
        }
        
        completion(notification)
    }
    
    func removeObservers(name: String) {
        observersMap[name] = nil
    }
    
}
