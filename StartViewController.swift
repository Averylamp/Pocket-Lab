//
//  StartViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 04/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit
import QuartzCore

class StartViewController: UIViewController {

    @IBOutlet weak var fadeInView: UIView!
    @IBOutlet weak var begin: UIButton!
    @IBOutlet weak var drop: UIImageView!
    
    var delegate: Navigation?
    
    var bloodOverlay: UIView!
    
    override func viewDidLoad() {
        bloodOverlay = UIView(frame: UIScreen.mainScreen().bounds)
        bloodOverlay.frame.origin.y = UIScreen.mainScreen().bounds.height
        bloodOverlay.backgroundColor = "#F44336".UIColor
        view.addSubview(bloodOverlay)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fadeInView.alpha = 0
        for fadeSubview in self.fadeInView.subviews {
            (fadeSubview as! UIView).alpha = 0
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {

        begin.layer.cornerRadius = 6
        begin.layer.borderWidth = 1
        begin.layer.borderColor = "#28FDFF".CGColor
        
        UIView.animateWithDuration(1.5, animations: {
            self.fadeInView.alpha = 1
            for fadeSubview in self.fadeInView.subviews {
                (fadeSubview as! UIView).alpha = 1
            }
        })

        UIView.animateWithDuration(1.5, animations: {
            self.fadeInView.alpha = 1
            for fadeSubview in self.fadeInView.subviews {
                (fadeSubview as! UIView).alpha = 1
            }
        })
        
        UIView.animateWithDuration(1.5, delay: 1.5, options: nil, animations: {
            self.begin.alpha = 1
        }, completion: nil)
        
        
        super.viewDidAppear(animated)
    }
    

    @IBAction func beginTouched(sender: AnyObject) {
        
        UIView.animateWithDuration(1.2, delay: 0, options: .CurveEaseIn , animations: {
            self.drop.frame.origin.y = UIScreen.mainScreen().bounds.height
        }, completion: nil)

        UIView.animateWithDuration(1.0, delay: 1.2, options: .CurveEaseOut , animations: {
            self.bloodOverlay.frame.origin.y = 0
        }, completion: { finished in
            self.delegate?.goToPage(.Options)
        })
        
    }
    
    class func generate(#delegate: Navigation) -> StartViewController {
        let viewController = StartViewController(nibName: "StartViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }

}
