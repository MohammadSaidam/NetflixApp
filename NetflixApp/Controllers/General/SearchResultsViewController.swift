//
//  SearchResultsViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 04/08/2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel)
}

class SearchResultsViewController: UIViewController {
    
    var titles : [Title] = [Title]()
    public weak var delegate : SearchResultsViewControllerDelegate?
    
    public let searchResultCollectionView :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier )
        
        return collection
        
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.delegate = self

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }


}
extension SearchResultsViewController :UICollectionViewDelegate , UICollectionViewDataSource {
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


