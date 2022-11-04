//
//  TaskTableViewCell.swift
//  TodoList
//
//  Created by Shaun Macdonald on 14/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    // task cells have names, importance and completion attributes
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var checkboxControl: CheckboxControl!
    
    // initialisation
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
