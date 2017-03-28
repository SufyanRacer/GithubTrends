//
//  ContentProvider.swift
//  GithubTrends
//
//  Created by Sufyan on 28/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit

protocol ContentProviderProtocol {
    func recievedProjectModelArray(array: [ProjectViewModel]);
}

class ContentProvider: NSObject, APIProtocol {
        
    var delegate: ContentProviderProtocol
    
    // MARK: Init with delegate
    
    init(withDelegate delegate: ContentProviderProtocol) {
        self.delegate = delegate
    }
    
    // MARK: Call from Controller
    
    func getData() {
        self.callAPI()
    }
    
    // MARK: Call API for raw data
    
    func callAPI() {
        API(withDelegate: self).fetchJSONData()
    }
    
    // MARK: Call API delegate method
    
    func recievedData(data: AnyObject) {
        if data as? Dictionary<String, AnyObject> != nil {
            let itemData: Dictionary<String, AnyObject> = data as! Dictionary<String, AnyObject>
            let itemsArray: [Dictionary<String, AnyObject>] = itemData["items"] as! [Dictionary<String, AnyObject>]
            let trendingItems: [ProjectViewModel] = self.parseData(itemsArray)
            self.delegate.recievedProjectModelArray(trendingItems)
        }
        else {
            self.delegate.recievedProjectModelArray([ProjectViewModel]())
        }
    }
    
    // MARK: Parse raw data from API
    
    func parseData(itemArray: [Dictionary<String, AnyObject>]) -> [ProjectViewModel] {
        var trendingItems: [ProjectViewModel] = [ProjectViewModel]()
        for item:Dictionary<String, AnyObject> in itemArray {
            let project: Project = Project.init(withDictionary: item)
            let projectModel: ProjectViewModel = ProjectViewModel.init(projectInfo: project)
            trendingItems.append(projectModel)
        }
        return trendingItems
    }
    
}
