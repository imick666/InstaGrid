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
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var swipeToShareStackView: UIStackView!
    
    //create gesture instance
    let swipeGesture = UISwipeGestureRecognizer()
    
    //demander explications!!
    //si j'ai bie compris, cette instance permet de récupéré l'orientation de la premiere vue de l'application... je crois...
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSelectorList[0].isSelect = true
        
        setObjectOrientation()
        updateSelectorAnimations()
    }
    
    //demander explications
    //si j'ai bien compris, cette methéode est appellé à chaque fois que la vue princpile change en règle générale... je crois...
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        //demander explications!!
        coordinator.animate(alongsideTransition: { (context) in
            self.setObjectOrientation()
            self.updateSelectorAnimations()
        })
    }
    //-----------------------------------
    // MARK: - UTILITIES
    //-----------------------------------
    //set object orientation and assign correct gesture
    private func setObjectOrientation() {
        guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
        
        if windowInterfaceOrientation.isLandscape {
            self.swipeGesture.direction = .left
            LayoutSelector.orientation = .landscape
        } else {
            self.swipeGesture.direction = .up
            LayoutSelector.orientation = .portrait
        }
        self.swipeGesture.addTarget(self, action: #selector(self.swipeOrientation(_:)))
        self.resultView.addGestureRecognizer(self.swipeGesture)
    }
    
    //update selector's animation when device's orientation change
    private func updateSelectorAnimations() {
        for selector in layoutSelectorList where selector.isSelect {
            selector.isSelect = true
        }
    }
    
    //select animation for swipe side
    @objc func swipeOrientation(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            animationOutUp()
            shareResultImage { self.animationInUp() }
        case .left:
            animationOutLeft()
            shareResultImage { self.animationInLeft() }
        default:
            break
        }
    }
    //-----------------------------------
    // MARK: - IMAGE RENDERER || SHARE
    //-----------------------------------
    //render result Image
    private func resultImgeRenderer() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: resultView.bounds.size)
        let resultImage = renderer.image { (context) in //context?? kesako??
            resultView.drawHierarchy(in: resultView.bounds, afterScreenUpdates: false)
        }
        return resultImage
    }
    
    //show ActivityViewController for share image
    //clure is used for adapt the correct animation 
    private func shareResultImage(completion: @escaping () -> Void) { //explication @escaping || @noescape
        let image = resultImgeRenderer()
        ShareHandler.shared.showAC(self, object: image) {
            completion()
        }
    }
    //-----------------------------------
    // MARK: - ANIMATIONS
    //-----------------------------------
    //animation before share
    private func animationOutUp() {
        let screenSize = UIScreen.main.bounds
        let scaleReduction = CGAffineTransform(scaleX: 0.49, y: 0.49)
        let translate = CGAffineTransform(translationX: 0, y: -screenSize.height / 2.13)
        let totalTransform = translate.concatenating(scaleReduction)
        UIView.animate(withDuration: 0.5) {
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
        }) { (complete) in
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
        }) { (complete) in
            UIView.animate(withDuration: 0.3) {
                self.swipeToShareStackView.alpha = 1
            }
        }
    }
    //-----------------------------------
    // MARK: - ACTIONS
    //-----------------------------------
    //Setup layout implentation
    private func setLayoutSelected() {
        for layout in layoutSelectorList {
            layout.isSelect = false
        }
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
        sender.isSelect = true
    }
    
    @IBAction func layoutTowPressed(_ sender: LayoutSelector) {
        setLayoutSelected()
        sender.isSelect = true
    }
    
    @IBAction func layoutThreePressed(_ sender: LayoutSelector) {
        setLayoutSelected()
        sender.isSelect = true
    }
}

