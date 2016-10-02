//
//  RecentsTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/19/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {

    // MARK: Model
    
    var recentSearches: [String] {
        return RecentSearches.searches
    }
    
    // MARK: View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    private struct Storyboard {
        private static let RecentCell = "Recent Cell"
        private static let TweetsSegue = "Show Tweets from Recent"
        private static let PopularSegueIdentifier = "Recent to Popular"
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 }
    
    override func tableView(tableView: UITableView,
                                  numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count}

    
    override func tableView(tableView: UITableView,
             cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RecentCell,
                                          forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }
    
    // Переопределяем поддержку редактирования table view.
    
    override func tableView(tableView: UITableView,
      commitEditingStyle editingStyle: UITableViewCellEditingStyle,
          forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // уничтожаем строку из data source
            
            RecentSearches.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier where identifier == Storyboard.TweetsSegue,
            let cell = sender as? UITableViewCell,
            let ttvc = segue.destinationViewController as? TweetTableViewController
        {
            ttvc.searchText = cell.textLabel?.text
        }
        
    }

   }
