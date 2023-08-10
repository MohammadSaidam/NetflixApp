//
//  TitlePreviewViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 07/08/2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    private let TitleLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry potter"
        
        return label
    }()

    
    private let overviewLable :UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid!"
        
        return label
        
    }()
    
    private let downloadButton :UIButton = {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        return button
        
    }()
    let webView : WKWebView = {
        
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
    
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(TitleLabel)
        view.addSubview(overviewLable)
        view.addSubview(downloadButton)
        view.addSubview(webView)
        configeConstrintes()
    
        // This code hidden tabbar in TitlePreviewViewController
        title = "Movie Detailes"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.tabBarController?.tabBar.isHidden = true
    
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Movie Detailes"
        // This code hidden tabbar in TitlePreviewViewController
        self.tabBarController?.tabBar.isHidden = true
    }
   
    
    func  configeConstrintes(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
            
        ]
        
        let titleLabelConstraints = [
            TitleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            TitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        let overviewLabelConstraints = [
            overviewLable.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor, constant: 10),
            overviewLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            overviewLable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLable.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
   
    func configure(with model: TitlePreviewModel){
        TitleLabel.text = model.title
        overviewLable.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)")else{
            return
        }
        self.webView.load(URLRequest (url: url))
    }

}

