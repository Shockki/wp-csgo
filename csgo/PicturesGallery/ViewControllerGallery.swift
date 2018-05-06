//
//  CollectionViewController.swift
//  csgo
//
//  Created by Анатолий on 03.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit
import GoogleMobileAds


private let reuseIdentifier = "Cell"

class ViewControllerGallery: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let reachability: Reachability = Reachability()!
    let manager: GalleryDataManager = GalleryDataManager()
   
    let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // тестовый идентификатор
//    let bannerAdUnitID = "ca-app-pub-8863116068218458/6876753052"
    
    var titleName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        concurrentQueue.async {
            self.title = self.titleName
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.manager.cellSize(cv: self.collectionView!)
            self.bannerAdUnit()
        }
        
        inteinternetCheck()
        
    }
    
    func inteinternetCheck() {
        if reachability.connection != .none {
            print("интернет есть")
            manager.loadJSON(title: titleName)
            semaphore.wait()
        }else{
            print("интернет отсутствует")
            let ac = UIAlertController(title: "Отсутствует подключение к интернету!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Повторить", style: .default) { (action) in
                self.inteinternetCheck()
                self.collectionView.reloadData()
            }
            ac.addAction(action)
            present(ac, animated: true)
        }
    }
    
    func bannerAdUnit() {
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
  
extension ViewControllerGallery: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.urlPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
