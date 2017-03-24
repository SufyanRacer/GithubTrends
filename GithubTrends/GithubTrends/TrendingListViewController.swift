//
//  ViewController.swift
//  GithubTrends
//
//  Created by Sufyan on 22/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TrendingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, APIProtocol {

    var trendList: [Project] = []
    
    @IBOutlet weak var holderViewBottomSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var trendingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(self.activityIndicator)
        self.configureKeyboardNotifications()
        self.addSignalForSearchBar()
        // fetch data from API here
        self.fetchData()
    }
    
    func addSignalForSearchBar() {
        let searchSignal = self.rac_signalForSelector(#selector(TrendingListViewController.searchBar(_:textDidChange:)), fromProtocol: UISearchBarDelegate.self)
        searchSignal.subscribeNext { (a: AnyObject!) in
            let tuple = a as! RACTuple
            let searchBar = tuple.first as! UISearchBar
            self.findData(searchBar.text!)
            print("Searching for: \(searchBar.text)")
        }
    }
    
    func configureKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrendingListViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrendingListViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification , object: nil)
    }
    
    func fetchData() {
        API(withDelegate: self).fetchJSONData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableView Deleagate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.trendList.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TrendCell = tableView.dequeueReusableCellWithIdentifier("TrendCell") as! TrendCell
        let projectInfo: Project = self.trendList[indexPath.row]
        let projectViewModel: ProjectViewModel = ProjectViewModel(projectInfo: projectInfo)
        cell.configureCell(projectViewModel)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushDetail" {
            let index: Int = (self.trendingTableView.indexPathForSelectedRow?.row)!
            let projectInfo: Project = self.trendList[index]
            let projectViewModel: ProjectViewModel = ProjectViewModel(projectInfo: projectInfo)
            let detailViewController: ProjectDetailsViewController = segue.destinationViewController as!ProjectDetailsViewController
            detailViewController.projectViewModel = projectViewModel
        }
    }
    
    // MARK: Keyboard Show/Hide Notification Handler
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        self.holderViewBottomSpacingConstraint.constant = keyboardHeight
    }
    func keyboardWillHide(notification: NSNotification){
        self.holderViewBottomSpacingConstraint.constant = 0.0
    }
    
    // MARK: SearchBar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
    }
    
    internal func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    // MARK: API Delegate Method
    func recievedData(data: AnyObject){
        if data as? [Dictionary<String, AnyObject>] != nil {
            let items: [Dictionary<String, AnyObject>] = data as! [Dictionary<String, AnyObject>]
            self.filterData(items)
        }
    }
    
    // MARK: Add Data to
    
    func filterData(items: [Dictionary<String, AnyObject>]) {
        for item:Dictionary<String, AnyObject> in items {
            let userName: String = (item["owner"] as! Dictionary<String, AnyObject>)["login"] as! String
            let projectName: String = item["name"] as! String
            let avatarURL: String = (item["owner"] as! Dictionary<String, AnyObject>)["avatar_url"] as! String
            var description: String?
            if item["description"] as? String != nil {
                description = (item["description"] as! String)
            }
            else{
                description = "No Description"
            }
            let githubLink: String = item["html_url"] as! String
            let starsCount: Int = item["watchers_count"] as! Int
            let forksCount: Int = item["forks_count"] as! Int
            let project: Project = Project(userName: userName,projectName: projectName, avatarURL: avatarURL,projectDescription: description!, githubLink: githubLink,starsCount: starsCount,forksCount: forksCount)
            self.trendList.append(project)
        }
        self.updateView()
    }
    // MARK: Update Data to Table
    func updateView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.trendingTableView.reloadData()
        })
    }
    
    // MARK: Find User Typed Data
    func findData(inputString: String!)  {
        
        if self.trendList.count > 0 {
            if inputString == "" {
                self.scrollToIndex(0)
                return
            }
            for (index, element) in self.trendList.enumerate() {
                let projectName: String = (element.projectName?.localizedLowercaseString)!
                let compareString: String = inputString.localizedLowercaseString
                let isPresent: Bool = projectName.containsString(compareString)
                if isPresent {
                    self.scrollToIndex(index)
                    break
                }
            }
        }
    }
    // MARK: Scroll To Index
    func scrollToIndex(index: Int) {
        self.trendingTableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), atScrollPosition: .Top, animated: true)
    }
}
