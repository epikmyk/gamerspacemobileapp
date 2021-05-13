//
//  LoginViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/2/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let userData = UserService()
    
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 194/255, green: 21/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 197/255, blue: 0/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
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
        password.delegate = self
        
        logInButton.layer.cornerRadius = 20
        logInButton.layer.masksToBounds = false
        logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        logInLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        noAccountLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
