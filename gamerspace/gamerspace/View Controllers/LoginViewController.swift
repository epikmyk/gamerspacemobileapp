//
//  LoginViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/2/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let userData = UserResponses()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
        if
            let usernameInput:String = username.text,
            let passwordInput:String = password.text
        {
            
            userData.logIn(username: usernameInput, password: passwordInput) { (UserConfirmation) in
                print(UserConfirmation)
                DispatchQueue.main.async {
                    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    nextViewController.modalPresentationStyle = .fullScreen
                    self.present(nextViewController, animated: false, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
