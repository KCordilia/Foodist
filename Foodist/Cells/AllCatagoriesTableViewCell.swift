//
//  AllCatagoriesTableViewCell.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class AllCatagoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var catagoryName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "allcatagoryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension AllCatagoriesTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AllCatagoryCollectionViewCell
            else { preconditionFailure("deque cell failed in selected catagory collection view ") }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height
        return CGSize(width: width, height: height)
    }
    
}
