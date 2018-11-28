//
//  MessagesViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-09-20.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var imageArray = [String]()
    var secondImageArray = [String]()
    
    var categories = ["Artist", "Project"]
    
    // I need the titles for Artist + Project as table headers
    // And The items within those two in the database filling the collection view rows
    override func viewDidLoad() {
        super.viewDidLoad()

        


        
        imageArray = ["airpods@2x.png", "airpods@2x.png", "airpods@2x.png", "airpods@2x.png"]

        secondImageArray = ["friends@2x.png", "friends@2x.png", "friends@2x.png", "friends@2x.png"]
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return imageArray.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TableViewCellClass
//
//            cell.collectionViewOutlet.reloadData()
//
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID2", for: indexPath) as! SecondTableViewCellClass
//
//            cell.secondCollectionViewOutlet.reloadData()
//
//            return cell
//
//
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TableViewCellClass
        
        return cell
    }

}

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return imageArray.count
    
        if section == 0 {
            return imageArray.count
        } else {
            return secondImageArray.count
        }
        //return (section == 0) ? imageArray.count : secondImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! CollectionViewCellClass
            
            cell.ImageView.image = UIImage(named: imageArray[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid2", for: indexPath) as! SecondCollectionViewCellClass
            
            cell.secondImageView.image = UIImage(named: secondImageArray[indexPath.row])
            return cell
        }
    }
    
}
