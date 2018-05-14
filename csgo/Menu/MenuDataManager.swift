//
//  DataManager.swift
//  csgo
//
//  Created by Анатолий on 04.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

var urlMain: [String] = []
var urlFunny: [String] = []
var urlWeapons: [String] = []
var urlStickers: [String] = []

class MenuDataManager {
    
    let nameMenu = ["Основные", "Смешные", "Оружие", "Стикеры", "Так же смотри"]
    let nameMenuJSON = ["main", "funny", "weapons", "stickers"]
    let menuPictures =
        ["https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2Fmain.jpg?alt=media&token=e5ad5ef0-6a52-46f4-87d9-d262084c6fc6",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2Ffunny.jpg?alt=media&token=ecccd5e2-6533-41cc-839b-d5f25b8d806f",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2Fweapons.jpg?alt=media&token=33229e37-ff9f-4f6c-80cd-646ede92ed61",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2Fstikers.jpg?alt=media&token=0057aae1-ea14-48fa-b436-94d287428793",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/mc.jpg?alt=media&token=1b79ce46-09c1-4b48-8510-65c68677000f"
        ]
    
    func loadURL() {
        concurrentQueue.async {
            self.loadJSON(title: "main")
            self.loadJSON(title: "funny")
        }
        loadJSON(title: "weapons")
        loadJSON(title: "stickers")
    }
    
    func loadJSON(title: String) {
        Alamofire.request("https://wp-csgo.firebaseio.com/api/\(title).json", method: .get).validate().responseJSON(queue:concurrentQueue) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch title {
                case "main":
                    for value in 0...json.count-1 {
                        urlMain.append(json[value].stringValue)
//                        print("\(title) - \(json[value].stringValue)")
                    }
                case "funny":
                    for value in 0...json.count-1 {
                        urlFunny.append(json[value].stringValue)
//                        print("\(title) - \(json[value].stringValue)")
                    }
                case "weapons":
                    for value in 0...json.count-1 {
                        urlWeapons.append(json[value].stringValue)
//                        print("\(title) - \(json[value].stringValue)")
                    }
                default:
                    for value in 0...json.count-1 {
                        urlStickers.append(json[value].stringValue)
//                        print("\(title) - \(json[value].stringValue)")
                    }
                }
                print("\n* \(title) LoadJSON - \(Thread.current) *\n")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func distributionOfNames(_ number: Int) -> String {
        switch number {
        case 0:
            return "Основные"
        case 1:
            return "Смешные"
        case 2:
            return "Оружие"
        default:
            return "Стикеры"
        }
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        //        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            //            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func cellSize(cv: UICollectionView) {
        let itemSizeW = UIScreen.main.bounds.width/1
        let itemSizeH = UIScreen.main.bounds.height/4
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        layout.itemSize = CGSize(width: itemSizeW, height: itemSizeH)
        
        layout.minimumLineSpacing = 5
        
        cv.collectionViewLayout = layout
    }
    
}

let concurrentQueue = DispatchQueue(label: "concurrenr_queue", attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial_queue")
let semaphore = DispatchSemaphore(value: 0)
