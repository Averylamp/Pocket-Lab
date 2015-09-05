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
        let normalImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height / 2))
        normalImage.image = UIImage(named: "blood-cells-200x-1")
        normalImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(normalImage)

        let processedImageRaw = Wrapper.processImage(normalImage.image!)
        
        let processedImage = UIImageView(frame: CGRectMake(0, self.view.frame.height / 2, self.view.frame.width, self.view.frame.height / 2))
        processedImage.image = processedImageRaw
        processedImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(processedImage)
        

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

}
