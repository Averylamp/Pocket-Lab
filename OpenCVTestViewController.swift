//
//  OpenCVTestViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 05/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

class OpenCVTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delegate: Navigation?

        
        let scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 6)
        self.view.addSubview(scrollView)
        
        for i in 0...5{
            
            let normalImage = UIImageView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height * CGFloat(i), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
            //        normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
            //        normalImage.image = UIImage(named: "Normal_3")
            normalImage.contentMode = UIViewContentMode.ScaleAspectFit
            scrollView.addSubview(normalImage)
            
            switch i{
            case 0:
                normalImage.image = UIImage(named: "Normal_1")
            case 1:
                normalImage.image = UIImage(named: "Normal_2")
//                normalImage.image = UIImage(named: "SickleCell_2")
            case 2:
                normalImage.image = UIImage(named: "Normal_3")
            case 3:
                normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
            case 4:
                normalImage.image = UIImage(named: "SickleCell_1")
            case 5:
                normalImage.image = UIImage(named: "SickleCell_2")
            default:
                print("Default")
            }
            
//            //      normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
//            normalImage.image = UIImage(named: "Normal_1")
//            Wrapper.processImage(normalImage.image!)
//            normalImage.image = UIImage(named: "Normal_2")
//            Wrapper.processImage(normalImage.image!)
//            normalImage.image = UIImage(named: "Normal_3")
//            Wrapper.processImage(normalImage.image!)
//            normalImage.image = UIImage(named: "Hereditary_elliptocytosis")
//            Wrapper.processImage(normalImage.image!)
//            normalImage.image = UIImage(named: "SickleCell_1")
//            Wrapper.processImage(normalImage.image!)
//            normalImage.image = UIImage(named: "SickleCell_2")
//            Wrapper.processImage(normalImage.image!)
            
            let processedImageRaw = Wrapper.processImage(normalImage.image!)
            
            let processedImage = UIImageView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height * CGFloat(i) + (UIScreen.mainScreen().bounds.height / 2), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2))
            processedImage.image = processedImageRaw
            processedImage.contentMode = UIViewContentMode.ScaleAspectFit
            scrollView.addSubview(processedImage)
            

        }
        
        
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
    
    class func generate() -> OpenCVTestViewController {
        return OpenCVTestViewController(nibName: "OpenCVTestViewController", bundle: NSBundle.mainBundle())
    }
    
}
