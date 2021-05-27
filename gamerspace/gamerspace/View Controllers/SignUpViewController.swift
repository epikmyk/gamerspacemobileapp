//
//  SignUpViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 4/28/21.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let userData = UserService()
    
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundGradientView.layer.zPosition = -1
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 194/255, green: 21/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 197/255, blue: 0/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) 
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        password.delegate = self
        
        email.layer.cornerRadius = 20
        email.layer.borderWidth = 1
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        email.borderStyle = UITextField.BorderStyle.none
        email.layer.borderColor = UIColor.systemGray5.cgColor
        
        username.layer.cornerRadius = 20
        username.layer.borderWidth = 1
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        username.borderStyle = UITextField.BorderStyle.none
        username.layer.borderColor = UIColor.systemGray5.cgColor
        
        password.layer.cornerRadius = 20
        password.layer.borderWidth = 1
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        password.borderStyle = UITextField.BorderStyle.none
        password.layer.borderColor = UIColor.systemGray5.cgColor

        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.masksToBounds = false
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        createAccountLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        haveAccountLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if
            let emailInput:String = email.text,
            let usernameInput:String = username.text,
            let passwordInput:String = password.text
        {
            userData.createAccount(email: emailInput, username: usernameInput, password: passwordInput) { (UserConfirmation) in
                print(UserConfirmation)
                DispatchQueue.main.async {
                    self.userData.logIn(username: usernameInput, password: passwordInput) { (UserConfirmation) in
                        print(UserConfirmation)
                        DispatchQueue.main.async {
                            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddGamesViewController") as! AddGamesViewController
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.present(nextViewController, animated: false, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
    
  
