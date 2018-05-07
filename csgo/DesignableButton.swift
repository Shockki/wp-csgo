//
//  DesignableLabel.swift
//  Local Socket
//
//  Created by Анатолий on 02.04.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    @IBInspectable var corner: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = corner
            self.layer.masksToBounds = true
        }
    }
    
}
