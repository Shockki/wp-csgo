//
//  ViewController.swift
//  csgo
//
//  Created by Анатолий on 03.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UICollectionViewController {
    
    let manager: MenuDataManager = MenuDataManager()
    let reachability: Reachability = Reachability()!
    
    let jsonMain = "https://wp-csgo.firebaseio.com/main.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CS:GO Обои"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if reachability.connection != .none {
            print("интернет есть")
        }else{
            
        }
        
        

     
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if let url = URL(string: manager.menuPictures[indexPath.row]) {
            cell.picture.contentMode = .scaleAspectFill
            cell.picture.alpha = 1
            manager.downloadImage(url: url, imageView: cell.picture)
            cell.labelName.text = manager.nameMenu[indexPath.row]
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let vc = segue.destination as! CollectionViewController
            vc.titleName = manager.nameMenu[indexPath.row]
        }
    }

}

