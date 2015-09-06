//
//  OpenCVTestViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 05/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit
enum ImageDisplayed {
    case Normal
    case Processed
}

class OpenCVTestViewController: UIViewController {
    
    var normalImage:UIImage?
    var processedImage:UIImage?
    var imageView:UIImageView?
    var imageDisplayed: ImageDisplayed = .Processed
    var live: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.view.addSubview(bg)
        
        var delegate: Navigation?
        
//        print("\nNormal 1")
//        var image = UIImage(named: "Normal_1")
//        Wrapper.processImage(image!, live: live)
//        print("\nNormal2")
//        image = UIImage(named: "Normal_2")
//        Wrapper.processImage(image!, live: live)
//        print("\nNormal3")
//        image = UIImage(named: "Normal_3")
//        Wrapper.processImage(image!, live: live)
//        print("\nNormal4")
//        image = UIImage(named: "Normal_4")
//        Wrapper.processImage(image!, live: live)
//        print("\nHereditary Elliptocytosis 1")
//        image = UIImage(named: "Hereditary_elliptocytosis")
//        Wrapper.processImage(image!, live: live)
//        print("\nHereditary Elliptocytosis 2")
//        image = UIImage(named: "Hereditary_elliptocytosis2")
//        Wrapper.processImage(image!, live: live)
//        print("\nSickle Cell 1")
//        image = UIImage(named: "SickleCell_1")
//        Wrapper.processImage(image!, live: live)
//        print("\nSickle Cell 2")
//        image = UIImage(named: "SickleCell_2")
//        Wrapper.processImage(image!, live: live)
//        print("\nHemolytic Anemia")
//        image = UIImage(named: "Hemolytic Anemia")
//        Wrapper.processImage(image!, live: live)
//        print("\nHigh RWD")
//        image = UIImage(named: "High RWD")
//        Wrapper.processImage(image!, live: live)

        
        let screenSize = UIScreen.mainScreen().bounds.size
        //        let scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        //        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 6)
        //        self.view.addSubview(scrollView)
        
        imageView = UIImageView(frame: CGRectMake(0, 70, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
        imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView!)
        
        normalImage = sharedSampleDataModel.lastMicroscopyImage
//        normalImage = UIImage(named: "IMG_3258-ed")
        
        imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView!)
        
        
        let results:[AnyObject] = Wrapper.processImage(normalImage, live: sharedSampleDataModel.live!)
        
        processedImage = results[0] as? UIImage
        
        let allGood = results[1] as! Int
        let allBad = results[2] as! Int
        
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
        
        let normality = UILabel(frame: CGRectMake(30, switchButton.frame.origin.y + switchButton.frame.height, self.view.frame.width - 60, 30))
        normality.text = "Normality: "
        normality.font = UIFont(name: "Panton-Regular", size: 22)
        self.view.addSubview(normality)
        
        
        let abnormality = UILabel(frame: CGRectMake(30, normality.frame.origin.y + normality.frame.height, self.view.frame.width - 60, 30))
        abnormality.text = "Abnormality: "
        abnormality.font = UIFont(name: "Panton-Regular", size: 22)
        self.view.addSubview(abnormality)
        
        let percentage = UILabel(frame: CGRectMake(30, abnormality.frame.origin.y + abnormality.frame.height, self.view.frame.width - 60, 30))
        percentage.text = "Percent:  %"
        percentage.font = UIFont(name: "Panton-Regular", size: 22)
        self.view.addSubview(percentage)
        
        
        let diagnosis = UILabel(frame: CGRectMake(30, percentage.frame.origin.y + percentage.frame.height, self.view.frame.width - 90, 60))
        diagnosis.text = "Diagnosis:  "
        diagnosis.numberOfLines = 0
        diagnosis.lineBreakMode = NSLineBreakMode.ByWordWrapping
        diagnosis.font = UIFont(name: "Panton-Regular", size: 18)
        self.view.addSubview(diagnosis)
        
        
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.imageView!.image = self.processedImage
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            normality.text = "Normality: \(allGood)"
            abnormality.text = "Abnormality: \(allBad)"
            let percent = Double(allGood) / Double(allGood + allBad) * 100
            percentage.text = String(format: "Percent:  %.2f%%", percent)
            switch percent{
            case 90.5...100:
                diagnosis.text = "Diagnosis: Everything looks good!!"
            case 88...90.5:
                diagnosis.text = "Diagnosis: Some cells are slightly\n malformed. It could be Sickle Cell"
            case 85.1...87.9:
                diagnosis.text = "Diagnosis: Cell sizes are abnormal.\n It could be Anemia"                
            case 50.1...85:
                diagnosis.text = "Diagnosis: Many cells are abnormal.\n It could be Elliptocytosis"
            case 0...50:
                diagnosis.text = "Diagnosis: Cell shapes are very abnormal.\n It could be RDW"
            default:
                diagnosis.text = "Diagnosis: Something went wrong"
            }
            
        }
        
        
        
        //
        //        for i in 0...5{
        //
        //            let normalImage = UIImageView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height * CGFloat(i), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
        //            //        normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
        //            //        normalImage.image = UIImage(named: "Normal_3")
        //            normalImage.contentMode = UIViewContentMode.ScaleAspectFit
        //            scrollView.addSubview(normalImage)
        //
        //            switch i{
        //            case 0:
        //                normalImage.image = UIImage(named: "Normal_1")
        //            case 1:
        //                normalImage.image = UIImage(named: "Normal_2")
        ////                normalImage.image = UIImage(named: "SickleCell_2")
        //            case 2:
        //                normalImage.image = UIImage(named: "Normal_3")
        //            case 3:
        //                normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
        //            case 4:
        //                normalImage.image = UIImage(named: "SickleCell_1")
        //            case 5:
        //                normalImage.image = UIImage(named: "SickleCell_2")
        //            default:
        //                print("Default")
        //            }
        //
        ////            //      normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
        ////            normalImage.image = UIImage(named: "Normal_1")
        ////            Wrapper.processImage(normalImage.image!)
        ////            normalImage.image = UIImage(named: "Normal_2")
        ////            Wrapper.processImage(normalImage.image!)
        ////            normalImage.image = UIImage(named: "Normal_3")
        ////            Wrapper.processImage(normalImage.image!)
        ////            normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
        ////            Wrapper.processImage(normalImage.image!)
        ////            normalImage.image = UIImage(named: "SickleCell_1")
        ////            Wrapper.processImage(normalImage.image!)
        ////            normalImage.image = UIImage(named: "SickleCell_2")
        ////            Wrapper.processImage(normalImage.image!)
        //
        //            let processedImageRaw = Wrapper.processImage(normalImage.image!)
        //
        //            let processedImage = UIImageView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height * CGFloat(i) + (UIScreen.mainScreen().bounds.height / 2), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
        //            processedImage.image = processedImageRaw
        //            processedImage.contentMode = UIViewContentMode.ScaleAspectFit
        //            scrollView.addSubview(processedImage)
        //
        //
        //        }
        
        
        // Do any additional setup after loading the view.
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
    
    class func generate() -> OpenCVTestViewController {
        return OpenCVTestViewController(nibName: "OpenCVTestViewController", bundle: NSBundle.mainBundle())
    }
    
}
