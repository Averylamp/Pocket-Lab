//
//  HaematocritViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 05/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

class HaematocritViewController: UIViewController {

    @IBOutlet weak var pic1: UIImageView!
    @IBOutlet weak var pic2: UIImageView!
    var delegate: Navigation?
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 6
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = "#28FDFF".CGColor
        
       // pic1.image = sharedSampleDataModel.ratiosImage
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let results = Wrapper.isolateBlood(sharedSampleDataModel.ratiosImage)
        
        let redBloodCellPercentage = results[2] as! Double
        if redBloodCellPercentage < 36 {
            statusLabel.text = "Your red blood cell count looks a little low.\nPossible indicator of anemia!"
        } else if redBloodCellPercentage > 49 {
            statusLabel.text = "Your plasma looks a little low.\nPossible indicator of low oxygenation issues!"
        } else {
            statusLabel.text = "Your blood levels are within normal ranges.\nYou appear to have a negative haematocrit."
        }
        
        
        pic2.image = results[0] as? UIImage
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
    
    @IBAction func backTapped(sender: AnyObject) {
        delegate?.goToPage(.Options)
    }
    
    class func generate(#delegate: Navigation) -> HaematocritViewController {
        let viewController = HaematocritViewController(nibName: "HaematocritViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }

}

