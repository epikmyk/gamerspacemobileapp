//
//  FriendsViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/7/21.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func exit(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        print("hit exit")
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var table: UITableView!
    var friendData = FriendResponses()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
        friendData.getFriends { (friends) in
            DispatchQueue.main.async {
                for friend in friends {
                    self.models.append(gamerspaceUser(user_id: friend.user_id, username: friend.username, created: friend.created))
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
}

extension FriendsViewController: SearchResultsTableViewCellDelegate {
    func loadUserProfile(with title: String, with user_id: Int) {
        self.username = title
        self.user_id = user_id
        self.performSegue(withIdentifier: "ProfileViewController", sender: self.username)
    }
}


