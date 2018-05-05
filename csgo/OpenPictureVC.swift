//
//  OpenPictureVC.swift
//  csgo
//
//  Created by Анатолий on 04.05.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import UIKit

class OpenPictureVC: UIViewController, UIScrollViewDelegate {
    
    let manager: GalleryDataManager = GalleryDataManager()
    var checkNav: Bool = true
    var urlPicture: String = ""

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        scrollView.minimumZoomScale = 1
//        scrollView.maximumZoomScale = 6
        
        if let url = URL(string: urlPicture) {
            manager.downloadImage(url: url, imageView: picture)
        }
    }

    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(picture.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Готово!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
//    func UIImageWriteToSavedPhotosAlbum(image: UIImage?, completionTarget: Any?, completionSelector: Selector, contextInfo: UnsafeMutableRawPointer?) {
//    }
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if checkNav == true {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        checkNav = !checkNav
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
//        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
//        sender.scale = 1
        
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
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return picture
//    }
}
