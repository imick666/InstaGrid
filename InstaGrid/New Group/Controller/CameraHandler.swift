//
//  CameraHandler.swift
//  InstaGrid
//
//  Created by mickael ruzel on 31/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class CameraHandler:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //pick image
    static let shared = CameraHandler()
    fileprivate var currentVC: UIViewController!
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ipc = UIImagePickerController()
            ipc.delegate = self
            ipc.sourceType = .camera
            ipc.allowsEditing = true
            currentVC.present(ipc, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let ipc = UIImagePickerController()
            ipc.delegate = self
            ipc.sourceType = .photoLibrary
            ipc.allowsEditing = true
            currentVC.present(ipc, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(_ currentViewController: UIViewController) {
        currentVC = currentViewController
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction) in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        currentViewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else {
            print("FUCK")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }

}
