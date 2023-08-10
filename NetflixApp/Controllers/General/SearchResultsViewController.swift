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



