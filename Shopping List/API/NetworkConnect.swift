//
//  NetworkConnect.swift
//  Shopping List
//
//  Created by Matheus Falcão on 28/05/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import Foundation

class NetworkConnect {
    
    static let sharedInstance = NetworkConnect()
    
    private init() {
    }
    
    func connected() -> Bool {
        var reachability : Reachability = Reachability.reachabilityForInternetConnection()
        var networkStatus : NetworkStatus = reachability.currentReachabilityStatus()
        if networkStatus.value == NotReachable.value  {
            return false
        } else {
            return true
        }
    }
    
    
    
}
