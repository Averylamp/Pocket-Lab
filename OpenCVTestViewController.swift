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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delegate: Navigation?

        let screenSize = UIScreen.mainScreen().bounds.size
//        let scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
//        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 6)
//        self.view.addSubview(scrollView)
        
        imageView = UIImageView(frame: CGRectMake(0, 70, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
        imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView!)
        
        normalImage = sharedSampleDataModel.lastMicroscopyImage

        
        imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView!)
        
        processedImage = Wrapper.processImage(normalImage)

        imageView!.image = processedImage
        
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
