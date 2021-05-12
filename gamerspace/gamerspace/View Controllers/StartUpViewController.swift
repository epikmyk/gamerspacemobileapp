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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userLoggedIn() {
            print("user is logged in")
        } else {
            print("user is logged out")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userLoggedIn() {
            /*
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! HomeViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: false, completion: nil)*/
            
            let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! UINavigationController
            self.navigationController?.pushViewController(dashboard, animated: true)
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: false, completion: nil)
        }
    }
}

