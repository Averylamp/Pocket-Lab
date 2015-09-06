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
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
}
