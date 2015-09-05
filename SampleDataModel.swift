//
//  SampleDataModel.swift
//  Draculapp
//
//  Created by Jake Spracher on 9/5/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

class SampleDataModel: NSObject {
    private var samples = [Sample]()
   

    var lastMicroscopyImage:UIImage?

    var ratiosImage: UIImage?
    
    func addSample(newSample: Sample) {
        samples.append(newSample)
    }
    
    func getLastSample() -> Sample? {
        return samples.last
    }
    
    
}

let sharedSampleDataModel = SampleDataModel()