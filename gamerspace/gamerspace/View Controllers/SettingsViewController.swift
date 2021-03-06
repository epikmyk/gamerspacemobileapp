//
//  SettingsViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/1/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let userData = UserService()
    var username = String()
    
    @IBAction func logOut(_ sender: Any) {
        userData.logout { (UserConfirmation) in
            print(UserConfirmation)
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = 0
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartUpViewController") as! StartUpViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userData.getLoggedInUser { (user) in
            DispatchQueue.main.async {
                self.username = user.username
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileController = segue.destination as? ProfileViewController else {
            return
        }
       
        profileController.profileModel.username = self.username
    }
}
