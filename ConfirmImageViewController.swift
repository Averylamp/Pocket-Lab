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
    var cropRect: CGRect?
    
    var croppedImage: UIImage?

    //Dragging
    var dragging = false
    var start: CGPoint? = nil;
    var path = UIBezierPath()
    var shape = CAShapeLayer()
    
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
        println("TOUCHES BEGAN")
        if !doCropping || touches.count != 1 {
            return ;
        }
        //let touch: AnyObject? = touches.anyObject();
        //start = touch!.locationInView(self.view)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touches.count != 1 {
            return ;
        }
        
        let touch = touches.first as? UITouch
        let end = touch!.locationInView(view)
        path.removeAllPoints()

        println("moving")
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).CGColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).CGColor
        
        
        path.moveToPoint(start!)
        var dx = end.x - start!.x;
        var dy = end.y - start!.y;
        path.addLineToPoint(CGPoint(x: start!.x + dx, y: start!.y))
        path.addLineToPoint(CGPoint(x: start!.x + dx, y: start!.y + dy))
        path.addLineToPoint(CGPoint(x: start!.x, y: start!.y + dy))
        path.closePath()
        shape.path = path.CGPath
        image.layer.addSublayer(shape)
        
      
        
        dragging = false
        
        let startX = min(end.x, start!.x)
        let startY = min(end.y, start!.y)
        
        cropRect = CGRect(origin: CGPoint(x: startX, y: startY), size: CGSize(width: abs(dx), height: abs(dy)))
   
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {

        
       // start = nil
        //shape.path = nil;
        //image.layer.addSublayer(shape)
    }

    @IBAction func okay(sender: AnyObject) {

        if !doCropping {
            delegate?.imageOk(image.image!)
            return;
        }
        
        if cropRect == nil {
            ok.setTitle("Crop!!", forState: .Normal)
        } else {
            let cropping = CGImageCreateWithImageInRect(image.image?.CGImage, cropRect!)
            cropRect.ima
            image.image = UIImage(CGImage: cropping)
            // set image somewhere
//            delegate?.imageOk(image.image!)
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
