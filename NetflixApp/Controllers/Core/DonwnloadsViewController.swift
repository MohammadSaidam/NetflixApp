//
//  DonwnloadsViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 27/07/2023.
//

import UIKit

class DonwnloadsViewController: UIViewController {
    var titles :[TitleItem] = [TitleItem]()
    private let downloadsTableView :UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // title in navigation bar
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadsTableView)
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        NotificationCenter()
      
    }
        override func viewDidLayoutSubviews() {
            downloadsTableView.frame = view.bounds
        }
        private func fetchLocalStrogeForDownload(){
            DataPersistenceManager.shared.fetchingTitlesFromDatabase {[weak self] result in
                
                switch result{
                    
                case .success(let titles):
                    self?.titles = titles
                    DispatchQueue.main.async {
                        self?.downloadsTableView.reloadData()
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
    private func NotificationCenter(){
        Foundation.NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStrogeForDownload()
        }
    }
        
        
        
        
    }

