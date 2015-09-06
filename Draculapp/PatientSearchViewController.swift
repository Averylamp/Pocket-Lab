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
                println(patient["name"][0]["family"][0].string)
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
