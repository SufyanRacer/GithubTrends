//
//  ViewController.swift
//  GithubTrends
//
//  Created by Sufyan on 22/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TrendingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ContentProviderProtocol {

    var trendList: [ProjectViewModel] = []
    
    @IBOutlet weak var holderViewBottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var trendingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(self.activityIndicator)
        self.configureKeyboardNotifications()
        self.addSignalForSearchBar()
        // fetch data from ContentProvider here
        self.getData()
    }
    
    // MARK: Add signal to handle user response
    
    func addSignalForSearchBar() {
        let searchSignal = self.rac_signalForSelector(#selector(TrendingListViewController.searchBar(_:textDidChange:)), fromProtocol: UISearchBarDelegate.self)
        searchSignal.subscribeNext { (a: AnyObject!) in
            let tuple = a as! RACTuple
            let searchBar = tuple.first as! UISearchBar
            self.findData(searchBar.text!)
            print("Searching for: \(searchBar.text)")
        }
    }
    
    // MARK: Configure keyboard notifications
    
    func configureKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrendingListViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrendingListViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification , object: nil)
    }
    
    // MARK: Fetch Data from ContentProvider
    
    func getData() {
        ContentProvider.init(withDelegate: self).getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.trendList.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TrendCell = tableView.dequeueReusableCellWithIdentifier("TrendCell") as! TrendCell
        cell.configureCell(self.trendList[indexPath.row])
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushDetail" {
            let index: Int = (self.trendingTableView.indexPathForSelectedRow?.row)!
            let detailViewController: ProjectDetailsViewController = segue.destinationViewController as!ProjectDetailsViewController
            detailViewController.projectViewModel = self.trendList[index]
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
    
    
    // MARK: ContentProvider Delegate Method
    
    func recievedProjectModelArray(array: [ProjectViewModel]){
        if array.count > 0 {
            self.trendList = array
            self.updateView()
        }
        else{
            // show alert - no data found
        }
    }
    
    // MARK: Update data to table
    
    func updateView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.trendingTableView.reloadData()
        })
    }
    
    // MARK: Find user typed data
    
    func findData(inputString: String!)  {
        if self.trendList.count > 0 {
            if inputString == "" {
                self.scrollToIndex(0)
                return
            }
            for (index, element) in self.trendList.enumerate() {
                let projectName: String = (element.projectNameString.localizedLowercaseString)
                let compareString: String = inputString.localizedLowercaseString
                let isPresent: Bool = projectName.containsString(compareString)
                if isPresent {
                    self.scrollToIndex(index)
                    break
                }
            }
        }
    }
    // MARK: Scroll TableView to similar search Index
    
    func scrollToIndex(index: Int) {
        self.trendingTableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), atScrollPosition: .Top, animated: true)
    }
}
