//
//  SearchViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 27/07/2023.
//

import UIKit

class SearchViewController: UIViewController{
  
    
     public var titles : [Title] = [Title]()
    
    public  var tableViewSearch : UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
        
    }()
    
    public var  searchController :UISearchController = {
       // The UISearchController is defined before in xcode
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for Movie and TV s how"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
     
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableViewSearch)
        tableViewSearch.dataSource = self
        tableViewSearch.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor  = .white
        
        fetchDiscoverMovies()
        searchController.searchResultsUpdater = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewSearch .frame = view.bounds
    }
    func fetchDiscoverMovies(){
        ApiCaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.tableViewSearch.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        
        
        
        
    }
}

