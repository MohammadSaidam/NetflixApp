//
//  HeroHeaderUIView.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 28/07/2023.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    
    
    private let playButton :UIButton = {
        let playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 1
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 5
        return playButton
        
    }()
    
    
    private let dwonloadButton :UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
        
        
    }()
    
    private let hearoImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        
        
        return imageView
        
    }()
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.systemBackground.cgColor]
        
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
    }
    private func applyConstraints(){
        let playButtonConstraint = [
            playButton.leadingAnchor.constraint(equalTo :leadingAnchor , constant : 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
            
        ]
        let dwonloadButtonConstraints = [
            dwonloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70 ),
            dwonloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50 ),
            dwonloadButton.widthAnchor.constraint(equalToConstant: 100)
            
        ]
        NSLayoutConstraint.activate(playButtonConstraint)
        NSLayoutConstraint.activate(dwonloadButtonConstraints)
    }
    public func configure(with model:TitleViewModel){
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500\(model.poster_URL)") else {return}
        self.hearoImageView.sd_setImage(with: url,completed: nil)
    }
    
    
    /*
     1.image
     2. button dwonload
     3. button play
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hearoImageView)
        
        addSubview(playButton)
        addSubview(dwonloadButton)
        addGradient()
        applyConstraints()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        hearoImageView.frame = bounds
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
