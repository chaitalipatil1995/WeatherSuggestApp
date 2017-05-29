//
//  MenuViewController.swift
//  WeatherApp
//
//  Created by Amesten Systems on 29/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    var menuArray : NSArray = []
    
    
   
    
    @IBOutlet var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        menuArray = ["Weather", "Next Days Weather"]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        cell.menuTitleLabel.text = menuArray[indexPath.row] as? String
        
        // Configure the cell...
       // if (indexPath as NSIndexPath).row == 0 {
            //cell.postImageView.image = UIImage(named: "watchkit-intro")
            //cell.postTitleLabel.text = "WatchKit Introduction: Building a Simple Guess Game"
            //cell.authorLabel.text = "Simon Ng"
            //cell.authorImageView.image = UIImage(named: "author")
            
        //} else if (indexPath as NSIndexPath).row == 1 {
        //}
    
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
