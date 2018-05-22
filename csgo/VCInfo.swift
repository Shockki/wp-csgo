//
//  VCInfo.swift
//  csgo
//
//  Created by Анатолий on 06.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit
import GoogleMobileAds

class VCInfo: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var labelText: UILabel!
    
    let adUnitData: AdUnitData = AdUnitData()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func feedbackButton(_ sender: Any) {
            if let url = URL(string: "itms-apps://itunes.apple.com/ru/app/c/id1382287105"){
                UIApplication.shared.open(url, options: [:])
            }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Зацени крутое приложение https://itunes.apple.com/ru/app/c/id1382287105"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }

    @IBAction func backButton(_ sender: Any) {
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Ad Unit
    
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
