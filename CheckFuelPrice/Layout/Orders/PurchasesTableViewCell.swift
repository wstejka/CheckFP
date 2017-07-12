//
//  PurchasesTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class PurchasesTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Vars/Consts
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }

    // MARK: - Cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}
