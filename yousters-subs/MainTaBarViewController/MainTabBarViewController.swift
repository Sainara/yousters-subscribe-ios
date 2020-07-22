//
//  MainTabBarViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import UserNotifications

class MainTabBarViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        tabBar.isTranslucent = true
        
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance;
        } else {
            // below ios 13.0
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
        tabBar.tintColor = .bgColor
        
        buildTabs()
        guard let cuser = App.shared.currentUser else {
            return
        }
        AuthService.main.me { (user) in
            guard let user = user else {return}
            if !cuser.isSimilar(a: user) {
                self.buildTabs()
                print("reloaded")
            }
        }
        registerForPushNotifications()
    }
    
    private func buildTabs() {
        let vc = ProfileViewController()
        vc.tabBarItem = .init(title: nil, image: UIImage(imageLiteralResourceName: "profile"), tag: 1)
        vc.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let vc2 = MainDocsViewController()
        vc2.tabBarItem = .init(title: nil, image: UIImage(imageLiteralResourceName: "docs"), tag: 0)
        vc2.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        viewControllers = [
            YoustersNavigationController(rootViewController: vc2),
            YoustersNavigationController(rootViewController: vc)
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
            
          print("Permission granted: \(granted)")
          guard granted else { return }
          self?.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
        
    }
}
