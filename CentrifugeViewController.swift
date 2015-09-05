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
    var EMA_Alpha = 0.25 // % significance of current sample compared to all past samples
    var dirChangeThresh = 0.09 // force in G's needed to indicate the phone has changed direction
    
    var timer = StopWatch()
    var totalElapsedTime = 0.0
    var initTime: Double!
    
    var rpmBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        desiredRPM = sharedSampleDataModel.getLastSample()?.RPM
        if desiredRPM != nil { desiredRPM! += 100.0 } // constant correction factor
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.rpmBar = UIView(frame: CGRect(x: screenSize.width/2 - 40, y: screenSize.height/2 - 40, width: 80, height: 80))
        rpmBar.layer.cornerRadius = 35
        rpmBar.layer.backgroundColor = UIColor.whiteColor().CGColor
        
        self.view.addSubview(rpmBar)
        
        trackingIntialized = false
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Begin Spinning, Averaging RPM Data";
        self.startAccelerometerPollingWithInterval(0.05)
        
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
            if direction == "Start" {
                self.directionChanged()
            }
            direction = "DOWN";
        }
        else if (zChange < -1 * dirChangeThresh){
            if direction == "." {
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
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var screenRange = Double(screenSize.height) - 50
        var rpmRange = ((self.desiredRPM + 300) - (self.desiredRPM - 300))
        var rpmBallPosition = (((self.avgRPM - (self.desiredRPM - 300)) * screenRange) / rpmRange) - screenRange / 2
        
        // Move the ball
        if(avgRPM > 80 ) {
            dispatch_async(dispatch_get_main_queue(),{
                
                if !self.trackingIntialized {
                    self.trackingIntialized = true
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
                    // position.y = center + (targetRPM - currentRPM)
                    var rpmframe = self.rpmBar.frame
                    var newframe = CGFloat(screenRange) / 2 + CGFloat(rpmBallPosition)
                    if newframe > screenSize.height {
                        newframe = screenSize.height - 50
                    } else if newframe < 0 {
                        newframe = 50
                    }
                    
                    rpmframe.origin.y = newframe
                    
                    self.rpmBar.frame = rpmframe
                    }, completion: { finished in
                })
            })
        } else {
            var rpmframe = self.rpmBar.frame
            var newframe = CGFloat(screenRange) / 2 - 40
            rpmframe.origin.y = newframe
            
            self.rpmBar.frame = rpmframe
        }


        println("\(totalElapsedTime), \(avgRPM), \(direction)") // print data in csv format
        
    }

}
