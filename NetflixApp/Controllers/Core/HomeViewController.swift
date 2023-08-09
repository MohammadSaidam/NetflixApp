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

class HomeViewController: UIViewController{
    
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
extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    
    /*
     the function numberOfSection
     i want 20 section and every one section that contain 1 Row
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier,for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        
        switch indexPath.section{
        case Section.TrendingMovie.rawValue:
            ApiCaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
         
            
        case Section.TrendingTvs.rawValue:
            ApiCaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        case Section.Popular.rawValue:
            
            ApiCaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.UpComing.rawValue:
            
            ApiCaller.shared.upComingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TopRated.rawValue:
            ApiCaller.shared.getTopRated { result in
                
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
        
        
        
        //        let cell = UITableViewCell()
        //        cell.textLabel?.text = "Hello World"
        //        cell.backgroundColor = .red
        //
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    // this function that 40 pixel from top the section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font  = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLetters()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitle[section]
    }
    
    // Important ScrollView Code
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let defaultOfSet = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOfSet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
        
    }
    
}
extension HomeViewController :CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}
