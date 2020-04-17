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

    func showAC(_ currentViewController: UIViewController, object: Any, completion: @escaping () -> Void) {
        currentVC = currentViewController

        let activityViewController = UIActivityViewController(activityItems: [object], applicationActivities: [])
        currentViewController.present(activityViewController, animated: true, completion: nil)

        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            completion()
        }
    }
}
