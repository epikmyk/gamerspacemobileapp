//
//  SearchResultsTableCell.swift
//  gamerspace
//
//  Created by Michael Morales on 5/7/21.
//

import UIKit

protocol SearchCellDelegate: AnyObject {
    func loadUserProfile(with title: String)
    func loadTableViewCellHeight(with cellHeight: CGFloat)
}

class SearchResultsTableViewCell: UITableViewCell {
    
    
    weak var delegate: PostTableViewCellDelegate?
    
    static let identifier = "SearchResultsTableCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchResultsTableCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: UserSearchResults) {
        
    }
    
}
