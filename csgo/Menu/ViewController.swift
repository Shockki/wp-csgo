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
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inteinternetCheck()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Okruglizm", size: 27)!]
    }
    
    func inteinternetCheck() {
        if reachability.connection != .none {
            print("интернет есть")
            bannerAdUnit()
            manager.loadURL()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.row)  {
        case 0...3:
            index = indexPath.row
            performSegue(withIdentifier: "goPictures", sender: self)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPictures" {
                let destVC: ViewControllerGallery = segue.destination as! ViewControllerGallery
                destVC.titleName = manager.distributionOfNames(index)
            }
    }
}


