//
//  CheckboxControl.swift
//  Todo List
//
//  Created by Shaun Macdonald on 05/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

//
// Some of this code is outdated and legacy from a point in time when multiple importance stars were considered.
// Inherited from RatingControl as required behaviour is almost identical,
// aside from MoodValue interactions and LoveScene trigger in Button Action section. 
//


import UIKit

@IBDesignable class CheckboxControl: UIStackView {
    
    //MARK: Properties
    private var checkbox = [UIButton]()
    
    // Value of checkbox. 0 - empty, 1 - ticked
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var checkSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        // clear any existing buttons
        for button in checkbox {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        checkbox.removeAll()
        
        // Load Button Images
        //let bundle = Bundle(for: type(of: self))
        let unchecked = UIImage(named: "unchecked")
        let checked = UIImage(named: "checked")
        
        // Create the button
        let button = UIButton()
        
        // Set the button images
        button.setImage(unchecked, for: .normal)
        button.setImage(checked, for: .selected)
            
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: checkSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: checkSize.width).isActive = true
        
        // Setup the button action
        button.addTarget(self, action: #selector(CheckboxControl.checkboxTapped(button:)), for: .touchUpInside)
            
        // Add the button to the stack
        addArrangedSubview(button)
            
        // Add the new button to the rating button array
        checkbox.append(button)
        
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    
    @objc func checkboxTapped(button: UIButton) {
        guard let index = checkbox.index(of: button) else {
            fatalError("The button, \(button), is not in the checkbox array: \(checkbox)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
        // if box goes from unchecked to checked, trigger LoveScene and vice versa. Log event
        // increase MoodValue as task has been completed. Value cannot exceed 100.
        
        if (rating == 1){
            GlobalVariables.sharedManager.love = true
            GlobalVariables.sharedManager.moodValue += 26
            if (GlobalVariables.sharedManager.moodValue > 100){ GlobalVariables.sharedManager.moodValue = 100 }
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            let currentDateTime = Date()
            let timestamp = formatter.string(from: currentDateTime)
            let newLine = timestamp + ", Checked Task \n"
            GlobalVariables.sharedManager.csvText += newLine
        } else {
            
            // if unchecked, remove MoodValue increase and disable LoveScene trigger. Value cannot be lower than 0.
            GlobalVariables.sharedManager.love = false
            GlobalVariables.sharedManager.moodValue -= 26
            if (GlobalVariables.sharedManager.moodValue < 0){ GlobalVariables.sharedManager.moodValue = 0 }
        }
    }
    
    private func updateButtonSelectionStates() {
        
        for (index, button) in checkbox.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
}

