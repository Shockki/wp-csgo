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
            manager.picturesUpload(collectionView: collectionView!)
        }else{
            
        }

     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = false
    }

//    @IBAction func actionButton(_ sender: AnyObject) {
//        print(sender.tag)
//        performSegue(withIdentifier: "goPictures", sender: self)
//    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.picture.image = manager.menuImage[indexPath.row]
        if manager.menuImage[indexPath.row] != #imageLiteral(resourceName: "picture") {
            cell.picture.alpha = 1
            cell.picture.contentMode = .scaleAspectFill
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
        
//        if segue.identifier == "details" {
//            if let indexPath = collectionView.indexPathForSelectedRow {
//                let destVC: CollectionViewController = segue.destination as! CollectionViewController
////                destVC.titleName = notesList[indexPath.row].replacingOccurrences(of: " ", with: "%20")
//
//            }
//        }
    }

}

