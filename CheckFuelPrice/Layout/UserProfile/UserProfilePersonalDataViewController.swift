//
//  UserProfilePersonalDataViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension UserProfilePersonalDataViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as? UserProfilePersonalDataTableViewCell else {
            return UITableViewCell()
        }
        cell.valueTextField.isUserInteractionEnabled = false
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

}

class UserProfilePersonalDataViewController: UIViewController {

    // MARK: Variable/Constants
    var items : [FuelUser] = []
    var refUserItems : DatabaseReference? = nil
    var observerHandle : DatabaseHandle = 0
    
    enum RightBarItemStatus : String {
        case edit = "edit"
        case save = "save"
    }
    enum LeftBarItemStatus : String {
        case done = "done"
        case cancel = "cancel"
    }
    
    var rightBarStatusEdited : Bool = false {
        
        didSet {
            if rightBarStatusEdited == true {
                self.rightBarButton.title = RightBarItemStatus.save.rawValue.localized().capitalizingFirstLetter()
                self.leftBarButton.title = LeftBarItemStatus.cancel.rawValue.localized().capitalizingFirstLetter()
            }
            else {
                self.rightBarButton.title = RightBarItemStatus.edit.rawValue.localized().capitalizingFirstLetter()
                self.leftBarButton.title = LeftBarItemStatus.done.rawValue.localized().capitalizingFirstLetter()
            }
        }
    }
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.startObserving()

        self.rightBarStatusEdited = false
    }
    
    deinit {
        log.verbose("")
    }
    
    // MARK: Methods
    func startObserving()  {
        log.verbose("entered")
        // Query for user's data
        DispatchQueue.global().async {
            // create reference to user node
            self.refUserItems = Database.database().reference(withPath: FirebaseNode.users.rawValue)
            // create observer
            let uid = Auth.auth().currentUser?.uid
            log.verbose("uid: \(String(describing: uid))")
            self.observerHandle = self.refUserItems!.queryOrdered(byChild: "uid").queryEqual(toValue: uid).observe(
                .value, with: { [weak self] snapshot in
                    
                    guard let selfweak = self else {
                        log.error("Could not get weak self")
                        return
                    }
                    
                    log.verbose("Returned: users.childrenCount = \(snapshot.childrenCount)")
                    
                    for item in snapshot.children {
                        guard let fuelUser = FuelUser(snapshot: item as! DataSnapshot) else {
                            log.verbose("Cannot parse data")
                            return
                        }
                        selfweak.items.append(fuelUser)
                    }
            })
        }
    }
    
    // MARK: Actions
    @IBAction func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        
        if rightBarStatusEdited == false {
            dismiss(animated: true, completion: nil)
        }
        else {
            rightBarStatusEdited = !rightBarStatusEdited
        }
        
    }
    
    @IBAction func rightBarButtonPressed(_ sender: Any) {
        
        rightBarStatusEdited = !rightBarStatusEdited
    }

    
}
