//
//  ViewController.swift
//  csgo
//
//  Created by Анатолий on 03.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
        
    let manager: MenuDataManager = MenuDataManager()
    let adUnitData: AdUnitData = AdUnitData()
    let reachability: Reachability = Reachability()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        inteinternetCheck()
                
    }
    
    func inteinternetCheck() {
        if reachability.connection != .none {
            print("интернет есть")
            bannerAdUnit()
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
        bannerView.adUnitID = adUnitData.bannerAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}



// MARK: Collection View
    
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            let vc = segue.destination as! ViewControllerGallery
            vc.titleName = manager.nameMenu[indexPath.row]
        }
    }
}


