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
    @IBOutlet var RadiusSlider: UISlider!
    @IBOutlet var RadiusLabel: UILabel!
    
    @IBOutlet var RCFLabel: UILabel!
    
    @IBOutlet var bloodUrineSegment: UISegmentedControl!
    
    
    
    @IBOutlet var startButton: UIButton!
    
    
    var delegate: Navigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.delegate?.setHiddenNavigationBar(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.delegate?.setHiddenNavigationBar(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Select RPM
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        // Blood: 10-15 minutes at 3400 RPM.
        // 1000-1200 RCF
        
        // Urine: On most centrifuges, 400 RCF equals about 1500 to 2000 rpm
        
        // RCF = 1.12 x R (mm) x KRPM x KRPM
        // R: Centrifuge rotor radius (mm) KRPM: Centrifuge speed in thousands
        // Example: If rotor radius is 102mm, speed is 3.4krpm (3400rpm), Then,
        // RCF = 1.12 x 102 x 3.4 x 3.4 = 1320g
        
        
        self.RPMLabel.text = "\(Int(self.RPMSlider.value))";
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl) {
        switch bloodUrineSegment.selectedSegmentIndex {
            case 0:
                    RCFLabel.text = "1000";
            case 1:
                    RCFLabel.text = "Second Segment selected";
            default:
                break;
        }
    }
    
    // MARK: - Navigation

    class func generate(#delegate: Navigation) -> SelectRPMViewController {
        let viewController = SelectRPMViewController(nibName: "SelectRPMViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
}
