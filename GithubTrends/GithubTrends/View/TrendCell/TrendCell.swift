//
//  TrendCell.swift
//  GithubTrends
//
//  Created by Sufyan on 22/03/17.
//  Copyright © 2017 Sufyan. All rights reserved.
//

import UIKit

class TrendCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var starsCount: UILabel!
    
    @IBOutlet weak var projectDescription: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(projectViewModel: ProjectViewModel) {
        self.projectName.text = projectViewModel.projectNameString
        self.starsCount.text = projectViewModel.starsCountString
        self.projectDescription.text = projectViewModel.projectDescriptionString
    }

}
