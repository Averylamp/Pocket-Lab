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
    case SelectRPM
    case Ratios
    case Microscope
    case OpenCV
    case OpenCV2
}


protocol Navigation {
    func goToPage(page: Page)
    func setHiddenNavigationBar(hidden: Bool, animated: Bool)
}

class AppController: UINavigationController {

  //  var startView = StartViewController(nibName: "StartViewController", bundle: NSBundle.mainBundle())
//    var optionsView = OptionsViewController(nibName: "OptionsViewController", bundle: NSBundle.mainBundle())
    //var opencv = OpenCVTestViewController(nibName: "OpenCVTestViewController", bundle: NSBundle.mainBundle())
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = true
        
        navigationBar.hidden = true
        self.pushViewController(StartViewController.generate(delegate: self), animated: false)
      //  pushViewController(HaematocritViewController.generate(delegate: self), animated: false)
        //pushViewController(opencv, animated: false)
        super.viewDidLoad()
    }

}

extension AppController: Navigation {

    func goToPage(page: Page) {
        
        if page == .Options {
            self.setViewControllers([OptionsViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .OpenCV {
            self.setViewControllers([OpenCVTestViewController.generate()], animated: false)
        }
        
        if page == .SelectRPM {
            self.setViewControllers([SelectRPMViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .Centrifuge {
            self.setViewControllers([CentrifugeViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .OpenCV2 {
            self.setViewControllers([BloodShapeStartViewController.generate()], animated: false)
        }
        
    }
    
    func setHiddenNavigationBar(hidden: Bool, animated: Bool) {
        self.setNavigationBarHidden(hidden, animated: animated)
    }
    
}