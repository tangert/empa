//
//  ViewController.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 10/6/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var images = [UIImage]()
    var placeholderCellNib: UINib? = UINib(nibName: "PlaceholderCell", bundle:nil)
    var cameraViewNib: UINib? = UINib(nibName: "CameraViewCell", bundle: nil)

    var sessionIsRunning = false
    
    @IBOutlet weak var beginSessionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true

        //registering nibs
        self.collectionView.register(placeholderCellNib, forCellWithReuseIdentifier: "placeholderCell")
         self.collectionView.register(cameraViewNib, forCellWithReuseIdentifier: "cameraViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //adding images to the images array
        for i in 0...24 {
            //only 6 sample images, so mod 6 to produce 12
            images.append(UIImage(named: "\((i%6)+1)")!)
        }
    }
    
    @IBAction func beginSession(_ sender: Any) {
        
        if sessionIsRunning == false {
            FrontCameraView.session?.startRunning()
            sessionIsRunning = true
        } else {
           FrontCameraView.session?.stopRunning()
            sessionIsRunning = false
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //every 4th cell except the first one, it shows a camera view as an emotional "checkpoint"
        if (indexPath.row % 4 == 0 && indexPath.row != 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraViewCell", for: indexPath) as! CameraViewCell
            cell.layer.cornerRadius = 10
            return cell
            
        } else {
            //placeholder cells
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeholderCell", for: indexPath) as! PlaceholderCell
            cell.placeholderImage.image = images[indexPath.row]
            cell.layer.cornerRadius = 10
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width-40, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
}
