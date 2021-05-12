//
//  ProfileViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/4/21.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    //
    func loadUserProfileData(with user_id: Int)
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ProfileViewControllerDelegate?
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var writePostButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBAction func addFriend(_ sender: UIButton) {
        print("friend request pending...");
        friendData.friendRequest(friend_id: self.profileModel.user_id) { (FriendConfirmation) in
            print(FriendConfirmation)
        }
    }
    let userData = UserResponses()
    let postData = PostResponses()
    let friendData = FriendResponses()
    let gameData = GameResponses()
    var profileModel = Profile(username: "", user_id: 0)
    var models = [gamerspacePost]()
    var htmlImages = [attributedTextFromHtml]()
    var loggedInUsername = String()
    var friendRequestCount = 0
    var notificationCount = 0
    var gameModels = [GameModel]()
    
    var postHeight = CGFloat()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WritePostViewController" {
            guard let writePostController = segue.destination as? WritePostViewController else {
                return
            }
            writePostController.postReceiverId = profileModel.user_id
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileGamesTableViewCell.identifier, for: indexPath) as! UserProfileGamesTableViewCell
            cell.configure(with: gameModels)
            cell.delegate = self
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            let imgIndex = models[indexPath.row - 1].imageIndex
            if models[indexPath.row - 1].hasImage {
                cell.configureImages(with: models[indexPath.row - 1], with: htmlImages[imgIndex])
            }
            else {
                cell.configure(with: models[indexPath.row - 1], with: htmlImages)
            }
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 120 + 140 + view.frame.size.width
        if indexPath.row == 0 {
            return 190
        }
        return 160 + self.postHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsLabel.layer.cornerRadius = 10
        notificationsLabel.layer.masksToBounds = true
        notificationsLabel.isHidden = true
        self.addFriendButton.isHidden = true
        self.writePostButton.isHidden = true
    
    }
    
    @objc func handleWritePostModalDismissed(_ notification: NSNotification) {
        print("USERNAME IS: \(profileModel.username)")
        postData.getUserPosts(username: profileModel.username) { (posts) in
            DispatchQueue.main.async {
                print("we IN HERE")
                self.models.insert(gamerspacePost(username: "\(posts[0].username)", post: "\(posts[0].post)", index: 0, hasImage: false, imageIndex: 0), at: 0)
                self.table.beginUpdates()
                self.table.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                self.table.endUpdates()
                self.table.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "writePostModalDismissed"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //get pending friend requests
        friendData.getFriendRequests { (friendRequests) in

            DispatchQueue.main.async {
                self.friendRequestCount = friendRequests.count
                if friendRequests.count > 0 {
                    self.notificationsLabel.isHidden = false
                    self.notificationsLabel.text = String(self.friendRequestCount)
                }
                else {
                    self.notificationsLabel.isHidden = true
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleWritePostModalDismissed(_:)), name: NSNotification.Name(rawValue: "writePostModalDismissed"), object: nil)
        
        self.postHeight = 50
        
        DispatchQueue.main.async {
            self.greetingLabel.text = "\(self.profileModel.username)"
        }
        
        updatePosts()
        updateButtons()
    }
    
    func updatePosts() -> Void {
        postData.getUserPosts(username: self.profileModel.username) { (posts) in
            print("updateposts for \(self.profileModel.username)")
            self.models.removeAll()
            DispatchQueue.main.async {
                for (index, post) in posts.enumerated() {
                    self.models.append(gamerspacePost(username: post.username, post: post.post, index: index, hasImage: false, imageIndex: 0))
                }
                self.table.register(UserProfileGamesTableViewCell.nib(), forCellReuseIdentifier: UserProfileGamesTableViewCell.identifier)
                self.table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
                self.table.delegate = self
                self.table.dataSource = self
                self.table.setNeedsLayout()
                self.table.layoutIfNeeded()
                self.table.reloadData()
            }
        }
    }
    
    func updateButtons() -> Void {
        userData.getLoggedInUser { (User) in
           
            //if logged in user is the same as profile user
            self.loggedInUsername = User.username
            print("logged in user \(self.loggedInUsername)")
            if User.username == self.profileModel.username {
                self.profileModel.user_id = User.user_id
                print("USER ID IS \(self.profileModel.user_id)")
                DispatchQueue.main.async {
                    self.addFriendButton.isHidden = true
                    self.writePostButton.isHidden = false
                    self.writePostButton.setTitle("Say something...", for: .normal)
                }
            }
            else {
                self.userData.getUser(username: self.profileModel.username) { (User) in
                   // print("USER ID is: \(User.username)")
                    print(self.profileModel.username)
                    self.profileModel.user_id = User.user_id
                }
                self.friendData.getFriendStatus(username: User.username, friendUsername: self.profileModel.username) { (Friend) in
                    DispatchQueue.main.async {
                        print("FRIEND STATUS: \(Friend.status)")
                        if Friend.status == 0 {
                            print("pending friend status")
                            self.addFriendButton.isHidden = false
                            self.writePostButton.isHidden = true
                            
                        }
                        else if Friend.status == 1 {
                            print("friends")
                            self.addFriendButton.isHidden = true
                            self.writePostButton.isHidden = false
                            self.writePostButton.setTitle("Write something to \(self.profileModel.username)...", for: .normal)
                            
                        }
                        else {
                            print("not friends")
                            self.addFriendButton.isHidden = false
                            self.writePostButton.isHidden = true
                        }
                    }
                }
            }
            self.updateFavoriteGames()
        }
    }
    func updateFavoriteGames() -> Void {
        gameData.getFavoriteGames(user_id: self.profileModel.user_id) {(Games) in
            DispatchQueue.main.async {
                for game in Games {
                    if
                        let image = game.background_image,
                        let name = game.name,
                        let slug = game.slug
                    
                    {
                        print(slug)
                        self.gameModels.append(GameModel(slug: slug, text: name, image: image))
                    }
                }
                self.table.register(UserProfileGamesTableViewCell.nib(), forCellReuseIdentifier: UserProfileGamesTableViewCell.identifier)
                self.table.reloadData()
            }
        }
    }
}

extension ProfileViewController: PostTableViewCellDelegate {
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
        print("before if")
        if self.profileModel.username != title {
            print("in if")
            self.profileModel.username = title
            
            DispatchQueue.main.async {
                self.greetingLabel.text = "\(self.profileModel.username)"
            }
            updatePosts()
            updateButtons()
        }
        self.userData.getUser(username: self.profileModel.username) { (User) in
            self.profileModel.user_id = User.user_id
        }
    }
}

extension ProfileViewController: UserProfileGamesTableViewCellDelegate {
    func loadGames(with name: String) {
        //do something
    }
}
