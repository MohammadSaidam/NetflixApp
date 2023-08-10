//
//  SearchResultsViewControllerExtention.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 10/08/2023.
//

import Foundation
import UIKit

extension SearchResultsViewController :UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            
            return UICollectionViewCell()
            
        }
        let title = titles[indexPath.row]
        cell.configration(with: title.poster_path ?? "")
      
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        
        ApiCaller.shared.getMovie(with: title.original_title ?? " ") { [weak self] result in
            switch result{
            case .success(let videoElements):
                DispatchQueue.main.async {
                    let originalTitle = title.original_title
                    self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewModel(title: originalTitle ?? "", youtubeView: videoElements, titleOverview: title.overview ?? " "))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        
    }

    
    
}
