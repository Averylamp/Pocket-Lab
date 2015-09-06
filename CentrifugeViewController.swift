//
//  CentrifugeViewController.swift
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

import UIKit
import CoreMotion

class CentrifugeViewController: UIViewController, StopWatchDelegate {
    
    var delegate: Navigation?
    
    @IBOutlet var RPMLabel: UILabel!
    var desiredRPM: Double!
    var rpmCircle: CAShapeLayer!
    let motionManager: CMMotionManager = CMMotionManager()
    
    var trackingIntialized = false
    var prevZ: Double = 0
    var direction :String = "NONE"
    var avgRPM = 0.0 // Exponential moving average of centrifuge RPM
    var EMA_Alpha = 0.33 // % significance of current sample compared to all past samples
    var dirChangeThresh = 0.08 // force in G's needed to indicate the phone has changed direction
    
    var timer = StopWatch()
    
    @IBOutlet var timeLabel: UILabel!
    var totalElapsedTime = 0.0
    var elapsedSeconds = 0
    var initTime: Double!
    
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
        
        self.timer.startTimer()
        timer.delegate = self
        self.startAccelerometerPollingWithInterval(0.008)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let screenSize: CGRect = self.view.bounds
        var newPoint = CGPoint(x: screenSize.width/2 - 35, y: screenSize.height/2)
        self.rpmCircle.position = newPoint
    }
    
    override func viewDidAppear(animated: Bool) {
                    self.timer.startTimer()
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
    
    @IBAction func backPressed() {
        delegate?.goToPage(.SelectRPM)
    }
    
    @IBAction func donePressed() {
        delegate?.goToPage(.Options)
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
        var cycleTime = self.timer.getTimeandReset()
        totalElapsedTime = (CFAbsoluteTimeGetCurrent() - initTime)
        
        if avgRPM == 0.0 {
            avgRPM = 1 / (cycleTime * 2)
        } else {
            avgRPM = 1 / ((self.EMA_Alpha * cycleTime * 2) + (1.0 - EMA_Alpha) * (1 / (avgRPM/60))) // exponential moving average
        }
        
        avgRPM = 60 * avgRPM // convert cyc/sec -> RPM

        if avgRPM <= 10 {
            avgRPM = 10
        } else if avgRPM >= 2 * (desiredRPM - 100) {
            avgRPM = 2 * (desiredRPM - 100)
        }
        
        // Scale from (desired RPM +/- 300) -> +/- (screen height / 2) :
        // OldRange = (OldMax - OldMin)
        // NewRange = (NewMax - NewMin)
        // NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin
        
        let screenSize: CGRect = self.view.bounds
        var screenRange = Double(screenSize.height)
        var rpmRange = desiredRPM * 2
        var rpmBallPosition = (((self.avgRPM) * screenRange) / rpmRange) - 25
        
        var newframe = CGFloat(rpmBallPosition)
        
        if(avgRPM > 80 ) { // Move the ball
            dispatch_async(dispatch_get_main_queue(),{
                if !self.trackingIntialized {
                    self.trackingIntialized = true
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            
            if newframe > screenSize.height - 50 {
                newframe = screenSize.height - 50
            } else if newframe < 25 {
                newframe = 25
            } else {
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.65)
                var newPoint = CGPoint(x: screenSize.width/2 - 35, y: newframe )
                
                rpmCircle.position = newPoint
                
                CATransaction.commit()
                
            }
            
        } else { // hold the ball in place while calibrating
            var rpmframe = self.rpmCircle.frame
            var newframe = CGFloat(screenRange) / 2 - 40
            rpmframe.origin.y = newframe
            
        }

        println("\(totalElapsedTime), \(avgRPM), \(direction), \(newframe)") // print data in csv format
        
    }
    
    // MARK: StopWatchDelegate Methods
    func secondElapsed() {
        elapsedSeconds++
        var preMinutes = (elapsedSeconds / 60) / 10 > 0 ? "" : "0"
        var preSeconds = (elapsedSeconds % 60) / 10 > 0 ? "" : "0"
        self.timeLabel.text = preMinutes + "\( elapsedSeconds / 60 ):" + preSeconds + "\( elapsedSeconds % 60 )"
        
        var printRPM = avgRPM - 100
        
        if printRPM <= 10 {
            printRPM = 10
        } else if printRPM >= 2 * (desiredRPM - 100) {
            printRPM = 2 * (desiredRPM - 100)
        }
        
        self.RPMLabel.text = "\(Int(printRPM)) RPM"
    }
    

}
