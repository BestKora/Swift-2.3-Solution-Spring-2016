//
//  TweetM.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 8/10/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class TweetM: NSManagedObject {

    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet,
                                    inManagedObjectContext context: NSManagedObjectContext) -> TweetM?
    {
        let request = NSFetchRequest(entityName: "TweetM")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweetM = (try? context.executeFetchRequest(request))?.first as? TweetM {
            // found this tweet in the database, return it ...
            return tweetM
        } else if let tweetM = NSEntityDescription.insertNewObjectForEntityForName("TweetM",
                                                            inManagedObjectContext: context) as? TweetM {
            // created a new tweet in the database
            // load it up with information from the Twitter.Tweet ...
            tweetM.unique = twitterInfo.id
            tweetM.text   = twitterInfo.text
            tweetM.posted = twitterInfo.created
            return tweetM
        }
        return nil
    }
    
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet,
                                    andSearchTerm term: String,
                                                  inManagedObjectContext context: NSManagedObjectContext) -> TweetM?
    {
        let request = NSFetchRequest(entityName: "TweetM")
        request.predicate = NSPredicate(
            format: "any terms.term contains[c] %@ and unique = %@", term,  twitterInfo.id)
        
        if let tweetM = (try? context.executeFetchRequest(request))?.first as? TweetM {
            // если нашли твит в базе данных, возвращаем его ...
            return tweetM
        } else {
            // получаем твит, получаем терм и добавляем терм в terms для этого твита
            
            if let tweetM = TweetM.tweetWithTwitterInfo(twitterInfo, inManagedObjectContext: context),
                let currentTerm = SearchTerm.termWithTerm(term, inManagedObjectContext: context) {
                
                let terms = tweetM.mutableSetValueForKey("terms")
                terms.addObject(currentTerm)
                
                // добавляем меншены
                Mension.mensionsWithTwitterInfo(twitterInfo, andTweetM:tweetM,
                                                andSearchTerm: term,
                                                inManagedObjectContext: context)
            }
        }
        
        return nil
    }
    
    class func newTweetsWithTwitterInfo(twitterInfo: [Twitter.Tweet],
                                        andSearchTerm term: String,
                                                      inManagedObjectContext context: NSManagedObjectContext)
    {
        let request = NSFetchRequest(entityName: "TweetM")
        let newTweetsId = twitterInfo.map {$0.id}
   
        var newsSet = Set (newTweetsId)
        request.predicate = NSPredicate(
            format: "any terms.term contains[c] %@ and unique IN %@", term, newsSet )
        let results = try? context.executeFetchRequest(request)
        if let tweets =  results as? [TweetM] {
            let uniques = tweets.flatMap({ $0.unique})
            let uniquesSet = Set (uniques)
            
            newsSet.subtractInPlace(uniquesSet)
            print ("кол-во новых элементов \(newsSet.count)")
            for unic in newsSet {
                if let index = twitterInfo.indexOf({$0.id == unic}){
                    // получаем твит, получаем терм и добавляем терм в terms для этого твита
                    
                    if let tweetM = TweetM.tweetWithTwitterInfo(twitterInfo[index], inManagedObjectContext: context),
                        let currentTerm = SearchTerm.termWithTerm(term, inManagedObjectContext: context) {
                        
                        let terms = tweetM.mutableSetValueForKey("terms")
                        terms.addObject(currentTerm)
                        
                        // добавляем меншены
                        Mension.mensionsWithTwitterInfo(twitterInfo[index],  andTweetM:tweetM,
                                                        andSearchTerm: term,
                                                        inManagedObjectContext: context)
                    }
                    
                }
            }
        }
    }
    
      // MARK: Constants
    
    private struct Constants {
        static let TimeToREemoveOldTweets:NSTimeInterval  = 60*60*24*7
          }

    class func removeOldTweets(context: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: "TweetM")
        request.predicate = NSPredicate(
            format: "posted < %@", NSDate(timeIntervalSinceNow:
                                            -Constants.TimeToREemoveOldTweets) )
        
        let results = try? context.executeFetchRequest(request)
        if let tweetMs = results as? [TweetM] {
            for tweetM in tweetMs {
                context.deleteObject(tweetM)
            }
            
        }
    }
    
    override func prepareForDeletion() {
        guard let mensionsM = mensionsTweetM as? Set<Mension> else { return }

        for mension in mensionsM  {
            mension.count = mension.count!.integerValue - 1
            if mension.count == 0 {
                managedObjectContext?.deleteObject(mension)
            }
        }
    }
}
