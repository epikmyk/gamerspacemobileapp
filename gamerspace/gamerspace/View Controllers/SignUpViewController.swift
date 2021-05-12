//
//  SignUpViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 4/28/21.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let userData = UserResponses()
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.delegate = self
        
        
        
        
        backgroundGradientView.layer.zPosition = -1
        /*
        let gradientLayer = CAGradientLayer()
                // Set the size of the layer to be equal to size of the display.
                gradientLayer.frame = view.bounds
                // Set an array of Core Graphics colors (.cgColor) to create the gradient.
                // This example uses a Color Literal and a UIColor from RGB values.
                gradientLayer.colors = [#colorLiteral(red: 0.3176470588, green: 0.1647058824, blue: 0.3450980392, alpha: 1).cgColor, UIColor(red: 173/255, green: 74/255, blue: 103/255, alpha: 1).cgColor]
                // Rasterize this static layer to improve app performance.
                gradientLayer.shouldRasterize = true
                // Apply the gradient to the backgroundGradientView.
                backgroundGradientView.layer.addSublayer(gradientLayer)*/
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
    
  
