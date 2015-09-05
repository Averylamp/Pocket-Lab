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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pic1.image = UIImage(named: "blood")
        pic2.image = Wrapper.isolateYellow(UIImage(named: "blood"))
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
    
    class func generate(#delegate: Navigation) -> HaematocritViewController {
        let viewController = HaematocritViewController(nibName: "HaematocritViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }

}
