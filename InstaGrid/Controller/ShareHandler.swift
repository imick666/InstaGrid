//
//  ShareHandler.swift
//  InstaGrid
//
//  Created by mickael ruzel on 03/04/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class ShareHandler {
    
    fileprivate var currentVC: UIViewController!
    static let shared = ShareHandler()
    
    func showAC(_ viewController: UIViewController, object: Any, completion: @escaping () -> Void) {
        currentVC = viewController
        
        let activityViewController = UIActivityViewController(activityItems: [object], applicationActivities: [])
        viewController.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedUtiems, error) in
            completion()
        }
    }
    
}
