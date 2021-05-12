//
//  AddGamesCollectionViewCell.swift
//  gamerspace
//
//  Created by Michael Morales on 5/11/21.
//

import UIKit

class AddGamesCollectionViewCell: UICollectionViewCell {
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.gameImage.image = UIImage(data: data)
            }
        }
    }
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var selectedOverlayView: UIView!
    @IBOutlet weak var selectedOverlayImage: UIImageView!
    
    static let identifier = "AddGamesCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: GameModel) {
        self.gameNameLabel.text = model.text
        let imageURL = URL(string: model.image)
        if let image:URL = imageURL {
            downloadImage(from: image)
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "AddGamesCollectionViewCell", bundle: nil)
    }

}
