//
//  CVCellGallery.swift
//  csgo
//
//  Created by Анатолий on 04.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit

class CVCellGallery: UICollectionViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        picture.image = nil
        super.prepareForReuse()
    }
}
