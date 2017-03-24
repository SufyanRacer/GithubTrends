//
//  ProjectInfoViewModel.swift
//  GithubTrends
//
//  Created by Sufyan on 22/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit

class ProjectViewModel: NSObject {
    
    var projectInfo: Project?
    
    init(projectInfo: Project) {
        self.projectInfo = projectInfo
    }
    
    var userNameString : String {
        return (projectInfo?.userName)!
    }
    var projectNameString : String {
        return (projectInfo?.projectName)!
    }
    var avatarURL: String {
        return (self.projectInfo?.avatarURL)!
    }
    
    var githubLinkString: String {
        return (self.projectInfo?.gihubLink)!
    }
    
    var projectDescriptionString : String {
        return (projectInfo?.projectDescription)!
    }
    var starsCountString : String {
        let starsCount: NSNumber = (projectInfo?.starsCount)!
        return starsCount.stringValue + " Stars"
    }
    var forksCountString : String {
        let forksCount: NSNumber = (projectInfo?.forksCount)!
        return forksCount.stringValue + " Forks"
    }
}
