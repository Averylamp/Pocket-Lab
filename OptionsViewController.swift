//
//  OptionsViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 04/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit
import QuartzCore

enum BackgroundDirection {
    case Up
    case Down
    case Stop
}

class OptionsViewController: UIViewController {

    var animationFlag: BackgroundDirection = .Down
    @IBOutlet weak var spinButton: UIView!
    @IBOutlet weak var microscopy: UIView!
    var delegate: Navigation?

    
    @IBOutlet weak var bgScroll: UIImageView!
    override func viewDidLoad() {
        
        
        setButtonStyle(spinButton)
        setButtonStyle(microscopy)
        
        self.bgScroll.frame.origin.y = -self.bgScroll.image!.size.height + UIScreen.mainScreen().bounds.height
        startAnimation()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setButtonStyle(button: UIView) {
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 2
        button.layer.borderColor = "#FFFFFF".CGColor
        
        for sbSubview in spinButton.subviews.filter({ $0 is UIImageView }) {
            (sbSubview as! UIImageView).image = (sbSubview as! UIImageView).image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            (sbSubview as! UIImageView).tintColor = UIColor.whiteColor()
        }
    }

    func startAnimation () {
        UIView.animateWithDuration(5.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {

            [weak self] in
            
            
            if let strongSelf = self {
                if strongSelf.animationFlag == .Down {
                    strongSelf.bgScroll.frame.origin.y = -strongSelf.bgScroll.image!.size.height + UIScreen.mainScreen().bounds.height
                    strongSelf.animationFlag = .Up
                } else if strongSelf.animationFlag == .Up {
                    strongSelf.bgScroll.frame.origin.y = 0
                    strongSelf.animationFlag = .Down
                }
            }
            
        }, completion: { [weak self] finished in
            if self?.animationFlag != .Stop {
                self?.startAnimation()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func opencvpush(sender: AnyObject) {
        delegate?.goToPage(.OpenCV2)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.animationFlag = .Stop
        super.viewWillDisappear(animated)
    }
    
    class func generate(#delegate: Navigation) -> OptionsViewController {
        let viewController = OptionsViewController(nibName: "OptionsViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }

}
