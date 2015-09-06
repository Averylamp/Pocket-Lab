//
//  ConfirmImageViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 05/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

protocol ImageConfirm {
    func imageOk(image: UIImage)
    func imageRetake()
}

class ConfirmImageViewController: UIViewController {

    var delegate: ImageConfirm?
    var doCropping = false
    
    var croppedImage: UIImage?

    //Dragging
    var dragging = false
    var start: CGPoint? = nil;

    
    
    @IBOutlet weak var retake: UIButton!
    
    @IBOutlet weak var ok: UIButton!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        retake.layer.cornerRadius = 6
        retake.layer.borderWidth = 2
        retake.layer.borderColor = "#28FDFF".CGColor
        ok.layer.cornerRadius = 6
        ok.layer.borderWidth = 2
        ok.layer.borderColor = "#28FDFF".CGColor
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        croppedImage = nil;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
////        dragging = true;
////        let touch: AnyObject? = touches.anyObject();
////        start = touch!.locationInView(self.view)
//    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !doCropping || touches.count != 1 {
            return ;
        }
        let touch: AnyObject? = touches.anyObject();
        start = touch!.locationInView(self.view)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touches.count != 1 {
            return ;
        }
        
        let touch = touches.first as? UITouch
    }

    @IBAction func okay(sender: AnyObject) {

        if !doCropping {
            delegate?.imageOk(image.image!)
            return;
        }
        
        if croppedImage == nil {
            
            ok.setTitle("Crop", forState: .Normal)
        } else {
            // set image somewhere
            delegate?.imageOk(image.image!)
        }
        
    }
    
    @IBAction func retake(sender: AnyObject) {
        delegate?.imageRetake()
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
