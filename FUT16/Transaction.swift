//
//  Transaction.swift
//  FUT16
//
//  Created by Konstantin Klitenik on 1/2/16.
//  Copyright © 2016 Kon. All rights reserved.
//

import Foundation
import CoreData


class Transaction: NSManagedObject {
    
    class func getTransactions(entityName: String, sinceDate date: NSDate, managedObjectContext: NSManagedObjectContext) -> [Transaction] {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "time >= %@", date)
        
        do {
            let transactions = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Transaction]
            return transactions
        } catch {
            fatalError("Failed \(entityName) fetch!")
        }
    }
    
    class func numTransactions(entityName: String, sinceDate date: NSDate, managedObjectContext: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        fetchRequest.includesSubentities = false
        fetchRequest.resultType = NSFetchRequestResultType.CountResultType
        
        fetchRequest.predicate = NSPredicate(format: "time >= %@", date)
        
        return managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
    }

    class func save(managedObjectContext: NSManagedObjectContext) {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save managed object context")
        }
    }
    
}
