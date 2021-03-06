//
//  SingleImageViewButton.swift
//  InstaGrid
//
//  Created by mickael ruzel on 30/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SingleImageViewButton: UIButton {

    func resetImage() {
        self.setImage(#imageLiteral(resourceName: "PlusButton"), for: .normal)
    }

    func showLayoutGrid() {
        self.isHidden = false
    }

    func hideLayoutGrid() {
        self.isHidden = true
    }
}
