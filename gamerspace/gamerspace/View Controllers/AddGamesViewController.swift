//
//  AddGamesViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/11/21.
//

import UIKit

class AddGamesViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var models = [GameModel]()
    var gameAdded = [Bool]()
    var favoriteGames = [GameModel]()
    var favoriteGameIndex = [Int]()
    var favoriteGameName = [String]()
    let gameData = GameResponses()
    var cellOverlay = [Bool]()

    @IBAction func addFavoriteGames(_ sender: UIButton) {
        let group = DispatchGroup()
        for games in self.favoriteGames {
            group.enter()
            self.gameData.addFavoriteGame(slug: games.slug, name: games.text, image: games.image) { (Confirmation) in
                print(Confirmation)
                group.leave()
            }
        }
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: false, completion: nil)
    }
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddGamesCollectionViewCell.identifier, for: indexPath) as! AddGamesCollectionViewCell
        
        cell.configure(with: models[indexPath.row])
        
        if cellOverlay[indexPath.row] {
            cell.selectedOverlayImage.isHidden = false
            cell.selectedOverlayView.isHidden = false
        }
        else {
            cell.selectedOverlayImage.isHidden = true
            cell.selectedOverlayView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddGamesCollectionViewCell.identifier, for: indexPath) as! AddGamesCollectionViewCell
     
        cell.reloadInputViews()
        
        
        if let index = favoriteGameName.firstIndex(of: models[indexPath.row].text) {
            favoriteGameName.remove(at: index)
            favoriteGames.remove(at: index)
            cellOverlay[indexPath.row] = false
            print("removing game")
        } else {
            favoriteGames.append(GameModel(slug: models[indexPath.row].slug, text: models[indexPath.row].text, image: models[indexPath.row].image))
            favoriteGameName.append(models[indexPath.row].text)
            cellOverlay[indexPath.row] = true
            print("adding game")
        }
        
        for game in favoriteGames {
            print("\(game.text)")
        }
        
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        let layout = UICollectionViewFlowLayout()
        let screenSize: CGRect = UIScreen.main.bounds
        layout.itemSize = CGSize(width: screenSize.width / 2.5, height: 120)
        collectionView.collectionViewLayout = layout
        collectionView.register(AddGamesCollectionViewCell.nib(), forCellWithReuseIdentifier: AddGamesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameData.getGames { (Response) in
            DispatchQueue.main.async {
                for game in Response.results {
                    if
                        let image = game.background_image,
                        let name = game.name,
                        let slug = game.slug
                    {
                        print(name)
                        self.models.append(GameModel(slug: slug, text: name, image: image))
                        self.cellOverlay.append(false)
                        self.gameAdded.append(false)
                        self.favoriteGameIndex.append(0)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("searched")
        if let searchInput:String = textField.text {
            let searchTerm = searchInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let search:String = searchTerm {
                gameData.search(searchTerm: search) { (Response) in
                    DispatchQueue.main.async {
                        self.models.removeAll()
                        for game in Response.results {
                            if
                                let image = game.background_image,
                                let name = game.name,
                                let slug = game.slug
                            {
                                print(name)
                                self.models.append(GameModel(slug: slug, text: name, image: image))
                                self.cellOverlay.append(false)
                                self.gameAdded.append(false)
                                self.favoriteGameIndex.append(0)
                            }
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        return true
    }
}
