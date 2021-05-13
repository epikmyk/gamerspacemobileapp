//
//  PostTableViewCell.swift
//  gamerspace
//
//  Created by Michael Morales on 5/3/21.
//

import UIKit

struct attributedTextFromHtml {
    var index: Int
    var attributedText: NSAttributedString?
}

protocol PostTableViewCellDelegate: AnyObject {
    func loadUserProfile(with title: String)
    func loadTableViewCellHeight(with cellHeight: CGFloat)
    func loadImage(with postIndex: Int, with index:Int, with attributedText: NSAttributedString?)
}

class PostTableViewCell: UITableViewCell {

    weak var delegate: PostTableViewCellDelegate?
    
    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postTextViewHC: NSLayoutConstraint!
    @IBOutlet weak var profileButton: UIButton!
    private var title: String = ""
    @IBAction func loadUserProfile(_ sender: UIButton) {
        delegate?.loadUserProfile(with: title)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var found = false
    
    func configure(with model: gamerspacePost, with imageModel: [attributedTextFromHtml]) {
        self.postTextView.text = "\(model.post)"
        self.usernameLabel.text = model.username
        
        if checkURL(url: model.post) && !model.hasImage{
            delegate?.loadImage(with: model.index, with: imageModel.count, with: model.post.convertToAttributedFromHTML())
            postTextView.attributedText = model.post.convertToAttributedFromHTML()
        }
        
        postTextView.font = UIFont.systemFont(ofSize: 17.0)
        self.title = model.username
        profileButton.setTitle(title, for: .normal)
        self.postTextViewHC.constant = self.postTextView.contentSize.height
        delegate?.loadTableViewCellHeight(with: self.postTextViewHC.constant)
    }
    
    func configureImages(with model: gamerspacePost, with imageModel: attributedTextFromHtml) {
        self.postTextView.text = "\(model.post)"
        self.usernameLabel.text = model.username
        
        
        if checkURL(url: model.post) && !model.hasImage{
            delegate?.loadImage(with: model.index, with: model.imageIndex, with: model.post.convertToAttributedFromHTML())
            postTextView.attributedText = model.post.convertToAttributedFromHTML()
        }
        
        if model.hasImage {
            postTextView.attributedText = imageModel.attributedText
        }
       
        postTextView.font = UIFont.systemFont(ofSize: 17.0)
        self.title = model.username
        profileButton.setTitle(title, for: .normal)
        self.postTextViewHC.constant = self.postTextView.contentSize.height
        delegate?.loadTableViewCellHeight(with: self.postTextViewHC.constant)
    }
    
    
    func checkURL(url: String) -> Bool {
        //return(url.match(/\.(jpeg|jpg|gif|png)$/) != null)
        let validImageExt: [String] = [".jpeg", ".jpg", ".gif", ".png"]
        for imageExt in validImageExt {
            if url.contains(imageExt) {
                return true
            }
        }
        return false
    }
}
