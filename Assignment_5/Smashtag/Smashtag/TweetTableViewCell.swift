//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    struct Palette {
        static let hashtagColor = UIColor.purpleColor()
        static let urlColor = UIColor.blueColor()
        static let userColor = UIColor.orangeColor()
    }
    
    private func updateUI()
    {
        // переустанавливаем информацию существующего твита
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // загружаем новую информацию для нашего твита (если он есть)
        if let tweet = self.tweet
        {
            tweetTextLabel?.attributedText  = setTextLabel(tweet)
            tweetScreenNameLabel?.text = "\(tweet.user)"     // tweet.user.description
            setProfileImageView(tweet) // tweetProfileImageView updated asynchronously
            tweetCreatedLabel?.text = setCreatedLabel(tweet)

        }
    }
    
    private func setTextLabel(tweet: Tweet) -> NSMutableAttributedString {
        var tweetText:String = tweet.text
        for _ in tweet.media {tweetText += " 📷"}
        
        let attribText = NSMutableAttributedString(string: tweetText)
        
        attribText.setMensionsColor(tweet.hashtags, color: Palette.hashtagColor)
        attribText.setMensionsColor(tweet.urls, color: Palette.urlColor)
        attribText.setMensionsColor(tweet.userMentions, color: Palette.userColor)
        
        return attribText
    }
    
    private func setCreatedLabel(tweet: Tweet) -> String {
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        return formatter.stringFromDate(tweet.created)
    }
    
    private func setProfileImageView(tweet: Tweet) {
        if let profileImageURL = tweet.user.profileImageURL {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                
                let contentsOfURL = NSData(contentsOfURL: profileImageURL)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if profileImageURL == tweet.user.profileImageURL {
                        if let imageData = contentsOfURL  {
                            self.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Расширение

private extension NSMutableAttributedString {
    func setMensionsColor(mensions: [Mention], color: UIColor) {
        for mension in mensions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mension.nsrange)
        }
    }
}
