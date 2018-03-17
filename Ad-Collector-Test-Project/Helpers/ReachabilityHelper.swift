//
//  ReachabilityHelper.swift
//  Test Project
//
//  Created by Trevin Wisaksana on 6/24/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Reachability

public protocol NetworkStatusListener: class {
    // Monitors state changes of the network.
    func networkStatusDidChange(status: Reachability.Connection)
}

final class ReachabilityHelper {
    
    private let reachability = Reachability()
    private var listeners: [NetworkStatusListener] = []

    func add(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    // Removes a listener from listeners array
    func remove(listener: NetworkStatusListener) {
        listeners = listeners.filter{ $0 !== listener }
    }
    
    // Called whenever there is a change in NetworkReachibility Status
    @objc private func reachabilityChanged(_ notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .none:
            break
        case .cellular:
            break
        case .wifi:
            break
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    // Starts monitoring the network availability status
    public func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        
        do {
            try reachability?.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    // Stops monitoring the network availability status
    public func stopMonitoring() {
        reachability?.stopNotifier()

        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
}

extension ReachabilityHelper {
    
    class func isConnectedToNetwork() -> Bool {
        
        var status: Bool = false
        
        guard let url = URL(string: "http://google.com/") else {
            fatalError("URL not found.")
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        
        do {
            try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        } catch {
            debugPrint("Not connected")
        }
    
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        
        return status
    }
}
