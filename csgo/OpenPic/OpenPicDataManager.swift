//
//  OpenPicDataManager.swift
//  csgo
//
//  Created by Анатолий on 04.06.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import UIKit

class OpenPicDataManager {
    var filterNames = [
        "Clear",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade"
    ]
    
    func imageFilter(image: UIImage, filter: String) -> UIImage{
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: "\(filter)")
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        return UIImage(cgImage: filteredImageRef!)
    }
}
