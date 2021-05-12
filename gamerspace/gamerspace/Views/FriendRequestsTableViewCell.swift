//
//  FriendRequestsTableViewCell.swift
//  gamerspace
//
//  Created by Michael Morales on 5/8/21.
//

import UIKit

protocol FriendRequestsTableViewDelegate: AnyObject {
    func declineFriendRequest(with user_id: Int, with friend_id: Int, with index: Int)
    func acceptFriendRequest(with user_id: Int, with friend_id: Int, with index: Int)
    
}

class FriendRequestsTableViewCell: UITableViewCell {

    weak var delegate: FriendRequestsTableViewDelegate?
    @IBOutlet weak var usernameLabel: UILabel!
    static let identifier = "FriendRequestsTableViewCell"
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var user_id = Int()
    var friend_id = Int()
    var index = Int()
    
    @IBAction func acceptFriendRequest(_ sender: UIButton) {
        print("accepted button pressed")
        delegate?.acceptFriendRequest(with: user_id, with: friend_id, with: index)
    }
    
    @IBAction func declineFriendRequest(_ sender: UIButton) {
        print("declined button pressed")
        delegate?.declineFriendRequest(with: user_id, with: friend_id, with: index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FriendRequestsTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        acceptButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5
        self.layoutIfNeeded()
        // Initialization code
    }
    
    func configure(with model: gamerspaceFriendRequest) {
        self.usernameLabel.text = model.username
        user_id = model.user_id
        friend_id = model.friend_id
        index = model.index
        
       // self.title = model.username
      //  profileButton.setTitle(title, for: .normal)
    }
}
