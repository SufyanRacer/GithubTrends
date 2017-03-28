//
//  Project.swift
//  GithubTrends
//
//  Created by Sufyan on 22/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit

class Project: NSObject {

    var userName: String?
    var projectName: String?
    var avatarURL: String?
    var projectDescription: String?
    var gihubLink: String?
    var starsCount: Int?
    var forksCount: Int?
    
    // MARK: Init with strings
    init(userName: String, projectName: String, avatarURL: String, projectDescription: String, githubLink: String, starsCount: Int, forksCount: Int) {
        
        self.userName = userName
        self.projectName = projectName
        self.avatarURL = avatarURL
        self.projectDescription = projectDescription
        self.gihubLink = githubLink
        self.starsCount = starsCount
        self.forksCount = forksCount
    }
    
    // MARK: Init with Dictionary
    
    init(withDictionary item: Dictionary<String, AnyObject>) {
        
        let userName: String = (item["owner"] as! Dictionary<String, AnyObject>)["login"] as! String
        let projectName: String = item["name"] as! String
        let avatarURL: String = (item["owner"] as! Dictionary<String, AnyObject>)["avatar_url"] as! String
        var projectDescription: String?
        if item["description"] as? String != nil {
            projectDescription = (item["description"] as! String)
        }
        else{
            projectDescription = "No Description"
        }
        let githubLink: String = item["html_url"] as! String
        let starsCount: Int = item["watchers_count"] as! Int
        let forksCount: Int = item["forks_count"] as! Int
        
        self.userName = userName
        self.projectName = projectName
        self.avatarURL = avatarURL
        self.projectDescription = projectDescription
        self.gihubLink = githubLink
        self.starsCount = starsCount
        self.forksCount = forksCount
        
    }
    
}
