//
//  Sample.swift
//  Draculapp
//
//  Created by Jake Spracher on 9/5/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

class Sample: NSObject {
    var RPM = 0.0
    var Radius = 0.0
    var RCF = 0.0
    
    init(fromRPM nRPM: Double, nRadius: Double, nRCF: Double) {
        self.RPM = nRPM
        self.Radius = nRadius
        self.RCF = nRCF
    }
    
}

class 