//
//  NotificationsViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/8/21.
//

import UIKit

struct gamerspaceFriendRequest {
    var status: Int
    var user_id: Int
    var friend_id: Int
    var username: String
    var created: String
    var index: Int
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var models = [gamerspaceFriendRequest]()
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestsTableViewCell.identifier, for: indexPath) as! FriendRequestsTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    var friendData = FriendService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        friendData.getFriendRequests { (friendRequests) in
            DispatchQueue.main.async {
                for (index, friendRequest) in friendRequests.enumerated() {
                    self.models.append(gamerspaceFriendRequest(status: friendRequest.status, user_id: friendRequest.friend_id, friend_id: friendRequest.user_id, username: friendRequest.username, created: friendRequest.created, index: index))
                }
                self.table.register(FriendRequestsTableViewCell.nib(), forCellReuseIdentifier: FriendRequestsTableViewCell.identifier)
                self.table.delegate = self
                self.table.dataSource = self
                self.table.setNeedsLayout()
                self.table.layoutIfNeeded()
                self.table.reloadData()
            }
        }
    }
}

extension NotificationsViewController: FriendRequestsTableViewDelegate {
    func acceptFriendRequest(with user_id: Int, with friend_id: Int, with index: Int) {
        friendData.acceptFriendRequest(user_id: user_id, friend_id: friend_id) { (FriendConfirmation) in
            print(FriendConfirmation)
            DispatchQueue.main.async {
                print("UserID: \(user_id) FriendID: \(friend_id)")
                self.models.remove(at: index)
                let indexPath = IndexPath(item: index, section: index)
                self.table.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func declineFriendRequest(with user_id: Int, with friend_id: Int, with index: Int) {
        print("UserID: \(user_id) FriendID: \(friend_id)")
        friendData.deleteFriend(user_id: user_id, friend_id: friend_id) { (FriendConfirmation) in
            print(FriendConfirmation)
            DispatchQueue.main.async {
                self.models.remove(at: index)
                let indexPath = IndexPath(item: index, section: index)
                self.table.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
}
