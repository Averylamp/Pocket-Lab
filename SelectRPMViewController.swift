//
//  SelectRPMViewController.swift
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

import UIKit

class SelectRPMViewController: UIViewController {

    @IBOutlet var RPMSlider: UISlider!
    @IBOutlet var RPMLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func generate(#delegate: Navigation) -> SelectRPMViewController {
        let viewController = SelectRPMViewController(nibName: "SelectRPMViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
}
