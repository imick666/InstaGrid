//
//  ViewController.swift
//  InstaGrid
//
//  Created by mickael ruzel on 30/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet var layoutSelectorList: [LayoutSelector]!
    @IBOutlet var imageOne: SingleImageViewButton!
    @IBOutlet var imageTwo: SingleImageViewButton!
    @IBOutlet var imageThree: SingleImageViewButton!
    @IBOutlet var imageFour: SingleImageViewButton!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var swipeToShareStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSelectorList[0].currentState = .selected
        //orientation Notification
        let orientationNotificationName = UIDevice.orientationDidChangeNotification

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationNotif), name: orientationNotificationName, object: nil)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeOrientation(_:)))
        swipeUp.direction = .up
        resultView.addGestureRecognizer(swipeUp)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeOrientation(_:)))
        swipeLeft.direction = .left
        resultView.addGestureRecognizer(swipeLeft)
        
    }
    //-----------------------------------
    // MARK: - SELECTORS
    //-----------------------------------
    //what happend when orientation change
    @objc private func orientationNotif() {
        //update selector's animation
        for selector in layoutSelectorList where selector.currentState == .selected {
            selector.setState()
        }
        
    }
    
    @objc func swipeOrientation(_ gesture: UISwipeGestureRecognizer) { 
        if !UIDevice.current.orientation.isValidInterfaceOrientation {
            return
        }
        if UIDevice.current.orientation.isPortrait && gesture.direction == .up {
            print("Up")
            animationOutUp()
            shareResultImage()
        } else if UIDevice.current.orientation.isLandscape && gesture.direction == .left {
            print("Left")
            animationOutLeft()
            shareResultImage()
        }
    }
    
    //-----------------------------------
    // MARK: - IMAGE RENDERER || SHARE
    //-----------------------------------
    //render result Image
    private func resultImgeRenderer() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: resultView.bounds.size)
        let resultImage = renderer.image { (context) in
            resultView.drawHierarchy(in: resultView.bounds, afterScreenUpdates: true)
        }
        return resultImage
    }
    
    private func shareResultImage() {
        let image = resultImgeRenderer()
        ShareHandler.shared.showAC(self, object: image) {
            if UIDevice.current.orientation.isPortrait {
                self.animationInUp()
            } else if UIDevice.current.orientation.isLandscape {
                self.animationInLeft()
            }
        }
    }
    //-----------------------------------
    // MARK: - ANIMATIONS
    //-----------------------------------
    //animation before share
    private func animationOutUp() {
        let screenSize = UIScreen.main.bounds
        UIView.animate(withDuration: 0.5) {
            let scaleReduction = CGAffineTransform(scaleX: 0.49, y: 0.49)
            let translate = CGAffineTransform(translationX: 0, y: -screenSize.height / 2.13)
            let totalTransform = translate.concatenating(scaleReduction)
            self.resultView.transform = totalTransform
            self.swipeToShareStackView.alpha = 0
        }
    }
    
    private func animationOutLeft() {
        let screenSize = UIScreen.main.bounds
        let scaleReduction = CGAffineTransform(scaleX: 0.49, y: 0.49)
        let translate = CGAffineTransform(translationX: -screenSize.width - 200, y: 0)
        let totalTransform = translate.concatenating(scaleReduction)
        UIView.animate(withDuration: 0.5) {
            self.resultView.transform = totalTransform
            self.swipeToShareStackView.alpha = 0
        }
    }
    //animtation after share
    private func animationInUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.resultView.transform = .identity
        }) { (true) in
            UIView.animate(withDuration: 0.3) {
                self.swipeToShareStackView.alpha = 1
            }
        }
    }
    
    private func animationInLeft() {
        resultView.transform = .identity
        resultView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, animations: {
            self.resultView.transform = .identity
        }) { (true) in
            UIView.animate(withDuration: 0.3) {
                self.swipeToShareStackView.alpha = 1
            }
        }
    }
    //-----------------------------------
    // MARK: - ACTIONS
    //-----------------------------------
    
    //Setup layout implentation
    func setLayoutSelected() {
        for layout in layoutSelectorList {
            layout.currentState = .unselected
        }
        imageOne.resetImage()
        imageTwo.resetImage()
        imageThree.resetImage()
        imageFour.resetImage()
    }
    //pick image in imageView
    @IBAction func selectImagePressed(_ sender: SingleImageViewButton) {
        CameraHandler.shared.showActionSheet(self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            sender.setImage(image, for: .normal)
            sender.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    @IBAction func LayoutOnePressed(_ sender: LayoutSelector) {
        setLayoutSelected()
        sender.currentState = .selected
        imageOne.isHidden = false
        imageTwo.isHidden = true
        imageThree.isHidden = false
        imageFour.isHidden = false
    }
    
    @IBAction func layoutTowPressed(_ sender: LayoutSelector) {
        setLayoutSelected()
        sender.currentState = .selected
        imageOne.isHidden = false
        imageTwo.isHidden = false
        imageThree.isHidden = false
        imageFour.isHidden = true
    }
    
    @IBAction func layoutThreePressed(_ sender: LayoutSelector) {
        setLayoutSelected()
        sender.currentState = .selected
        imageOne.isHidden = false
        imageTwo.isHidden = false
        imageThree.isHidden = false
        imageFour.isHidden = false
    }
}

