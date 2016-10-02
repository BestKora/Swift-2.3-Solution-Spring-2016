//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/6/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import SafariServices

class MentionsTableViewController: UITableViewController {

    // MARK: - Public API

    var tweet: Twitter.Tweet? {
        
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media  where media.count > 0 {
                mentionSections.append(MentionSection(type: "Images",
                    mentions: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls  where urls.count > 0 {
                mentionSections.append(MentionSection(type: "URLs",
                    mentions: urls.map { MentionItem.Keyword($0.keyword) }))
            }
            if let hashtags = tweet?.hashtags where hashtags.count > 0 {
                mentionSections.append(MentionSection(type: "Hashtags",
                    mentions: hashtags.map { MentionItem.Keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions {
                var userItems = [MentionItem]()
        //------- Extra Credit 1 -------------
                if let screenName = tweet?.user.screenName {
                    userItems += [MentionItem.Keyword("@" + screenName)]
                }
        //------------------------------------------------
                if users.count > 0 {
                    userItems += users.map { MentionItem.Keyword($0.keyword) }
                }
                if userItems.count > 0 {
                    mentionSections.append(MentionSection(type: "Users", mentions: userItems))
                }
            }
        }
    }
    
    // MARK: - Внутренняя структура данных
    
    private var mentionSections: [MentionSection] = []
    
    private struct MentionSection: CustomStringConvertible
    {
        var type: String
        var mentions: [MentionItem]
        var description: String { return "\(type): \(mentions)" }
    }
    
    private enum MentionItem: CustomStringConvertible
    {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path ?? ""
            }
        }
    }
    
    // MARK: - UITableViewControllerDataSource
    
    private struct Storyboard {
        static let KeywordCell = "Keyword Cell"
        static let ImageCell = "Image Cell"
        
        static let KeywordSegue = "From Keyword"
        static let ImageSegue = "Show Image"
        static let WebSegue = "Show URL"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentionSections.count
    }
    
    override func tableView(tableView: UITableView,
                                  numberOfRowsInSection section: Int) -> Int {
        return mentionSections[section].mentions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
                                  indexPath: NSIndexPath) -> UITableViewCell {
        
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordCell,
                                                                 forIndexPath: indexPath)
            cell.textLabel?.text = keyword
            return cell
            
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCell,
                                                               forIndexPath: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
              imageCell.imageUrl = url
            }
             return cell
        }
    }
    
    override func tableView(tableView: UITableView,
                      heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                            
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView,
                                  titleForHeaderInSection section: Int) -> String? {
        return mentionSections[section].type
    }
    
    
    // MARK: - Navitation
    
    @IBAction private func toRootViewController(sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?,
                                                   sender: AnyObject?) -> Bool {
        if identifier == Storyboard.KeywordSegue {
            if let cell = sender as? UITableViewCell,
               let indexPath =  tableView.indexPathForCell(cell)
                         where mentionSections[indexPath.section].type == "URLs" {
                /*    if let urlString = cell.textLabel?.text,
                         let url = NSURL(string:urlString) {
                             let safariVC = SFSafariViewController(URL: url)
                             presentViewController(safariVC, animated: true, completion: nil)
                } */
                performSegueWithIdentifier(Storyboard.WebSegue, sender: sender)
                return false
            }
        }
        return true
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            if identifier == Storyboard.KeywordSegue {
                if let ttvc = segue.destinationViewController as? TweetTableViewController,
                   let cell = sender as? UITableViewCell,
                   var text = cell.textLabel?.text {
                    if text.hasPrefix("@") {text += " OR from:" + text} //  Extra Credit 2
                    ttvc.searchText = text
                }
                
            } else if identifier == Storyboard.ImageSegue {
                if let ivc = segue.destinationViewController as? ImageViewController,
                    let cell = sender as? ImageTableViewCell {
                    
                    ivc.imageURL = cell.imageUrl
                    ivc.title = title
                    
                }
            }else if identifier == Storyboard.WebSegue {
                if let wvc = segue.destinationViewController as? WebViewController {
                    if let cell = sender as? UITableViewCell {
                        if let url = cell.textLabel?.text {
                            
                            wvc.URL = NSURL(string: url)
                        }
                    }
                }
            }

        }
    }
    
}
