//
//  PhotoCollectionViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 26/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width, height: frame.size.height))
//        imageView.contentMode = UIViewContentMode.scaleAspectFit
//        contentView.addSubview(imageView)
//    }
    
}
