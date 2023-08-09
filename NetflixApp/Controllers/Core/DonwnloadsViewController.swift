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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStrogeForDownload()
        }
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
        
        
        
        
    }

extension DonwnloadsViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell =  tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{return UITableViewCell()}
        var title = titles[indexPath.row]
        cell.configuration(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "UnKnown", poster_URL: title.poster_path ?? ""))
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        
        ApiCaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
 
    
    
}
