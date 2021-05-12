//
//  UserProfileGamesTableViewCell.swift
//  gamerspace
//
//  Created by Michael Morales on 5/10/21.
//

import UIKit

protocol UserProfileGamesTableViewCellDelegate {
    func loadGames()
}

class UserProfileGamesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: UserProfileGamesTableViewCellDelegate?
    
    static let identifier = "UserProfileGamesTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "UserProfileGamesTableViewCell", bundle: nil)
    }
    
    func configure(with models: [GameModel]) {
        DispatchQueue.main.async {
            self.models = models
            self.collectionView.reloadData()
        }
        
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBAction func addGames(_ sender: UIButton) {
        print("add games")
        delegate?.loadGames()
    }
    
    var models = [GameModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(UserProfileGamesCollectionViewCell.nib(), forCellWithReuseIdentifier: UserProfileGamesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileGamesCollectionViewCell.identifier, for: indexPath) as! UserProfileGamesCollectionViewCell
        cell.configure(with: models[indexPath.row])
       // cell.delegate = self
     
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}
