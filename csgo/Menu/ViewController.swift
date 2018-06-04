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
    var checkUploadPic = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0
        bgLoad.alpha = 1
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
        if checkUploadPic == true {
            collectionView.reloadData()
            checkUploadPic = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.bgLoad.alpha = 0
            self.collectionView.alpha = 1
        })
        if advertising == true {
            bannerAdUnit()
        }
        print("Загрузка JSON завершена")
    }
    
    func inteinternetCheck() {
        if reachability.connection != .none {
            print("интернет есть")
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
        bannerView.adUnitID = adUnitData.bannerAdUnitID_1
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
}



// MARK: Collection View
    
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellCount < manager.countCategories || cellCount > 6 {
            return manager.countCategories
        }else{
            return cellCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.labelName.text = manager.nameMenu[indexPath.row]
        switch indexPath.row {
        case 0...3:
            cell.picture.sd_setImage(with: URL(string: manager.menuPictures[indexPath.row]))
        case 4:
            cell.picture.sd_setImage(with: URL(string: picCellAd_1))
        case 5:
            cell.picture.sd_setImage(with: URL(string: picCellAd_2))
        default:
            break
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.row)  {
        case 0...3:
            index = indexPath.row
            performSegue(withIdentifier: "goPictures", sender: self)
        case 4:
            if let url = URL(string: urlAdApp_1){
                UIApplication.shared.open(url, options: [:])
            }
        case 5:
            if let url = URL(string: urlAdApp_2){
                UIApplication.shared.open(url, options: [:])
            }
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


