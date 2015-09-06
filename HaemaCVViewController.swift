//
//  HaemaCVViewController.swift
//  Draculapp
//
//  Created by Antonio Marino on 05/09/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import Foundation
import UIKit


class HaemaCVViewController: UIViewController {
    enum ImageDisplayed {
        case Normal
        case Processed
    }
    
    var normalImage:UIImage?
    var processedImage:UIImage?
    var imageView:UIImageView?
    var imageDisplayed: ImageDisplayed = .Processed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        bg.image = UIImage(named: "bg")
        self.view.addSubview(bg)
        
        var delegate: Navigation?
        
        let screenSize = UIScreen.mainScreen().bounds.size
        
        imageView = UIImageView(frame: CGRectMake(0, 70, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
        imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView!)
        
        normalImage = sharedSampleDataModel.ratiosImage
        
        
        imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView!)
        
        
        let results = Wrapper.isolateBloodForSamples(normalImage)
        processedImage = results[0] as? UIImage
        
        let plasmaPercentage = results[1] as! Double
        let redBloodPercentage = results[2] as! Double
        let whiteBloodPercentage = results[3] as! Double
        
        let title = UILabel(frame: CGRectMake(0, 15, screenSize.width, 40))
        title.text = "Image Analysis"
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "Avenir-Medium", size: 30)
        self.view.addSubview(title)
        
        
        let switchButton = UIButton(frame: CGRectMake(screenSize.width / 2 - 60, imageView!.frame.origin.y + imageView!.frame.height, 120, 40))
        switchButton.layer.borderColor = UIColor.blackColor().CGColor
        switchButton.layer.borderWidth = 2
        switchButton.setTitle("See Original", forState: UIControlState.Normal)
        switchButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        switchButton.addTarget(self, action: "switchImage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(switchButton)
        
        
        let backButton = UIButton(frame: CGRectMake(0, 20, 60, 30))
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        backButton.titleLabel?.font =   UIFont(name: "Avenir-Light", size: 20)
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Analyzing the Image";
        hud.detailsLabelText = "Please give us a minute, we are thinking"
        
        let plasma = UILabel(frame: CGRectMake(30, switchButton.frame.origin.y + switchButton.frame.height, self.view.frame.width - 60, 40))
        plasma.text = "Plasma: "
        plasma.font = UIFont(name: "Panton-Regular", size: 30)
        self.view.addSubview(plasma)
        
        let white = UILabel(frame: CGRectMake(30, plasma.frame.origin.y + plasma.frame.height, self.view.frame.width - 60, 40))
        white.text = "Buffy coat: "
        white.font = UIFont(name: "Panton-Regular", size: 30)
        self.view.addSubview(white)
        
        
        let red = UILabel(frame: CGRectMake(30, white.frame.origin.y + white.frame.height, self.view.frame.width - 60, 40))
        red.text = "Erythrocytes: "
        red.font = UIFont(name: "Panton-Regular", size: 30)
        self.view.addSubview(red)
        
        let diagnosis = UILabel(frame: CGRectMake(30, red.frame.origin.y + red.frame.height, self.view.frame.width - 55, 55))
        diagnosis.text = ""
        diagnosis.numberOfLines = 2
        diagnosis.lineBreakMode = NSLineBreakMode.ByWordWrapping
        diagnosis.font = UIFont(name: "Panton-Regular", size: 20)
        self.view.addSubview(diagnosis)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.imageView!.image = self.processedImage
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            plasma.text = String(format:"Plasma: %.1f%%", plasmaPercentage)
            white.text = String(format:"Buffy coat: %.1f%%", whiteBloodPercentage)
            red.text = String(format:"Erythrocytes: %.1f%%", redBloodPercentage)
            
            diagnosis.text = "Analysis: Everything looks normal!"
            if (whiteBloodPercentage > 1.0) {
                diagnosis.text = "Analysis: Elevated buffy coat,\nprobable leukemia"
            } else if (redBloodPercentage < 35) {
                diagnosis.text = "Analysis: Low erythrocytes,\nanemia possible"
            } else if (redBloodPercentage > 65) {
                diagnosis.text = "Analysis: Elevated hematocrit,\npossible polycythemia"
            }
        }
    }
    
    func switchImage(button:UIButton){
        if imageDisplayed  == .Normal{
            button.setTitle("See Original", forState: UIControlState.Normal)
            imageView?.image = processedImage
            imageDisplayed = .Processed
        }else{
            button.setTitle("See Analysis", forState: UIControlState.Normal)
            imageView?.image = normalImage
            imageDisplayed = .Normal
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
        
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
    
    class func generate() -> HaemaCVViewController {
        return HaemaCVViewController(nibName: "HaemaCVViewController", bundle: NSBundle.mainBundle())
    }
    
}