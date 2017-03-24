//
//  ProjectDetailsViewController.swift
//  GithubTrends
//
//  Created by Sufyan on 22/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: UIViewController {
    
    var projectViewModel: ProjectViewModel?
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var projectDescription: UILabel!
    
    @IBOutlet weak var starCount: UILabel!
    
    @IBOutlet weak var forkCount: UILabel!
    
    @IBOutlet weak var otherLinks: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDetials()
    }
    
    func loadDetials()  {
        self.title = self.projectViewModel?.projectNameString
        self.userName.text = self.projectViewModel?.userNameString
        self.projectDescription.text = self.projectViewModel?.projectDescriptionString
        self.otherLinks.text = self.projectViewModel?.githubLinkString
        self.starCount.text = self.projectViewModel?.starsCountString
        self.forkCount.text = self.projectViewModel?.forksCountString
        self.loadImageInBackground()
    }
    
    func loadImageInBackground()  {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            if let data: NSData = NSData(contentsOfURL: NSURL(string: (self.projectViewModel?.avatarURL)!)!) {
                let image: UIImage = UIImage(data: data)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userImage.image = image
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
