//
//  SearchViewControllerExtention.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 10/08/2023.
//

import Foundation
import UIKit
/*
 UISearchResultsUpdating, SearchResultsViewControllerDelegate
 */
extension SearchViewController :UITableViewDelegate , UITableViewDataSource,SearchResultsViewControllerDelegate ,UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? title.original_name ?? "unknown", poster_URL: title.poster_path!)
        cell.configuration(with: model)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let quary = searchBar.text,
              !quary.trimmingCharacters(in: .whitespaces).isEmpty,
              quary.trimmingCharacters(in: .whitespaces).count >= 3,
                let resultController = searchController.searchResultsController as?SearchResultsViewController else {
            return
        }
        resultController.delegate = self
        ApiCaller.shared.search(with: quary) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let title):
                    resultController.titles = title
                    resultController.searchResultCollectionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        }
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
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
}
