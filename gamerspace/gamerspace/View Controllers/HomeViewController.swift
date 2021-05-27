//
//  HomeViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/1/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var notificationsLabel: UILabel!
    
    let userData = UserService()
    let postData = PostService()
    let friendData = FriendService()
    let gameData = GameService()
    
    var models = [gamerspacePost]()
    var username = String()
    var userId = Int()
    var friendRequestCount = 0
    var notificationCount = 0
    var postHeight = CGFloat()
    var htmlImages = [attributedTextFromHtml]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsLabel.layer.cornerRadius = 10
        notificationsLabel.layer.masksToBounds = true
        notificationsLabel.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.handleWritePostModalDismissed), name: NSNotification.Name(rawValue: "writePostModalDismissed"), object: nil)
        self.postHeight = 50
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //get data from logged in user
        userData.getLoggedInUser { (user) in
            
            DispatchQueue.main.async {
                self.username = user.username
                self.userId = user.user_id
                self.greetingLabel.text = "Hi, \(user.username)"
            }
        }
        
        //get pending friend requests
        friendData.getFriendRequests { (friendRequests) in

            DispatchQueue.main.async {
                self.friendRequestCount = friendRequests.count
                UNUserNotificationCenter.current().requestAuthorization(options: .badge)
                     { (granted, error) in
                          if error == nil {
                              // success!
                          }
                     }
                UIApplication.shared.applicationIconBadgeNumber = self.friendRequestCount
                if friendRequests.count > 0 {
                    self.notificationsLabel.isHidden = false
                    self.notificationsLabel.text = String(self.friendRequestCount)
                }
                else {
                    self.notificationsLabel.isHidden = true
                }
            }
        }
        
        //get posts to main feed
        postData.getUserPostsAndFriendsPosts { (posts) in
            DispatchQueue.main.async {
                self.models.removeAll()
                self.htmlImages.removeAll()
                for (index, post) in posts.enumerated() {
                    self.models.append(gamerspacePost(username: post.username, post: post.post, index: index, hasImage: false, imageIndex: 0))
                }
                self.table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
                self.table.delegate = self
                self.table.dataSource = self
                self.table.setNeedsLayout()
                self.table.layoutIfNeeded()
                self.table.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "writePostModalDismissed"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileViewController" {
            guard let profileController = segue.destination as? ProfileViewController else {
                return
            }
            profileController.profileModel.username = self.username
        }
        else if segue.identifier == "WritePostViewController" {
            guard let writePostController = segue.destination as? WritePostViewController else {
                return
            }
            writePostController.postReceiverId = userId
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        let imgIndex = models[indexPath.row].imageIndex
        if models[indexPath.row].hasImage {
            cell.configureImages(with: models[indexPath.row], with: htmlImages[imgIndex])
        }
        else {
            cell.configure(with: models[indexPath.row], with: htmlImages)
        }
        cell.delegate = self
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160 + self.postHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func handleWritePostModalDismissed() {
        postData.getUserPostsAndFriendsPosts { (posts) in
            DispatchQueue.main.async {
                self.models.insert(gamerspacePost(username: "\(posts[0].username)", post: "\(posts[0].post)", index: 0, hasImage: false, imageIndex: 0), at: 0)
                self.table.beginUpdates()
                self.table.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                self.table.endUpdates()
                self.table.reloadData()
            }
        }
    }
}

extension HomeViewController: PostTableViewCellDelegate {
    func loadImage(with postIndex: Int, with index: Int, with attributedText: NSAttributedString?) {
        self.models[postIndex].hasImage = true
        self.models[postIndex].index = postIndex
        self.models[postIndex].imageIndex = index
        self.htmlImages.append(attributedTextFromHtml(index: index, attributedText: attributedText))
    }
    
    func loadTableViewCellHeight(with cellHeight: CGFloat) {
        self.postHeight = cellHeight
    }
    
    func loadUserProfile(with title: String) {
        print("\(title)")
        self.username = title
        self.performSegue(withIdentifier: "ProfileViewController", sender: self.username)
    }
}


