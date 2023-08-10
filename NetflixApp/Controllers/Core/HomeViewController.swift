//
//  HomeViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 27/07/2023.
//

import UIKit

enum Section :Int {
    case TrendingMovie = 0
    case TrendingTvs = 1
    case Popular = 2
    case UpComing = 3
    case TopRated = 4
    
}

class HomeViewController : UIViewController {
    
    
    let sectionTitle :[String] = ["Trending Movies","Trending TV","Popular","Up Copming Movies","Top rated"]
    private var randomTrendingMovie :Title?
    // create  object from HeroHeaderViewUIView
    private var headerView: HeroHeaderUIView?
    
    private let homefeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // add that cell created in view
        view.addSubview(homefeedTable)
        homefeedTable.delegate = self
        homefeedTable.dataSource = self
        
        
        homefeedTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height:450 ))
        
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        
        // add HeaderView was created in homefeedTable
        homefeedTable.tableHeaderView = headerView
        
        
        configeNavBar()
        title = "Home"
        //navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
      
        configureHeroHeaderView()
       
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    private func configureHeroHeaderView(){
        
        ApiCaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let title):
                let selectTitle = title.randomElement()
                self?.randomTrendingMovie = selectTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectTitle?.original_title ?? "", poster_URL: selectTitle?.poster_path ?? " "))
            case .failure(let error ):print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homefeedTable.frame = view.bounds
    }
    private func configeNavBar(){
        /*
         this codde taht add nitflex icon or image in left Navigation Bar
         */
        var logo = UIImage(named: "netflixLogo")
        // this code that display image in original
        logo = logo?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo, style: .done, target: self, action: nil)
        
        // rightBarButtonItems this is an array of items that can be put in rightNavigation Bar
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        
        navigationController?.navigationBar.tintColor = UIColor.white
     
    }
    
    
    
    
}


