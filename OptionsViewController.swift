//
//  OptionsViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 04/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

enum BackgroundDirection {
    case Up
    case Down
}

class OptionsViewController: UIViewController {

    var animationFlag: BackgroundDirection = .Down
    
    @IBOutlet weak var bgScroll: UIImageView!
    override func viewDidLoad() {
        startAnimation()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func startAnimation () {
        UIView.animateWithDuration(5.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            if self.animationFlag == .Down {
                self.bgScroll.frame.origin.y = -self.bgScroll.image!.size.height + UIScreen.mainScreen().bounds.height
                self.animationFlag = .Up
            } else if self.animationFlag == .Up {
                self.bgScroll.frame.origin.y = 0
                self.animationFlag = .Down
            }
            
        }, completion: { finished in
            self.startAnimation()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
