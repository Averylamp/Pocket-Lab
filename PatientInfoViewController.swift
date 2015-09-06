//
//  PatientInfoViewController.swift
//  Draculapp
//
//  Created by Jake Spracher on 9/6/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

class PatientInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate: Navigation?
    var currentPatient: Patient!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentPatient = sharedSampleDataModel.getLastPatient()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    class func generate(#delegate: Navigation) -> PatientInfoViewController {
        let viewController = PatientInfoViewController(nibName: "PatientInfoViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
    @IBAction func backPressed() {
        delegate?.goToPage(.Options)
    }
    
    // MARK: - TableView DataSource/Delegate Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var reuseIdentifier = "TableViewCell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        switch (indexPath.row) {
        case 0:
            cell!.textLabel!.text = "First Name"
            cell!.detailTextLabel!.text = currentPatient.firstName
            break
        case 1:
            cell!.textLabel!.text = "Last Name"
            cell!.detailTextLabel!.text = currentPatient.lastName
            break
        case 2:
            cell!.textLabel!.text = "Care Provider"
            cell!.detailTextLabel!.text = currentPatient.careProvider
            break
        case 3:
            cell!.textLabel!.text = "Home Address"
            cell!.detailTextLabel!.text = currentPatient.home
            break
        case 4:
            cell!.textLabel!.text = "Phone Number"
            cell!.detailTextLabel!.text = currentPatient.phone
            break
        case 5:
            cell!.textLabel!.text = "Email"
            cell!.detailTextLabel!.text = currentPatient.email
            break
        case 6:
            cell!.textLabel!.text = "Marital Status"
            cell!.detailTextLabel!.text = currentPatient.married
            break
        case 7:
            cell!.textLabel!.text = "Red Blood Cell Count"

        default:
            break
            
        }
        
        return cell!
    }

    
}
