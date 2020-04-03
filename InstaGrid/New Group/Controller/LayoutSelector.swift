//
//  LayoutSelector.swift
//  InstaGrid
//
//  Created by mickael ruzel on 30/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class LayoutSelector: UIButton {
    
    static let shared = LayoutSelector()
    
    
    var isSelect: Bool = false {
        didSet {
           setState()
        }
    }
    
    func setState() {
        switch isSelect {
        case true:
            self.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
            animateSelector()
        case false:
            self.setImage(nil, for: .normal)
            self.transform = .identity
        
        }
    }
    
    private func animateSelector() {
        guard UIDevice.current.orientation.isValidInterfaceOrientation else { return }
        if UIDevice.current.orientation.isLandscape {
            let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let transformTotal = CGAffineTransform(translationX: -15, y: 0).concatenating(scale)
            self.transform = transformTotal
        } else {
            let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let transformTotal = CGAffineTransform(translationX: 0, y: -15).concatenating(scale)
            self.transform = transformTotal
        }
    }
    
}
