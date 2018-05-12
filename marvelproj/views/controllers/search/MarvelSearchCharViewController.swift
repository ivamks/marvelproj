//
//  MarvelSearchCharViewController.swift
//  marvelproj
//
//  Created by Andre Nogueira on 05/05/18.
//  Copyright © 2018 Andre Nogueira. All rights reserved.
//

import UIKit

class MarvelSearchCharViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var initialSearchScreen: UIView!
    
    @IBOutlet weak var NoFoundSearch: UIView!
    
    var collectionViewDatasource: CharacterCollectionViewDataSource?
    var characterCollectionViewDelegate: CharacterCollectionViewDelegate?
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var searchedCharacters: NSMutableArray!
    var searchActive : Bool = false
    var searchText: String = ""
}

extension MarvelSearchCharViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NoFoundSearch.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.collectionView.isHidden = true
        self.initialSearchScreen.isHidden = false
        self.searchBar.delegate = self
        self.searchedCharacters = NSMutableArray()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    func setupCollectionView(){
        self.loadingActivity.stopAnimating()
        self.NoFoundSearch.isHidden = true
        self.characterCollectionViewDelegate = CharacterCollectionViewDelegate(self, characters: self.searchedCharacters, numberOfCellsInRow: NUMBER_OF_CELLS_IN_COLLECTION_VIEW_IN_SEARCH_CHARACTERS)
        
        self.collectionViewDatasource = CharacterCollectionViewDataSource(collectionView: self.collectionView, delegate: self.characterCollectionViewDelegate!, array: self.searchedCharacters, nibName:CharacterCollectionViewCell.className)
       
            self.collectionView.isHidden = false
            self.initialSearchScreen.isHidden = true
            self.collectionView.reloadInputViews()
            self.collectionView.reloadData()
        
    }
    
}

extension MarvelSearchCharViewController{
    
    func fetchSearchCharacter(nameStartsWith: String){
        self.loadingActivity.startAnimating()
        MarvelHTTPManager().fetchSearchByNameStartsWith(nameStartsWith: nameStartsWith) { (characters, error) in
            if(characters.count == 0){
                
                self.NoFoundSearch.isHidden = false
                self.loadingActivity.stopAnimating()
                self.initialSearchScreen.isHidden = true
                
                
            }else{
            self.searchedCharacters.removeAllObjects()
            self.searchedCharacters.addObjects(from: characters)
           
            DispatchQueue.main.async {
                self.setupCollectionView()
                }
                
            }
        }

    }
    
}
extension MarvelSearchCharViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        searchBar.resignFirstResponder()
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.initialSearchScreen.isHidden = false
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        searchBar.resignFirstResponder()
        
        if(self.searchText.count == 0){return}
        if(self.searchText.trimmingCharacters(in: .whitespacesAndNewlines).count == 0){return}
        self.fetchSearchCharacter(nameStartsWith: self.searchText)
        searchActive = false;
    }
    
}

extension MarvelSearchCharViewController: MarvelCharacterDelegate{
    
    func didSelectCharacter(index: IndexPath) {
        let nextController = MarvelRouter.instantiateMarvelDetailTransitionViewController()
        nextController.character = searchedCharacters.object(at: index.row) as? Character
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    
    func fetchCharacters() {
    }
    
    
}
