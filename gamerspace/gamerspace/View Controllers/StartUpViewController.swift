//
//  ViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 4/28/21.
//

import UIKit


func userLoggedIn() -> Bool {
    let cookieJar = HTTPCookieStorage.shared

    for cookie in cookieJar.cookies! {

       if cookie.name == "cookieKey" {
          return true
       }
    }
    return false
}

class StartUpViewController: UIViewController {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var gamerSpaceLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var gamerSpaceLogo: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        createAccountButton.layer.cornerRadius = 25
        createAccountButton.layer.masksToBounds = false
        createAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        taglineLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        gamerSpaceLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 194/255, green: 21/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 197/255, blue: 0/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userLoggedIn() {
            
            let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! UINavigationController
            self.navigationController?.pushViewController(dashboard, animated: true)
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: false, completion: nil)
        }
    }
}

