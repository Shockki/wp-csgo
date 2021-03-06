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

class ViewControllerGallery: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let reachability: Reachability = Reachability()!
    let manager: GalleryDataManager = GalleryDataManager()
    let adUnitData: AdUnitData = AdUnitData()
    
    var interstitial: GADInterstitial!
    var titleName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        concurrentQueue.async {
            self.title = self.titleName
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Poiret One", size: 24)!]
            self.manager.cellSize(cv: self.collectionView!)
        }
        if  advertising == true {
            bannerAdUnit()
            if manager.randNum(3) == 0 {
                interstitial = createAndLoadInterstitial()
                interstitial.delegate = self
            }
        }
        internetCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func internetCheck() {
        if reachability.connection != .none {
            print("интернет есть")
            
        }else{
            print("интернет отсутствует")
            let ac = UIAlertController(title: "Отсутствует подключение к интернету!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Повторить", style: .default) { (action) in
                self.internetCheck()
                self.collectionView.reloadData()
            }
            ac.addAction(action)
            present(ac, animated: true)
        }
    }

    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//MARK: Ad Unit
    
    func bannerAdUnit() {
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = adUnitData.bannerAdUnitID_2
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: adUnitData.interstitialAdUnitID)
        let request = GADRequest()
        inter.delegate = self
        inter.load(request)
        if inter.isReady {
            inter.present(fromRootViewController: self)
        }else{
            print("реклама не готова")
        }
        return inter
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial.present(fromRootViewController: self)
    }
    
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        interstitial = createAndLoadInterstitial()
//    }


}
  
extension ViewControllerGallery: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.distributionOfNames(name: titleName).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVCellGallery
        
        cell.picture.sd_setImage(with: URL(string: manager.distributionOfNames(name: titleName)[indexPath.row]))

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CVCellGallery,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let vc = segue.destination as! OpenPictureVC
            vc.urlPicture = manager.distributionOfNames(name: titleName)[indexPath.row]
            vc.image = cell.picture.image
            vc.indexImage = indexPath.row
            vc.nameOfMenu = titleName
        }
    }
}
