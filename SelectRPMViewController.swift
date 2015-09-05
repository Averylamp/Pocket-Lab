//
//  SelectRPMViewController.swift
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

import UIKit

class SelectRPMViewController: UIViewController {

    @IBOutlet var RPMField: UITextField!
    var delegate: Navigation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    class func generate(#delegate: Navigation) -> SelectRPMViewController {
        let viewController = SelectRPMViewController(nibName: "SelectRPMViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
}
