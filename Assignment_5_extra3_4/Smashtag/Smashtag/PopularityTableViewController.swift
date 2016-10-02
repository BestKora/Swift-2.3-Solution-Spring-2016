//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 8/11/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: CoreDataTableViewController {

    // MARK: Model
    
    var mention: String? { didSet { updateUI() } }
    var moc: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = moc where mention?.characters.count > 0 {
            let request = NSFetchRequest(entityName: "Mension")
            request.predicate = NSPredicate(format: "term.term contains[c] %@ AND count > %@",
                                                                                mention!, "1")
            request.sortDescriptors = [NSSortDescriptor(
                key: "type",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ), NSSortDescriptor(
                    key: "count",
                    ascending: false
                ),NSSortDescriptor(
                    key: "keyword",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "type",
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    private struct Storyboard {
        static let CellIdentifier = "PopularMentionsCell"
        static let SegueToMainTweetTableView = "ToMainTweetTableView"
    }
    
     override func tableView(tableView: UITableView,
                             cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier,
                                                            forIndexPath: indexPath)
        var keyword: String?
        var count: String?
        if let mensionM = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mension {
            mensionM.managedObjectContext?.performBlockAndWait {  // asynchronous
                keyword =  mensionM.keyword
                count =  mensionM.count!.stringValue
            }
            cell.textLabel?.text = keyword
            cell.detailTextLabel?.text = "tweets.count: " + (count ?? "-")
        }
     return cell
     }
    
    // MARK: View Controller Lifecycle

   override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if moc == nil {
            UIManagedDocument.useDocument{ (document) in
                    self.moc =  document.managedObjectContext
            }
        }
    }

    @IBAction private func toRootViewController(sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewControllerAnimated(true)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            if identifier == Storyboard.SegueToMainTweetTableView{
                if let ttvc = segue.destinationViewController as? TweetTableViewController,
                    let cell = sender as? UITableViewCell,
                    var text = cell.textLabel?.text {
                    if text.hasPrefix("@") {text += " OR from:" + text} 
                    ttvc.searchText = text
                }
                
            }
        }
    }

}
