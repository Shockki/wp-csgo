//
//  OpenPictureVC.swift
//  csgo
//
//  Created by Анатолий on 04.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OpenPictureVC: UIViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let manager: OpenPicDataManager = OpenPicDataManager()
    let adUnitData: AdUnitData = AdUnitData()
    var interstitial: GADInterstitial!
    var checkNav: Bool = true
    var urlPicture: String = ""
    var image: UIImage!
    var indexImage: Int!
    var nameOfMenu: String = ""
    var imageClear: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: false)
        picture.image = image
        imageClear = image
        
    }

    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(picture.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Ошибка!", message: "Разрешите доступ к вашему альбому", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Готово!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default) {(action) in
                if advertising == true {
                    self.interstitial = self.createAndLoadInterstitial()
                    self.interstitial.delegate = self
                }
            })
            present(ac, animated: true)
        }
    }
    @IBAction func buttonShare(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Зацени крутое приложение \(info_2)"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if checkNav == true {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.collectionView.alpha = 0
            }, completion: nil)
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.setToolbarHidden(true, animated: true)
        }else{
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.collectionView.alpha = 1
            }, completion: nil)
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.setToolbarHidden(false, animated: true)
        }
        checkNav = !checkNav
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        }
        if sender.state == .ended {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                sender.view?.transform.a = 1.0
                sender.view?.transform.d = 1.0
            }, completion: nil)
        }
    }

    
    
    // MARK: Ad Unit
    func createAndLoadInterstitial() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: adUnitData.interstitialAdUnitID)
        let request = GADRequest()
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

extension OpenPictureVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.filterNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVCellOpenPic

        if indexPath.row == 0 {
            cell.picture.image = imageClear
        }else{
            cell.picture.image = manager.imageFilter(image: image, filter: manager.filterNames[indexPath.row])
        }
        cell.layer.cornerRadius = 20
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            picture.image = imageClear
        }else{
            picture.image = imageClear
            picture.image = manager.imageFilter(image: image, filter: manager.filterNames[indexPath.row])
        }
    }
}



