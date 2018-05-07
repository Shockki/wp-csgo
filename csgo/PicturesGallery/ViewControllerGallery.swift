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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.manager.cellSize(cv: self.collectionView!)
        }
        bannerAdUnit()
        if manager.randNum(3) == 0 {
            interstitial = createAndLoadInterstitial()
            interstitial.delegate = self
        }
        
        internetCheck()
        
    }
    
    
    func internetCheck() {
        if reachability.connection != .none {
            print("интернет есть")
            manager.loadJSON(title: titleName)
            semaphore.wait()
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
        bannerView.adUnitID = adUnitData.bannerAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }


}
  
extension ViewControllerGallery: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.urlPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVCellGallery
        
//        if let url = URL(string: manager.urlPictures[indexPath.row]) {
//            manager.downloadImage(url: url, imageView: cell.picture)
//        }
        
        cell.picture.downloadedFrom(link: manager.urlPictures[indexPath.row], contentMode: .scaleAspectFill)
        
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
