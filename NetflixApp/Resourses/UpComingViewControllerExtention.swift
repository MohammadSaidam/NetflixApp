//
//  UpComingViewControllerExtention.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 10/08/2023.
//

import Foundation
import UIKit

extension UpComingViewController :UITableViewDelegate ,UITableViewDataSource {
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
