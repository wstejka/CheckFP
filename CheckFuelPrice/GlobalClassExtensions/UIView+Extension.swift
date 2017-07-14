//
//  UIView+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

extension UIView
{

    
//    static func loadFromXib<T>() -> T where T: UIView
//    {
//        let bundle = Bundle(for: self)
//        let nib = UINib(nibName: "\(self)", bundle: bundle)
//        
//        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
//            fatalError("Could not load view from nib file.")
//        }
//        _ = self.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }
    
    func addXib<T>(forType: T.Type) -> T where T: UIView
    {
        guard let view = Bundle.main.loadNibNamed(String(describing: forType), owner: self, options: nil)?.first as? T else {
            fatalError("Could not load view from nib file.")
        }

        _ = self.addSubview(view)
        let cornerRadius : CGFloat = 10.0
        self.layer.cornerRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        return view
    }

}
