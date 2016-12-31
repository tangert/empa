//
//  AllPatientsViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class AllPatientsViewController: UICollectionViewController {
    
    var patientCellNib: UINib? = UINib(nibName: "PatientCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(patientCellNib, forCellWithReuseIdentifier: "patientCell")
        
        
    }
    
    
    //MARK: UICollectionView DataSource + Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "patientCell", for: indexPath) as! PatientCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "PatientProfileSegue", sender: self)
    }
}

extension AllPatientsViewController: UICollectionViewDelegateFlowLayout {
    
}
