//
//  CollectionViewController.swift
//  csgo
//
//  Created by Анатолий on 03.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "Cell"
private var main: [UIImage] = []
private var funny: [UIImage] = []
private var weapons: [UIImage] = []
private var stickers: [UIImage] = []

class CollectionViewController: UICollectionViewController {

    let reachability: Reachability = Reachability()!
    let manager: GalleryDataManager = GalleryDataManager()
    
    var titleName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        concurrentQueue.async {
            self.title = self.titleName
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.manager.cellSize(cv: self.collectionView!)
        }
//        navigationController?.hidesBarsOnSwipe = true

        manager.loadJSON(title: titleName)
        semaphore.wait()
        
//        for _ in 1...manager.urlPictures.count {
//            manager.arrayImage.append(#imageLiteral(resourceName: "picture"))
//        }
        
        if reachability.connection != .none {
            print("интернет есть")
        }else{
            
        }
        
        

        print("end VDL")
        
        
    }

    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.urlPictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVCellGallery
        
        if let url = URL(string: manager.urlPictures[indexPath.row]) {
            cell.picture.alpha = 1
            manager.downloadImage(url: url, imageView: cell.picture)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let vc = segue.destination as! OpenPictureVC
            vc.urlPicture = manager.urlPictures[indexPath.row]
        }
    }
}