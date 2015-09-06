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
    
    private var patients = [Patient]()

    
    var lastMicroscopyImage:UIImage?

    var ratiosImage: UIImage?
    
    func addPatient(newSample: Patient) {
        patients.append(newSample)
    }
    
    func addSample(newSample: Sample) {
        samples.append(newSample)
    }
    
    func getLastSample() -> Sample? {
        return samples.last
    }
    
    func getLastPatient() -> Patient? {
        return patients.last
    }
}

let sharedSampleDataModel = SampleDataModel()