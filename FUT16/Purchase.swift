//
//  Purchase.swift
//  FUT16
//
//  Created by Konstantin Klitenik on 1/2/16.
//  Copyright © 2016 Kon. All rights reserved.
//

import Foundation
import CoreData


class Purchase: Transaction {

    static let entityName = "Purchase"
    
    override var description: String {
        get {
            return "Purchase price: \(price) BIN: \(maxBin) CoinBallance: \(coinBalance)"
        }
    }
    
    class func NewPurchase(price: Int, maxBin: Int, coinBallance: Int, managedObjectContext: NSManagedObjectContext) {
        let purchase = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! Purchase
        
        purchase.time = NSDate().timeIntervalSinceReferenceDate
        purchase.price = Int32(price)
        purchase.maxBin = Int32(maxBin)
        purchase.coinBalance = Int32(coinBallance)
        
        save(managedObjectContext)
    }
    
    class func getPurchasesSinceDate(date: NSDate, managedObjectContext: NSManagedObjectContext) -> [Purchase] {
        
        return getTransactions(entityName, sinceDate: date, managedObjectContext: managedObjectContext) as! [Purchase]
    }
    
}
