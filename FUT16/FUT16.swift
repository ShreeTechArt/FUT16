//
//  FUT16.swift
//  FUT16
//
//  Created by Konstantin Klitenik on 12/15/15.
//  Copyright © 2015 Kon. All rights reserved.
//

import Foundation
import Alamofire

public class FUT16 {
    
    private let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
    private let cookieStoreage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    let alamo: Manager!
    
    var loginUrl: URLStringConvertible!
    let futUrl: URLStringConvertible = "https://utas.s3.fut.ea.com/ut/game/fifa16/"
    
    // supplied by user
    var  phishingQuestionAnswer = ""
    
    var EASW_ID = ""
    var personaName = ""
    var personaId = ""
    
    var sessionId = ""
    var phishingToken = ""
    
    var coinFunds = ""
    
    var isSessionValid = false
    
    var coinsBalance: Int {
        get {
            return Int(coinFunds) ?? -1
        }
    }

    public init() {
        cfg.HTTPCookieStorage = cookieStoreage
        cfg.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        cfg.timeoutIntervalForRequest = 5.0


//        for cookie in cookieStoreage.cookies! {
//            cookieStoreage.deleteCookie(cookie)
//        }

        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36"
        defaultHeaders["Connection"] = "keep-alive"
        defaultHeaders["Host"] = "www.easports.com"
        
        cfg.HTTPAdditionalHeaders = defaultHeaders
        
        alamo = Alamofire.Manager(configuration: cfg)
    }
}

extension FUT16 {
    private func printCookies() {
        guard let cookies = cookieStoreage.cookies else {
            print("Cookies: None")
            return
        }
        
        print("Cookies:")
        
        print(NSHTTPCookie.requestHeaderFieldsWithCookies(cookies))
    }
}