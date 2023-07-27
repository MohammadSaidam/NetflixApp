//
//  ViewController.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 27/07/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
      
        let v1 = UINavigationController(rootViewController: HomeViewController())
        let v2 = UINavigationController(rootViewController: UpComingViewController())
        let v3 = UINavigationController(rootViewController: SearchViewController())
        let v4 = UINavigationController(rootViewController: DonwnloadsViewController())
        
        
        
        /*
         This code that put title in tab bar
         the same
         v1.tabBarItem.title = "Home"
        */
        v1.title = "Home"
        v2.title = "Coming"
        v3.title = "Top Search"
        v4.title = "Downloads"
        
        
        // this code that put icon in tab bar
        v1.tabBarItem.image = UIImage(systemName: "house")
        v2.tabBarItem.image = UIImage(systemName: "play.circle")
        v3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        v4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        
        tabBar.tintColor = .label
        
        
        // This code that put controllers in tab bar and can move between this
        setViewControllers([v1,v2,v3,v4], animated: true)
    }


}

