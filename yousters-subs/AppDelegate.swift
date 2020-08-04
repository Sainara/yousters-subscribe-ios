//
//  AppDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import Siren
import StoreKit
import SwiftyJSON
//import SberbankSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        //FirebaseApp.configure()
                
        if #available(iOS 13.0, *) {} else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let homeViewController = RouteProvider.shared.initViewController()
            window!.rootViewController = homeViewController
            window!.makeKeyAndVisible()
            
            
            //Siren.shared.wail()
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
          // 2
          print(JSON(notification))
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
          if let url = userActivity.webpageURL {
            return DeepLinkManager.standart.handleDeeplink(url: url)
          }
       }
       return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
//        if url.scheme == "you-scribe" && url.host == "sberidauth" {
//            SBKAuthManager.getResponseFrom(url) { response in
//                print(response.error)
//                print(response.isSuccess)
//                print(response.nonce)
//            }
//            return true
//        }
        DeepLinkManager.standart.handleDeeplink(url: url)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        PushService.main.addToken(deviceToken: token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       // handle any deeplink
        DeepLinkManager.standart.checkDeepLink(viewController: application.keyWindow?.rootViewController)
    }
    
    func application(_ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable : Any],
      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
        print(JSON(userInfo))
        print("click push")
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print(notification.request.content.body)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let deepLinkRaw = userInfo["deepLink"] as? String, let deepLink = URL(string: deepLinkRaw) {
            DeepLinkManager.standart.handleDeeplink(url: deepLink)
            DeepLinkManager.standart.checkDeepLink(viewController: UIApplication.shared.keyWindow?.rootViewController)
        }
        
        completionHandler()
    }
}
