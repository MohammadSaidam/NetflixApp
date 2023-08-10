//
//  CollectionViewTableViewCellExtention.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 10/08/2023.
//

import Foundation
import UIKit

@available(iOS 15.0, *)
extension CollectionViewTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            
            
            return UICollectionViewCell()
            
        }
        guard let model = titles[indexPath.row].poster_path else{return UICollectionViewCell()}
        
        cell.configration(with: model)
        return cell
                
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let titles = titles[indexPath.row]
        guard let titleName = titles.original_title ?? titles.original_name  else{return}
        ApiCaller.shared.getMovie(with: titleName + "tralier") { [weak self] result in
            switch result {
                
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = titles.overview else{return}
                let viewModel = TitlePreviewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                guard let StrongSelf = self else{return}
                
                self?.delegate?.collectionViewTableViewCellDidTapCell(StrongSelf, viewModel: viewModel)
                
                
            case.failure(let error):print(error.localizedDescription)
            }
        }
                
    }
   

   
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cofig = UIContextMenuConfiguration(identifier: nil,previewProvider: nil) { _ in
            
            let downloadingAction = UIAction(title: "Download",
                                             subtitle: nil ,image: nil,
                                             identifier: nil,
                                             discoverabilityTitle: nil,
                                             state: .off) { _ in
                
                self.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: " ",image: nil,identifier: nil,options: .displayInline,children: [downloadingAction])
            
        }
        return cofig
        
    
    }
    
    
}
