//
//  LayoutSelector.swift
//  InstaGrid
//
//  Created by mickael ruzel on 30/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

enum InterfaceAdaptation {
    case portrait, landscape
}

class LayoutSelector: UIButton {
    
    static let shared = LayoutSelector()
    
    static var orientation: InterfaceAdaptation?
    
    var isSelect: Bool = false {
        didSet {
            setState()
        }
    }
    
    func setState() {
        switch isSelect {
        case true:
            self.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
            setAnimationOrientation()
        case false:
            self.setImage(nil, for: .normal)
            self.transform = .identity
        
        }
    }
    
    private func setAnimationOrientation() {
        guard let orientation = LayoutSelector.orientation else { return }
        switch orientation {
        case .portrait:
            setAnimationPortrait()
        case .landscape:
            setAnimationLandscape()
        }
    }
    
    private func setAnimationPortrait() {
        let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let transformTotal = CGAffineTransform(translationX: 0, y: -15).concatenating(scale)
        self.transform = transformTotal
    }
    
    private func setAnimationLandscape() {
        let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let transformTotal = CGAffineTransform(translationX: -15, y: 0).concatenating(scale)
        self.transform = transformTotal
    }
}
