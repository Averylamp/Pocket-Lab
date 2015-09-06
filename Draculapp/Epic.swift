//
//  Epic.swift
//  Draculapp
//
//  Created by Mark Larah on 05/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import SwiftyJSON

class Epic {
    
    let baseurl = "https://open-ic.epic.com/FHIR/api/FHIR/DSTU2/"
    
    func getPatientInfo(#name: String, callback: (NSError?, JSON?)->()) {
        
        let components = name.componentsSeparatedByString(" ")
        
        var first = components[0]
        var last = ""
    
        if count(components) >= 1 {
            last = components[1]
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(baseurl)/Patient?family=\(last)&given=\(first)")!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET" // overwrite http method
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            
            if let error = error {
                callback(error, nil)
            } else {
                let json = JSON(data: data)
                callback(nil, json)
            }
            
        }
        

    }
    
}

let sharedEpic = Epic()