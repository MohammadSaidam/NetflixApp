//
//  TitleTableViewCell.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 03/08/2023.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    private let titlePosterUiImageView :UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()

    private let titleLable :UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let playTitlesButton : UIButton = {
        
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        
        return button
        
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // two lines of code that add titleLable , titlePosterUiImageView , playTilesButton in viewController
        
        contentView.addSubview(titlePosterUiImageView)
        contentView.addSubview(titleLable)
        contentView.addSubview(playTitlesButton)
        applyConstraints()
    }
    private func applyConstraints(){
        
        let titlePosterUiImageViewConstrints = [
            titlePosterUiImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUiImageView.topAnchor.constraint(equalTo: contentView.topAnchor ,constant: 10),
            titlePosterUiImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            titlePosterUiImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        let titleLableConstrints = [
            titleLable.leadingAnchor.constraint(equalTo: titlePosterUiImageView.trailingAnchor, constant: 20),
            titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
        ]
        
        let playTitleButtonConstraints = [
            playTitlesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitlesButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(titlePosterUiImageViewConstrints)
        NSLayoutConstraint.activate(titleLableConstrints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
     func configuration(with model: TitleViewModel){
        
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500\(model.poster_URL)") else {return}
        
        
        titlePosterUiImageView.sd_setImage(with: url, completed: nil)
        titleLable.text = model.titleName
        
    }
    
}
