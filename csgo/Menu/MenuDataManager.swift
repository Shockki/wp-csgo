//
//  DataManager.swift
//  csgo
//
//  Created by Анатолий on 04.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import UIKit

class MenuDataManager {
    
    var menuImage: [UIImage] = [#imageLiteral(resourceName: "picture"),#imageLiteral(resourceName: "picture"),#imageLiteral(resourceName: "picture"),#imageLiteral(resourceName: "picture")]
    let nameMenu = ["Основные", "Смешные", "Оружие", "Стикеры"]
    let menuPictures =
        ["https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FMain%2F371d2e2e0f5dcc42f10e5ca86b413d87.png?alt=media&token=129ed59b-1806-41de-9a15-f5093cb2e323",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FFunny%2F70VzAT1.jpg?alt=media&token=590b1718-32ac-46b2-b4cc-09da912b9dfa",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FWeapons%2Fthumb-1920-570408.jpg?alt=media&token=0c0dfd2f-a18c-4505-a03d-52f97bf83ef9",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FStickers%2Fthumb-1920-881247.jpg?alt=media&token=2a310071-be86-47bb-9fba-8fde513df86f"
    ]
    
    func menuImageUpload(urlPicture: String) -> UIImage {
        let mainPic = URL (string: urlPicture)
        let data = try! Data(contentsOf: mainPic!)
        let aData = data
        return UIImage(data: aData)!
    }
    
    func picturesUpload(collectionView: UICollectionView) {
        concurrentQueue.async {
            print("main - \(Thread.current)")
            self.menuImage[0] = self.menuImageUpload(urlPicture: self.menuPictures[0])
            DispatchQueue.main.sync {
                collectionView.reloadData()
            }
            self.menuImage[1] = self.menuImageUpload(urlPicture: self.menuPictures[1])
            DispatchQueue.main.sync {
                collectionView.reloadData()
            }
            self.menuImage[2] = self.menuImageUpload(urlPicture: self.menuPictures[2])
            DispatchQueue.main.sync {
                collectionView.reloadData()
            }
            self.menuImage[3] = self.menuImageUpload(urlPicture: self.menuPictures[3])
                DispatchQueue.main.sync {
            collectionView.reloadData()
            }
            print("Загрузка картинок закончена")
        }
    }
    
}

let concurrentQueue = DispatchQueue(label: "concurrenr_queue", attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial_queue")
let semaphore = DispatchSemaphore(value: 0)
