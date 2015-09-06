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
    case LiveCV
    case OpenCV
    case OpenCV2
    case Haematocrit
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
        //pushViewController(HaematocritViewController.generate(delegate: self), animated: false)
        self.pushViewController(OpenCVTestViewController.generate(), animated: true)
        super.viewDidLoad()
    }

}

extension AppController: Navigation {

    func goToPage(page: Page) {
        
        if page == .Options {
            self.setViewControllers([OptionsViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .OpenCV {
            self.pushViewController(OpenCVTestViewController.generate(), animated: true)
//            self.setViewControllers([OpenCVTestViewController.generate()], animated: false)
        }
        
        if page == .SelectRPM {
            self.setViewControllers([SelectRPMViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .Centrifuge {
            self.setViewControllers([CentrifugeViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .Ratios {
            self.setViewControllers([TakePictureViewController.generate(delegate: self, next: .Haematocrit)], animated: false)
        }
        
        if page == .LiveCV{
            self.setViewControllers([TakePictureViewController.generate(delegate: self, next: .OpenCV)], animated: false)
        }
        
        if page == .Haematocrit {
            self.setViewControllers([HaematocritViewController.generate(delegate: self)], animated: false)
        }
        
        if page == .OpenCV2 {
            self.pushViewController(BloodShapeStartViewController.generate(delegate: self), animated: true)
//            self.setViewControllers([BloodShapeStartViewController.generate(delegate: self)], animated: false)
        }
        
    }
    
    func setHiddenNavigationBar(hidden: Bool, animated: Bool) {
        self.setNavigationBarHidden(hidden, animated: animated)
    }
    
}