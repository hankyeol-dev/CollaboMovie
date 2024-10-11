//
//  MainTabbarController.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import UIKit

class MainTabbarController: UITabBarController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      setTabbar()
   }
   
   private func setTabbar() {
      let home = UINavigationController(
         rootViewController: HomeViewController()
      )
      let search = UINavigationController(
         rootViewController: SearchViewController()
      )
      let like = UINavigationController(
         rootViewController: LikeViewController()
      )
      home.tabBarItem = UITabBarItem(
         title: "Home", image: Icons.house.asUIImage(),tag: 0)
      search.tabBarItem = UITabBarItem(
         title: "Top Search", image: Icons.magnifyingglass.asUIImage(), tag: 1)
      like.tabBarItem = UITabBarItem(
         title: "Download", image: Icons.square.asUIImage(), tag: 2
         )
      
      tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.2)
      tabBar.tintColor = .white
      tabBar.backgroundColor = .black
      
      setViewControllers([home, search, like], animated: true)
   }
}

