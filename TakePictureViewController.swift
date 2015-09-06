//
//  TakePictureViewController.swift
//  Draculapp
//
//  Created by Mark Larah on 05/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class TakePictureViewController: UIViewController {

    let preview = ConfirmImageViewController(nibName: "ConfirmImageViewController", bundle: NSBundle.mainBundle())
    var next: Page?
    
    var placeAboveView: UIImageView?

    var delegate: Navigation?
    var callbackQueue: dispatch_queue_t?
    
    var captureSession: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput?
    
    func setupAVStuff() {
        
        preview.view.frame = UIScreen.mainScreen().bounds
        preview.delegate = self
        
        callbackQueue = dispatch_queue_create("draculapp", nil)
        captureSession = AVCaptureSession()
      
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        input = AVCaptureDeviceInput(device: device!, error: nil)
        captureSession!.addInput(input!)
      
      
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = NSDictionary(objectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey) as [NSObject : AnyObject]
        captureSession?.addOutput(stillImageOutput!)
        
      //  output!.setMetadataObjectsDelegate(self, queue: callbackQueue!)
        //output!.metadataObjectTypes = [AVMetadataObjectTypeQRCode] as [AnyObject]!
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.bounds = UIScreen.mainScreen().bounds
        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
    }
    
    override func viewDidLoad() {
        let touchGesture = UITapGestureRecognizer(target: self, action: "screenTouched")
        view.addGestureRecognizer(touchGesture)

        placeAboveView = UIImageView(image: UIImage(named: "place"))
        placeAboveView!.contentMode = .ScaleAspectFit
        let imageWidth = UIScreen.mainScreen().bounds.width / 1.4
        let buffer = (UIScreen.mainScreen().bounds.width - imageWidth) / 2
        placeAboveView!.frame = CGRect(x: buffer, y: UIScreen.mainScreen().bounds.height - 155, width: imageWidth, height: imageWidth)
        //        view.addSubview(placeAboveView!)

        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func screenTouched () {
        captureNow()
    }
    
    func captureNow () {
        var videoConnection: AVCaptureConnection? = nil
        for connection in stillImageOutput!.connections {
            for port in connection.inputPorts! {
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection as? AVCaptureConnection
                    break;
                }
            }
            if (videoConnection != nil) {
                break;
            }
        }
        println("getting image")
        stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection) { sampleBuffer, error in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
         //   let tempImage = UIImage(data: imageData)!
           // println(tempImage.CIImage)
            //let ciimg = tempImage.CIImage
            let newCIImg = CIImage(data: imageData)
            self.preview.image.image = UIImage(CIImage: newCIImg!, scale: 1.0, orientation: .Right)

            self.presentViewController(self.preview, animated: true, completion: nil)
            //self.presentViewController(image, animated: true, completion: nil)
        }
    }

    override func viewDidAppear(animated: Bool) {
        setupAVStuff()
        captureSession!.startRunning()
        previewLayer?.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
        
        if next == .Haematocrit {
            view.addSubview(placeAboveView!)
        }
        
        if next == .OpenCV {
            preview.doCropping = true
        } else {
            preview.doCropping = false
        }
        
        super.viewDidAppear(animated)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        placeAboveView?.removeFromSuperview()
        super.viewDidDisappear(animated)
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

    class func generate(#delegate: Navigation, next: Page) -> TakePictureViewController {
        let viewController = TakePictureViewController(nibName: "TakePictureViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        viewController.next = next
        return viewController
    }
    
}

extension TakePictureViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}

extension TakePictureViewController: ImageConfirm {
    func imageOk(image: UIImage) {
        
        if next == .Haematocrit {
            sharedSampleDataModel.ratiosImage = image
        }
        
        self.dismissViewControllerAnimated(true) {
            self.delegate?.goToPage(next!)
        }
    }
    func imageRetake() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

}