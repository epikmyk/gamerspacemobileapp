//
//  SearchResultsTableViewCell.swift
//  gamerspace
//
//  Created by Michael Morales on 5/7/21.
//

import UIKit

protocol SearchResultsTableViewCellDelegate: AnyObject {
    func loadUserProfile(with title: String, with user_id: Int)
    //func loadTableViewCellHeight(with cellHeight: CGFloat)
}

class SearchResultsTableViewCell: UITableViewCell {
    
    
    weak var delegate: SearchResultsTableViewCellDelegate?
    var user_id = Int()
    
    @IBOutlet weak var profileButton: UIButton!
    static let identifier = "SearchResultsTableViewCell"
    
    private var title = ""
    
    @IBAction func loadUserProfile(_ sender: UIButton) {
        
        delegate?.loadUserProfile(with: title, with: user_id)
    }
    static func nib() -> UINib {
        return UINib(nibName: "SearchResultsTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: gamerspaceUser) {
        self.title = model.username
        self.user_id = model.user_id
        profileButton.setTitle(title, for: .normal)
    }
    
}
