//
//  YoustersNavigationController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class YoustersNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.shadowColor = nil
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: Fonts.standart.gilroySemiBoldName(ofSize: 18)]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.font: Fonts.standart.gilroySemiBoldName(ofSize: 33)]
            navBarAppearance.shadowImage = nil
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            // below ios 13.0
            navigationBar.shadowImage = UIImage()
            //navigationBar.backgroundImage = UIImage()
        }
        
        navigationBar.isTranslucent = true
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = .bgColor
        
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: Fonts.standart.gilroyMedium(ofSize: 33)]
        
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Fonts.standart.gilroyMedium(ofSize: 23)]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Fonts.standart.gilroyMedium(ofSize: 23)], for: .normal)
    }
    
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        viewController.
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
