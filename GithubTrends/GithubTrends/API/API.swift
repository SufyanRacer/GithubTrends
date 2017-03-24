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
    var urlString : String = "https://api.github.com/search/repositories?q=java&sort=stars&order=desc"
    
    init(withDelegate delegate: APIProtocol) {
        self.delegate = delegate
    }
    
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
                        self.sendDataToDelegate(json["items"]!)
                    }
                } catch {
                    print("error in JSONSerialization")
                }
                
            }
        }
        task.resume()
    }
    
    func sendDataToDelegate(data: AnyObject)  {
        self.delegate!.recievedData(data)
    }
    
}
