//
//  FUT16+Bid.swift
//  FUT16
//
//  Created by Konstantin Klitenik on 12/20/15.
//  Copyright © 2015 Kon. All rights reserved.
//

import Foundation
import SwiftyJSON

extension FUT16 {
    func placeBidOnAuction(auctionId: String, amount: UInt, completion: (error: FutError) -> Void) {
        let bidUrl = "trade/\(auctionId)/bid"
        let parameters = ["bid" : amount]
        
        self.requestForPath(bidUrl, withParameters: parameters, encoding: .JSON, methodOverride: "PUT") { (json) -> Void in
            let tradeId = json["auctionInfo"][0]["tradeId"].stringValue
            let funds = json["currencies"][0]["finalFunds"].stringValue
            let fundCurrency = json["currencies"][0]["name"].stringValue
            
            var error = FutError.None
            
            if fundCurrency == "COINS" {
                self.coinFunds = funds
            }
            if tradeId == "" {
                if json["code"] == "461" {    // Reason: "You are not allowed to bid on this trade" 
                    error = .BidNotAllowed
                } else {
                    print(json)
                    error = .PurchaseFailed
                }
            } else {
                print("Purchased \(tradeId) for \(amount) - \(json["auctionInfo"][0]["tradeState"]) (Bal: \(self.coinsBalance))")
            }
            
            completion(error: error)
        }
    }
    
    func searchForAuction(auctionId: String, completion: (JSON) -> Void) {
        let tradeSearchUrl = "trade/status?tradeIds=\(auctionId)"
        
        requestForPath(tradeSearchUrl) { (json) -> Void in
            completion(json)
        }
    }
}