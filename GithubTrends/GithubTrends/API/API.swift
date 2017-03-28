//
//  API.swift
//  GithubTrends
//
//  Created by Sufyan on 23/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit

protocol APIProtocol {
    func recievedData(data: AnyObject)
}

class API: NSObject {
    var delegate : APIProtocol?
    var urlString : String = "https://api.github.com/search/repositories?q=css&sort=stars&order=desc"
    
    // MARK: Init With delegate
    
    init(withDelegate delegate: APIProtocol) {
        self.delegate = delegate
    }
    
    // MARK: Fetch JSON data from Server
    
    func fetchJSONData() {
        let url = NSURL(string: self.urlString)
        let request = NSURLRequest( URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                self.sendDataToDelegate(NSData())
            }
            else {
                do {
                    if let json: Dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
                    {
                        self.sendDataToDelegate(json)
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        }
        task.resume()
    }
    
    // MARK: send recieved data
    
    func sendDataToDelegate(data: AnyObject)  {
        self.delegate!.recievedData(data)
    }
    
}
