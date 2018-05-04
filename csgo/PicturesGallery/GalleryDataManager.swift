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
    
    private func distributionOfNames(Name: String) -> String {
        switch Name {
        case "Основные":
            return "main"
        case "Смешные":
            return "funny"
        case "Оружие":
            return "weapons"
        default:
            return "stickers"
        }
    }
    
    func loadJSON(title: String) {
        Alamofire.request("https://wp-csgo.firebaseio.com/\(distributionOfNames(Name: title)).json", method: .get).validate().responseJSON(queue:concurrentQueue) { response in
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
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        cv.collectionViewLayout = layout
    }
    
    func menuImageUpload(urlPicture: String) -> UIImage {
        let mainPic = URL (string: urlPicture)
        let data = try! Data(contentsOf: mainPic!)
        let aData = data
        return UIImage(data: aData)!
    }
    
    func picturesUpload(collectionView: UICollectionView, arrayPic: [String]) {
        concurrentQueue.async {
            for value in 0...arrayPic.count - 1 {
                self.arrayImage[value] = self.menuImageUpload(urlPicture: self.urlPictures[value])
                DispatchQueue.main.sync {
                    collectionView.reloadData()
                }
            }
            print("Загрузка картинок закончена")
        }
    }
    
}
