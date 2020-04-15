//
//  ViewController.swift
//  CustomNotificationCenter
//
//  Created by Syed, Waseem on 10/29/19.
//  Copyright © 2019 Syed, Waseem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // POST a notification
        CustomNotificationCenter.shared.post(name: "FetchCompleted", object: nil, userInfo: ["id": 10, "name": "Tom"])
        checkObserver()
        
    }
    
    func checkObserver() {
        // Observe a notification
        CustomNotificationCenter.shared.addObserver(forName: "FetchCompleted", object: nil, queue: OperationQueue.current) { (notification) in
            print(notification.userInfo?["id"]!) // Prints 10
            print(notification.userInfo?["name"]!) // Prints Tom
        }
        
        // Remove all observers for a notification
        CustomNotificationCenter.shared.removeObservers(name: "FetchCompleted")
        
    }
}

