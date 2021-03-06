//
//  GalleryDataManager.swift
//  csgo
//
//  Created by Анатолий on 04.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class GalleryDataManager {
    
    var urlPictures: [String] = []
    var arrayImage: [UIImage] = []
    
    func distributionOfNames(name: String) -> [String] {
        switch name {
        case "Основные":
            return urlMain
        case "Смешные":
            return urlFunny
        case "Оружие":
            return urlWeapons
        default:
            return urlStickers
        }
    }
    
    func loadJSON(title: String) {
        Alamofire.request("https://wp-csgo.firebaseio.com/\(title).json", method: .get).validate().responseJSON(queue:concurrentQueue) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for value in 0...json.count-1 {
                    self.urlPictures.append(json[value].stringValue)
                }
                print("LoadJSON - \(Thread.current)")
                semaphore.signal()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func cellSize(cv: UICollectionView) {
        let itemSize = UIScreen.main.bounds.width/3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 55, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        cv.collectionViewLayout = layout
    }
    
    func randNum(_ n: Int) -> Int{
        return Int(arc4random_uniform(UInt32(n)))
    }    
}
