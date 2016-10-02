//
//  SearchTerm.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 8/10/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData

class SearchTerm: NSManagedObject {
    
    class func termWithTerm(term: String,
                            inManagedObjectContext context: NSManagedObjectContext) -> SearchTerm?
    {
        let request = NSFetchRequest(entityName: "SearchTerm")
        request.predicate = NSPredicate(format: "term = %@", term)
        if let searchTerm = (try? context.executeFetchRequest(request))?.first as? SearchTerm {
            return searchTerm
        } else if let searchTerm = NSEntityDescription.insertNewObjectForEntityForName("SearchTerm",
                                                    inManagedObjectContext: context) as? SearchTerm {
            searchTerm.term = term
            return  searchTerm
        }
        return nil
    }
}
