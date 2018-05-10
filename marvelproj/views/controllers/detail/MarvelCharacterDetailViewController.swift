//
//  MarvelCharacterDetailViewController.swift
//  marvelproj
//
//  Created by Andre Nogueira on 08/05/18.
//  Copyright © 2018 Andre Nogueira. All rights reserved.
//

import UIKit

class MarvelCharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var character: Character?
    var comics: [Comics]?
    var series: [Series]?
    var events: [Events]?
    var stories: [Story]?
}

extension MarvelCharacterDetailViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.isHidden = false

        self.tableView.register(UINib(nibName:MarvelDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: MarvelDetailTableViewCell.className)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        
        self.tableView.register(UINib(nibName:MarvelDetailTableViewHeaderCellTableViewCell.className, bundle:nil), forCellReuseIdentifier: MarvelDetailTableViewHeaderCellTableViewCell.className)
        self.tableView.register(UINib(nibName:MarvelDetailStoriesTableViewCell.className, bundle: nil), forCellReuseIdentifier: MarvelDetailStoriesTableViewCell.className)
        MarvelHTTPManager().fetchComics(characterID: character!.id) { (comics, error) in
            self.comics = comics
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        MarvelHTTPManager().fetchSeries(characterID: character!.id) { (series, error) in
            self.series = series
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        MarvelHTTPManager().fetchEvents(characterID: character!.id) { (events, error) in
            self.events = events
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        MarvelHTTPManager().fetchStories(characterID: character!.id) { (stories, error) in
            self.stories = stories
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


class MarvelCharacterDetailViewHeader:UIView{
    
    @IBOutlet weak var marvelCharacterImage: UIImageView!
    @IBOutlet weak var marvelCharacterName: UILabel!
    
    func setupHeader(character: Character){
        self.marvelCharacterName.text = character.name
    }
}

