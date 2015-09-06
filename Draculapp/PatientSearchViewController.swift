//
//  PatientSearchViewController.swift
//  
//
//  Created by Jake Spracher on 9/5/15.
//
//

import UIKit
import SwiftyJSON

class PatientSearchViewController: UIViewController {

    var delegate: Navigation?
    
    @IBOutlet var idField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func patientSearch() {
        sharedEpic.getPatientInfo(name: idField.text, callback: { error, data in
            if let data = data {
                println(data)
            }
        })
        
    }
    
    // MARK: - Navigation

    @IBAction func backPressed() {
        delegate?.goToPage(.Options)
    }

}
