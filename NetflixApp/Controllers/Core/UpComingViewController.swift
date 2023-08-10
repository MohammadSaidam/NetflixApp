//
//  UpComingViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 27/07/2023.
//

import UIKit

class UpComingViewController: UIViewController {
    
    public var titles :[Title] = [Title]()
    private let upComingTable :UITableView = {
        // create table View
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        // title in navigation bar
        title = "UpComing"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // I want to register or add tableView was created in view
        
        view.addSubview(upComingTable)
        upComingTable.delegate = self
        upComingTable.dataSource = self
        
        fetchUpComing()
        
    }
    /*
     this code vary important
     that can enable scrol view in View
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upComingTable.frame = view.bounds
    }
    
    private func fetchUpComing(){
        ApiCaller.shared.upComingMovies { [weak self]result in
            switch result {
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async {
                    self?.upComingTable.reloadData()
                }
            case .failure(let error):print(error.localizedDescription)
                
                
                
            }
        }
        
        
        
        
    }
}
