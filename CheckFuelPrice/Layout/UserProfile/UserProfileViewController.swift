//
//  UserProfileViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 19/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileOptionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        guard let profileOption = ProfileOption(rawValue: indexPath.row),
            let descriptionNode = self.profileOptionsArray[profileOption],
            let descriptionText = descriptionNode[ProfileOptionProperty.name],
            let imageName = descriptionNode[ProfileOptionProperty.photo] else {
                return cell
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        // Let's add objects to UIView programmatically !!
        // ======= Button ======= //
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 30.0))
        cell.addSubview(button)
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        // button's constraints
        button.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        button.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 30).isActive = true
        button.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, constant: 0).isActive = true

        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.topAnchor.constraint(equalTo: button.topAnchor, constant: 0).isActive = true

        
        // ======= Label ======== //
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 30.0))
        cell.contentView.addSubview(label)
        label.font = UIFont(name: label.font.fontName, size: 14)

        label.text = descriptionText.localized().capitalized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 30).isActive = true
        label.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.4).isActive = true

        return cell
    }
    
    func buttonAction(sender: UIButton!) {
        log.verbose("Button tapped")
    }
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class UserProfileViewController: UIViewController {

    // MARK: Constants/Variable
    let profileOptionsArray : [ProfileOption : [ProfileOptionProperty : String]] =
        [.personalData : [.name : "personalData", .photo : "businessCard"],
         .changePhoto : [.name : "changePhoto", .photo : ""],
         .coordinates : [.name : "coordinates", .photo : ""],
         .singOut : [.name : "singOut", .photo : ""]]
    
    enum ProfileOption : Int {
        case personalData
        case changePhoto
        case coordinates
        case singOut
    }
    
    enum ProfileOptionProperty : Int {
        case name
        case photo
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
        

        
    }

    // MARK: - Actions
    
    // MARK: - Methods
    
}
