//
//  AppController.swift
//  Draculapp
//
//  Created by Mark Larah on 04/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

enum Page {
    case Start
    case Options
    case Centrifuge
    case Ratios
    case Microscope
}


protocol Navigation {
    func goToPage(page: Page)
}

class AppController: UINavigationController {

    var startView = StartViewController(nibName: "StartViewController", bundle: NSBundle.mainBundle())
    var optionsView = OptionsViewController(nibName: "OptionsViewController", bundle: NSBundle.mainBundle())
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = true
        
        startView.delegate = self
        
        navigationBar.hidden = true
        self.pushViewController(startView, animated: false)
        super.viewDidLoad()
    }

}

extension AppController: Navigation {

    func goToPage(page: Page) {
        
        if page == .Options {
            self.setViewControllers([optionsView], animated: false)
        }
        
    }
    
}