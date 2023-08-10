//
//  CollectionViewTableViewCell.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 28/07/2023.
//

import UIKit
protocol CollectionViewTableViewCellDelegate :AnyObject{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel)
    
}

class CollectionViewTableViewCell: UITableViewCell {
    
     var titles: [Title] = [Title]()
    weak var delegate :CollectionViewTableViewCellDelegate?
    
    static let identifier = "CollectionViewTableViewCell"
    
    // this code that put content in every section in HomeViewController
    private let collectionView : UICollectionView = {
        /*
         this virable layout that definds collectionView and taken it size 
         */
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // I want put the collectionView in every cell
        collectionView.frame = contentView.bounds
    }
    public func configure(with titles:[Title]){
        self.titles = titles
        DispatchQueue.main.async {[weak self] in
            
            self?.collectionView.reloadData()
        }
    }
    public func downloadTitleAt(indexPath:IndexPath){
        
        DataPersistenceManager.shared.downloadingTitle(model: titles[indexPath.row]) { [weak self] result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}


