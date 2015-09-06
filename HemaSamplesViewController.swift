//
//  HemaSamplesViewController.swift
//  Draculapp
//
//  Created by Antonio Marino on 05/09/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

class HemaSamplesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var collectionVC: UICollectionViewController! = nil;
    
    var delegate: Navigation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        bg.image = UIImage(named: "bg")
        self.view.addSubview(bg)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.itemSize = CGSizeMake(120, 120)
        layout.headerReferenceSize = CGSizeMake(200,60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
        
        
        collectionVC = UICollectionViewController(collectionViewLayout: layout)
        collectionVC.collectionView  = UICollectionView(frame: CGRectMake(20, 20, 480, UIScreen.mainScreen().bounds.height - 40), collectionViewLayout: layout)
        collectionVC.collectionView?.backgroundColor = UIColor.clearColor()
        collectionVC.collectionView?.frame = CGRectMake(20, 60, self.view.frame.width-40, self.view.frame.height-140)
        //collectionVC.collectionView?.layer.borderColor = UIColor.blackColor().CGColor
        //collectionVC.collectionView?.layer.borderWidth = 1
        collectionVC.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionVC.collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        //        collectionVC.collectionView?.registerClass:UICollectionReusableView.self forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        //        NSLog(@"%f", self.view.frame.size.width);
        //        NSLog(@"%f", self.view.frame.size.height);
        collectionVC.collectionView?.delegate = self;
        collectionVC.collectionView?.dataSource = self;
        self.view.addSubview(self.collectionVC.collectionView!)
        
        
        let title = UILabel()
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        title.text = "Pick a Sample"
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "AppleSDGothicNeo-Light", size: 30)
        self.view.addSubview(title)
        
        self.view.addConstraint(NSLayoutConstraint(item: title, attribute:.Left , relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: title, attribute:.Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10))
        self.view.addConstraint(NSLayoutConstraint(item: title, attribute:.Width , relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: title, attribute:.Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40))
        
        let takeOwn = UIButton(frame: CGRectMake(0, self.view.frame.height - 60, self.view.frame.width, 40))
        takeOwn.frame = CGRectMake(0, self.view.frame.height - 60, self.view.frame.height, 40)
        takeOwn.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        takeOwn.setTitle("Take your own", forState: UIControlState.Normal)
        takeOwn.addTarget(self, action: "takeOwn", forControlEvents: UIControlEvents.TouchUpInside)
        takeOwn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 30)
        takeOwn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(takeOwn)
        self.view.addConstraint(NSLayoutConstraint(item: takeOwn, attribute:.Left , relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: takeOwn, attribute:.Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10))
        self.view.addConstraint(NSLayoutConstraint(item: takeOwn, attribute:.Width , relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: takeOwn, attribute:.Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40))
        
        // Do any additional setup after loading the view.
    }
    override func  viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func takeOwn(){
        delegate?.goToPage(.TakeRatiosPicture)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header: UICollectionReusableView = collectionVC.collectionView!.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! UICollectionReusableView
        
        for v in header.subviews{
            v.removeFromSuperview()
        }
        
        let HeaderLabel = UILabel(frame: CGRectMake(0, 20, header.frame.size.width, 40))
        HeaderLabel.textAlignment = NSTextAlignment.Center
        HeaderLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 26)
        header.addSubview(HeaderLabel)
        
        switch indexPath.section{
        case 0:
            HeaderLabel.text = "Normal"
        case 1:
            HeaderLabel.text = "Leukemia"
        default:
            print("Default")
        }
        return header
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionVC.collectionView!.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        let imgV = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height - 20))
        imgV.contentMode = UIViewContentMode.ScaleAspectFill
        imgV.clipsToBounds = true
        cell.addSubview(imgV)
        
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                imgV.image = UIImage(named: "sample2")
            default:
                print("default")
            }
        case 1:
            switch indexPath.row{
            case 0:
                imgV.image = UIImage(named: "sample")
            case 1:
                imgV.image = UIImage(named: "sample5")
            default:
                print("default")
            }
        default:
            print("Default")
        }
        
        
        //        UICollectionViewCell *cell = [self.collectionVC.collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
        
        //
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var image = UIImage()
        
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                image = UIImage(named: "sample2")!
            default:
                print("default")
            }
        case 1:
            switch indexPath.row{
            case 0:
                image = UIImage(named: "sample")!
            case 1:
                image = UIImage(named: "sample5")!
            default:
                print("default")
            }
        default:
            print("Default")
        }
        
        sharedSampleDataModel.ratiosImage = image
        
        delegate?.goToPage(.HaemaCV)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    class func generate(#delegate: Navigation) -> HemaSamplesViewController {
        let viewController = HemaSamplesViewController(nibName: "HemaSamplesViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
}