//
//  CentrifugeViewController.swift
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

import UIKit
import CoreMotion

class CentrifugeViewController: UIViewController {
    
    var delegate: Navigation?
    var desiredRPM: Double!
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    var trackingIntialized = false
    var prevZ: Double = 0
    var direction :String = "NONE"
    var avgRPM = 0.0 // Exponential moving average of centrifuge RPM
    var EMA_Alpha = 0.33 // % significance of current sample compared to all past samples
    var dirChangeThresh = 0.08 // force in G's needed to indicate the phone has changed direction
    
    var timer = StopWatch()
    var totalElapsedTime = 0.0
    var initTime: Double!

    var rpmCircle: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        desiredRPM = sharedSampleDataModel.getLastSample()?.RPM
        if desiredRPM != nil { desiredRPM! += 100.0 } // constant correction factor
        
        // Adding layer
        let screenSize: CGRect = self.view.bounds
        self.rpmCircle = CAShapeLayer()
        let radius = CGFloat(35)
        rpmCircle.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)  , cornerRadius: radius).CGPath
        rpmCircle.position = CGPoint(x: 0, y: 0)
        rpmCircle.fillColor = UIColor.whiteColor().CGColor
        
        self.view.layer.addSublayer(rpmCircle)
        
        trackingIntialized = false
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Begin Spinning Now";
        hud.detailsLabelText = "Averaging accerometer data"
        
        self.startAccelerometerPollingWithInterval(0.008)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    
    class func generate(#delegate: Navigation) -> CentrifugeViewController {
        let viewController = CentrifugeViewController(nibName: "CentrifugeViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
    // MARK: - Accelerometer Shenanigans

    func startAccelerometerPollingWithInterval(interval: Double)  {
        
        println("Seconds Elapsed, Average Frequency, Direction Change")
        
        initTime = CFAbsoluteTimeGetCurrent()
        
        self.motionManager.accelerometerUpdateInterval = interval
        var queue = NSOperationQueue()
        
        if (self.motionManager.accelerometerAvailable) {
            self.motionManager.startAccelerometerUpdatesToQueue(queue) {
                (data, error) in
                
                self.onSensorChanged(data)
            }
        } else {
            print("not active")
        }

    }
    
    func onSensorChanged(event: CMAccelerometerData ) {
    
        var zChange = prevZ - event.acceleration.z
        
        self.prevZ = event.acceleration.z
        
        if (zChange > dirChangeThresh){
            if direction == "UP" {
                self.directionChanged()
            }
            direction = "DOWN";
        }
        else if (zChange < -1 * dirChangeThresh){
            if direction == "DOWN" {
                self.directionChanged()
            }
            direction = "UP"
        }
    }
    
    func directionChanged() {
        // update the elapsed time
        var cycleTime = self.timer.getTimeSinceStart()
        totalElapsedTime = (CFAbsoluteTimeGetCurrent() - initTime)
        
        if avgRPM == 0.0 {
            avgRPM = 1 / (cycleTime * 2)
            self.timer.startTimer()
        } else {
            avgRPM = 1 / ((self.EMA_Alpha * cycleTime * 2) + (1.0 - EMA_Alpha) * (1 / (avgRPM/60))) // exponential moving average
            self.timer.startTimer()
        }
        
        avgRPM = 60 * avgRPM // convert cyc/sec -> RPM

        // Scale from (desired RPM +/- 300) -> +/- (screen height / 2) :
        // OldRange = (OldMax - OldMin)
        // NewRange = (NewMax - NewMin)
        // NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin
        
        let screenSize: CGRect = self.view.bounds
        var screenRange = Double(screenSize.height) - 50
        var rpmRange = 600.0
        var rpmBallPosition = (((self.avgRPM - (self.desiredRPM - 300)) * screenRange) / rpmRange)
        var newframe = CGFloat(rpmBallPosition)
        // Move the ball
        if(avgRPM > 80 ) {
            dispatch_async(dispatch_get_main_queue(),{
                if !self.trackingIntialized {
                    self.trackingIntialized = true
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            
            if newframe > screenSize.height {
                newframe = screenSize.height - 50
            } else if newframe < 0 {
                newframe = 50
            } else {
                
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.6)
                var newPoint = CGPoint(x: screenSize.width/2, y: newframe)
                
                rpmCircle.position = newPoint
                
                CATransaction.commit()
                
            }
            
            
        } else {
            var rpmframe = self.rpmCircle.frame
            var newframe = CGFloat(screenRange) / 2 - 40
            rpmframe.origin.y = newframe
            
            //self.rpmBar.frame = rpmframe
        }

        println("\(totalElapsedTime), \(avgRPM), \(direction), \(newframe)") // print data in csv format
        
    }

}
