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
    private func downloadTitleAt(indexPath:IndexPath){
        
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
@available(iOS 15.0, *)
extension CollectionViewTableViewCell :UICollectionViewDelegate , UICollectionViewDataSource{
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
