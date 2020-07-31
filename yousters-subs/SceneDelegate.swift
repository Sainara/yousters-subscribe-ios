//
//  SceneDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import Siren
import StoreKit
//import SberbankSDK

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = RouteProvider.shared.initViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
        
        //let iapObserver = StoreObserver()
        //SKPaymentQueue.default().add(iapObserver)
        //Siren.shared.wail()
        
        if let userActivity = connectionOptions.userActivities.first {
            if let url = userActivity.webpageURL {
                DeepLinkManager.standart.handleDeeplink(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //windowScene.windows.first?.rootViewController
        DeepLinkManager.standart.checkDeepLink(viewController: windowScene.windows.first?.rootViewController)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        //print("!!!!!!")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                DeepLinkManager.standart.handleDeeplink(url: url)
                
//                if url.scheme == "you-scribe" && url.host == "sberidauth" {
//                    SBKAuthManager.getResponseFrom(url) { response in
//                        // MARK: Make auth
//                    }
//                }
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // Handle URL
            
            
//            if url.scheme == "you-scribe" && url.host == "sberidauth" {
//                SBKAuthManager.getResponseFrom(url) { response in
//                    print(response.error)
//                    print(response.isSuccess)
//                    print(response.nonce)
//                }
//                return
//            }
            
            DeepLinkManager.standart.handleDeeplink(url: url)
        }
    }
    
//    func scene(_ scene: UIScene,
//               willConnectTo session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//
//
//    }
    

}

