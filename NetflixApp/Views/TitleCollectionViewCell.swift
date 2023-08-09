//
//  TitleCollectionViewCell.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 02/08/2023.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        
        return image
        
    }()
    static let identifier = "TitleCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    public func configration(with model: String){
    
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)")else{
            return
        }
        posterImageView.sd_setImage(with: url,completed: nil)
        
        
    }
    
}
