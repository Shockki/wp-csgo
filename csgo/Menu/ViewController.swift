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
    @IBOutlet weak var bgLoad: UIView!
    
    let manager: MenuDataManager = MenuDataManager()
    let adUnitData: AdUnitData = AdUnitData()
    let reachability: Reachability = Reachability()!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.cellSize(cv: collectionView)
        inteinternetCheck()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Okruglizm", size: 27)!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        while manager.checkLoadJSON() == false {
            bgLoad.alpha = 1
        }
        UIView.animate(withDuration: 0.3, animations: { self.bgLoad.alpha = 0 })
        print("Загрузка JSON завершена")
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
        return manager.countCategories + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.picture.downloadedFrom(link: manager.menuPictures[indexPath.row], contentMode: .scaleAspectFill)
        cell.labelName.text = manager.nameMenu[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.row)  {
        case 0...3:
            index = indexPath.row
            performSegue(withIdentifier: "goPictures", sender: self)
        default:
            if let url = URL(string: "itms-apps://itunes.apple.com/ru/app/id1382668321"){
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPictures" {
                let destVC: ViewControllerGallery = segue.destination as! ViewControllerGallery
                destVC.titleName = manager.distributionOfNames(index)
            }
    }
}


