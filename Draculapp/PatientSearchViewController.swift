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
                newPatient.lastName = patient["name"][0]["usual"][0].string
                newPatient.careProvider = patient["name"][0]["careProvider"][0].string
                newPatient.home = patient["name"][0]["home"][0].string
                newPatient.phone = patient["name"][0]["phone"][0].string
                newPatient.email = patient["name"][0]["email"][0].string
                newPatient.married = patient["name"][0]["married"][0].string
                
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
