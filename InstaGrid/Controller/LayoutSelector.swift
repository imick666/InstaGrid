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
    /*LayoutOne :
        -ImageOne
        -ImageThree
        -ImageFour
     LayoutTwo :
        -ImageOne
        -ImageTwo
        -ImageFour
     LayoutThree :
        -ImageOne
        -ImageTwo
        -Imagethree
        -ImageFour
    */
    //assigned each instance of SingleImageViewButton to each instance of LayoutSelector
    @IBOutlet var imageList: [SingleImageViewButton]!
    
    //use methose of this class in other class esealy
    static let shared = LayoutSelector()
    //store the current orientation for adapt the animations
    static var orientation: InterfaceAdaptation?

    var isSelect: Bool = false {
        didSet {
            setState()
        }
    }
    
    
    private func setState() {
        switch isSelect {
        case true:
            self.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
            showImageGrid()
            setAnimationOrientation()
        case false:
            hideImageGrid()
            resetImageGrid()
            self.setImage(nil, for: .normal)
            self.transform = .identity
        
        }
    }
    //-----------------------------------
    // MARK: - IMAGE GESTION
    //-----------------------------------
    private func showImageGrid() {
        for image in imageList {
            image.showLayoutGrid()
        }
    }
    
    private func hideImageGrid() {
        for image in imageList {
            image.hideLayoutGrid()
        }
    }
    
    private func resetImageGrid() {
        for image in imageList {
            image.resetImage()
        }
    }
    //-----------------------------------
    // MARK: - ANIMATION
    //-----------------------------------
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
