//
//  UpComingViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 27/07/2023.
//

import UIKit

class UpComingViewController: UIViewController {
    
    private var titles :[Title] = [Title]()
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
extension UpComingViewController :UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configuration(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "unknwon", poster_URL: title.poster_path!))
        return cell
        
                
                
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titelName = title.original_title ?? title.original_name else{return}
        
        ApiCaller.shared.getMovie(with: titelName) { result in
            
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewModel(title: titelName, youtubeView: videoElement, titleOverview: title.overview ?? " "))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
                
            case .failure(let error):print(error.localizedDescription)
                
            }
            
        }
    }
    
    
}
