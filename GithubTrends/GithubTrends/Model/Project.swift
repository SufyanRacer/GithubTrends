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
    
    init(userName: String, projectName: String, avatarURL: String, projectDescription: String, githubLink: String, starsCount: Int, forksCount: Int) {
        
        self.userName = userName
        self.projectName = projectName
        self.avatarURL = avatarURL
        self.projectDescription = projectDescription
        self.gihubLink = githubLink
        self.starsCount = starsCount
        self.forksCount = forksCount
    }
    
}
