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

//        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
//        bg.image = UIImage(named: "backgroundRect")
//        bg.contentMode = UIViewContentMode.ScaleAspectFill
//        self.view.insertSubview(bg, atIndex: 0)
        
        self.view.backgroundColor = UIColor(red: 0.129, green: 0.188, blue: 0.231, alpha: 1.0)
        
        self.currentPatient = sharedSampleDataModel.getLastPatient()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.backgroundColor = UIColor(red: 0.129, green: 0.188, blue: 0.231, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        self.view.backgroundColor = UIColor.blackColor()
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
        return 9
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var reuseIdentifier = "TableViewCell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell?.backgroundColor = UIColor.clearColor()
        
        let container = UIView(frame: CGRectMake(15, 5, tableView.frame.width - 30, 70))
        container.layer.borderColor = UIColor(red: 0.243, green: 0.353, blue: 0.569, alpha: 1.0).CGColor
        container.layer.borderWidth = 2
        container.layer.cornerRadius = 9
        cell?.addSubview(container)
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, container.frame.width, 30))
        titleLabel.font = UIFont(name: "Panton-Regular", size: 18)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        container.addSubview(titleLabel)
        
        let detailLabel = UILabel(frame: CGRectMake(0, 30, container.frame.width, 40))
        detailLabel.font = UIFont(name: "Panton-Semibold", size: 24)
        detailLabel.textColor = UIColor.whiteColor()
        detailLabel.textAlignment = NSTextAlignment.Center
        container.addSubview(detailLabel)
        
        switch (indexPath.row) {
        case 0:
            titleLabel.text = "First Name"
            detailLabel.text = currentPatient.firstName
            break
        case 1:
           titleLabel.text = "Last Name"
            detailLabel.text = currentPatient.lastName
            break
        case 2:
            titleLabel.text = "Care Provider"
            detailLabel.text = currentPatient.careProvider
            break
        case 3:
            titleLabel.text = "Home Address"
            detailLabel.text = currentPatient.home
            break
        case 4:
            titleLabel.text = "Phone Number"
            detailLabel.text = currentPatient.phone
            break
        case 5:
            titleLabel.text = "Email"
            detailLabel.text = currentPatient.email
            break
        case 6:
            titleLabel.text = "Marital Status"
            detailLabel.text = currentPatient.married
            break
        case 7:
            titleLabel.text = "Red Blood Cell Count"
            detailLabel.text = "\(sharedRatios.redBloodCellCount)"
            break
        case 8:
            titleLabel.text = "Plasma Cell Count"
            detailLabel.text = "\(sharedRatios.plasmaCount)"
            break
        default:
            break
            
        }
        
        return cell!
    }

    
}
