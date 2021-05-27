//
//  SearchViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/6/21.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var userData = UserService()
    var models = [gamerspaceUser]()
    var username = String()
    var user_id = Int()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileController = segue.destination as? ProfileViewController else {
            return
        }
        profileController.profileModel.username = self.username
        profileController.profileModel.user_id = self.user_id
    }
    
    @IBAction func exit(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        print("hit exit")
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchResultsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        searchResultsView.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath) as! SearchResultsTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchInput:String = textField.text {
           // print(searchInput)
            self.models.removeAll()
            let searchTerm = searchInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let search:String = searchTerm {
                userData.searchUsers(username: search) { (users) in
                    DispatchQueue.main.async {
                        self.searchResultsView.isHidden = false
                        for user in users {
                            print("User: \(user.user_id)")
                            self.models.append(gamerspaceUser(user_id: user.user_id, username: user.username, created: user.created))
                        }
                        self.table.register(SearchResultsTableViewCell.nib(), forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
                        self.table.delegate = self
                        self.table.dataSource = self
                        self.table.setNeedsLayout()
                        self.table.layoutIfNeeded()
                        self.table.reloadData()
                    }
                    
                }
            }
    
        }
        return true
    }
}

extension SearchViewController: SearchResultsTableViewCellDelegate {
    func loadUserProfile(with title: String, with user_id: Int) {
        self.username = title
        self.user_id = user_id
        self.performSegue(withIdentifier: "ProfileViewController", sender: self.username)
    }
}

