//
//  ViewController.swift
//  InstaGrid
//
//  Created by mickael ruzel on 30/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var layoutSelectorList: [LayoutSelector]!
    
    @IBOutlet var imageOne: SingleImageViewButton!
    @IBOutlet var imageTwo: SingleImageViewButton!
    @IBOutlet var imageThree: SingleImageViewButton!
    @IBOutlet var imageFour: SingleImageViewButton!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var swipeToShareStackView: UIStackView!
    
    let swipeGesture = UISwipeGestureRecognizer()
    let currentDevice = UIDevice.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSelectorList[0].currentState = .selected
        //orientation Notification
        currentDevice.beginGeneratingDeviceOrientationNotifications()
        let orientationNotification = UIDevice.orientationDidChangeNotification
        NotificationCenter.default.addObserver(self, selector: #selector(orientationNotif), name: orientationNotification, object: nil)
    }
    
    @objc private func orientationNotif() {
        if currentDevice.orientation.isLandscape {
            swipeGesture.direction = .left
        } else {
            swipeGesture.direction = .up
        }
        swipeGesture.addTarget(resultView!, action: #selector(shareAnimation(_:)))
    }
    
    @objc private func shareAnimation(_ gesture: UISwipeGestureRecognizer) {
        animationOut()
        let image = resultImgeRenderer()
        shareImageAVC(object: image)
    }
    
    //animation before share
    private func animationOut() {
        UIView.animate(withDuration: 0.5) {
            let screenSize = UIScreen.main.bounds
            let scaleReduction = CGAffineTransform(scaleX: 0.49, y: 0.49)
            let translate = CGAffineTransform(translationX: 0, y: -screenSize.height / 2.13)
            let totalTransform = translate.concatenating(scaleReduction)
            self.resultView.transform = totalTransform
            self.swipeToShareStackView.alpha = 0
        }
        
    }
    //animtation after share
    private func animationIn() {
        UIView.animate(withDuration: 0.5, animations: {
            self.resultView.transform = .identity
        }) { (true) in
            UIView.animate(withDuration: 0.3) {
                self.swipeToShareStackView.alpha = 1
            }
        }
    }
    
    //share function
    //[ShareSheet] connection invalidated?? kesako?
    private func shareImageAVC(object: UIImage) {
        let avc = UIActivityViewController(activityItems: [object], applicationActivities: [])
        self.present(avc, animated: true, completion: nil)
        
        avc.completionWithItemsHandler = { (activitype, true, items, error) in
            self.animationIn()
        }
    }
    
    
    //render result Image
    private func resultImgeRenderer() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: resultView.bounds.size)
        let resultImage = renderer.image { (context) in
            resultView.drawHierarchy(in: resultView.bounds, afterScreenUpdates: true)
        }
        return resultImage
    }

    
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

