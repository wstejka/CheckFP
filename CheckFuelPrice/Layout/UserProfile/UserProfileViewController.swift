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
            let descriptionText = descriptionNode[ProfileOptionProperty.name] as? String,
            let imageName = descriptionNode[ProfileOptionProperty.photo] as? String,
            let color = descriptionNode[ProfileOptionProperty.color] as? ThemesManager.Colors else {
                return cell
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        // Let's add objects to UIView programmatically !!
        // Remark: Much more efficient and easy way is to use the storyboard and it's features ...
        //         The reason I'm doing it here is to present that it's possible and how to do it
        // ======= Button ======= //
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 30.0))
        cell.addSubview(button)
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        // button's constraints
        button.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 30).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.8).isActive = true
        
        let tintedImage = UIImage(named: imageName )?.tinted()
        button.tintColor = ThemesManager.instance().get(color: color)
        button.setImage(tintedImage, for: .normal)
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
        label.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true

        return cell
    }

    func buttonAction(sender: UIButton!) {
        log.verbose("Button tapped: \(sender.description)")
    }
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.verbose("didSelectRowAtIndex: \(indexPath.row), type: \(ProfileOption.singOut.rawValue)")
        
        if indexPath.row == ProfileOption.personalData.rawValue {
            self.processPersonalData()
        }
        else if indexPath.row == ProfileOption.singOut.rawValue {
            self.processSignOut()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

class UserProfileViewController: UIViewController {

    // MARK: Constants/Variable
    let profileOptionsArray : [ProfileOption : [ProfileOptionProperty : Any]] =
        [.personalData : [.name : "personalData", .photo : "businessCard", .color : ThemesManager.Colors.blue],
         .changePhoto : [.name : "changePhoto", .photo : "camera", .color : ThemesManager.Colors.orange],
         .coordinates : [.name : "coordinates", .photo : "location", .color : ThemesManager.Colors.yellow],
         .singOut : [.name : "singOut", .photo : "logout", .color : ThemesManager.Colors.lightBlue]]
    
    enum ProfileOption : Int {
        case personalData
        case changePhoto
        case coordinates
        case singOut
    }
    
    enum ProfileOptionProperty : Int {
        case name
        case photo
        case color
    }
    
    let signOutSegueName = "unwindToFuelInfoAndSingOutWithSender"
    let personalDataSegueName = "userProfilePersonalDataSegue"
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
        

        
    }

    // MARK: - Actions
    
    // MARK: - Methods
    func processSignOut() {
        log.verbose("entered")
        let title = "doyouwanttosignout".localized().capitalizingFirstLetter() + " ?"
        let actionSheet = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let signoutAction = UIAlertAction(title : "answerYes".localized().capitalizingFirstLetter(), style : UIAlertActionStyle.default){
            (action) in
            log.verbose("Yes")
            self.performSegue(withIdentifier: self.signOutSegueName, sender: nil)
            
        }
        let ignoreAction = UIAlertAction(title: "answerNo".localized().capitalizingFirstLetter(),
                                         style: UIAlertActionStyle.default, handler: { action in
                                            log.verbose("No")
        })
        
        actionSheet.addAction(ignoreAction)
        actionSheet.addAction(signoutAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func processPersonalData() {
        log.verbose("entered")

        guard let navigationViewController = storyboard?.instantiateViewController(withIdentifier: "UserProfilePersonalDataNavigationController") else {
            log.error("Could not instantiate \"UserProfilePersonalDataNavigationController\" object")
            return
        }
        navigationViewController.modalTransitionStyle = .coverVertical
        present(navigationViewController, animated: true, completion: nil)
        
    }
    
}
