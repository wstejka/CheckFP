//
//  UICollectionView+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


extension UICollectionView {
    
    func deselectAllItemsExcept(_ indexPath: IndexPath)  {
        
        let defaultSection = 0
        // Change borders of all other collection cells except at indexPath possition
        for item in 0..<self.numberOfItems(inSection: defaultSection) {
        
            let itemIndexPath = IndexPath(row: item, section: defaultSection)
            let collectionCell = self.cellForItem(at: itemIndexPath) as? StatisticsCollectionViewCell
            if itemIndexPath != indexPath {
                collectionCell?.isSelected = false
            }
        }
    }
}
