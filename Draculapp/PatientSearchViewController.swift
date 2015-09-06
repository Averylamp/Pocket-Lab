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
                let patient = data["entry"][0]["resource"]["Patient"]
                
                var newPatient = Patient()
                
                newPatient.firstName = patient["name"][0]["given"][0].string
                newPatient.lastName = patient["name"][0]["family"][0].string
                newPatient.careProvider = patient["careProvider"][0]["display"].string
                newPatient.home = patient["address"][0]["line"][0].string
                newPatient.phone = patient["telecom"][0]["value"].string
                newPatient.email = patient["telecom"][2]["value"].string
                newPatient.married = patient["maritalStatus"]["text"].string
                
                sharedSampleDataModel.addPatient(newPatient)
                
                dispatch_async(dispatch_get_main_queue(),{
                    delegate?.goToPage(.PatientInfo)
                })
                
            }
        })
        
    }
    
    // MARK: - Navigation

    @IBAction func backPressed() {
        delegate?.goToPage(.Options)
    }
    
    class func generate(#delegate: Navigation) -> PatientSearchViewController {
        let viewController = PatientSearchViewController(nibName: "PatientSearchViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }

}
