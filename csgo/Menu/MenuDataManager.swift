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
    
    let nameMenu = ["Основные", "Смешные", "Оружие", "Стикеры"]
    let menuPictures =
        ["https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FMain%2Fmaxresdefault.jpg?alt=media&token=00398ced-d5c7-4b9a-a272-10556f8b33e8",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FFunny%2F70VzAT1.jpg?alt=media&token=590b1718-32ac-46b2-b4cc-09da912b9dfa",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FWeapons%2Fthumb-1920-570408.jpg?alt=media&token=0c0dfd2f-a18c-4505-a03d-52f97bf83ef9",
         "https://firebasestorage.googleapis.com/v0/b/wp-csgo.appspot.com/o/CSGO%2FStickers%2Fthumb-1920-881247.jpg?alt=media&token=2a310071-be86-47bb-9fba-8fde513df86f"
        ]
    
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
 
//----------------------------------------------------------------------

    func menuImageUpload(urlPicture: String) -> UIImage {
        let mainPic = URL (string: urlPicture)
        let data = try! Data(contentsOf: mainPic!)
        let aData = data
        return UIImage(data: aData)!
    }
    
}

let concurrentQueue = DispatchQueue(label: "concurrenr_queue", attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial_queue")
let semaphore = DispatchSemaphore(value: 0)
