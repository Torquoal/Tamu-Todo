//
//  RatingControl.swift
//  Todo List
//
//  Created by Shaun Macdonald on 05/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

//
// Some of this code is outdated and legacy from a point in time when multiple importance stars were considered.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var importanceStar = [UIButton]()
    
    // value of importance star: 0 - empty/unimportant, 1 - filled/important
    var important = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
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
        for button in importanceStar {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        importanceStar.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Create the button
        let button = UIButton()
            
        // Set the button images
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])
            
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.importanceStarTapped(button:)), for: .touchUpInside)
            
        // Add the button to the stack
        addArrangedSubview(button)
            
        // Add the new button to the rating button array
        importanceStar.append(button)
      
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    
    @objc func importanceStarTapped(button: UIButton) {
        guard let index = importanceStar.index(of: button) else {
            fatalError("The button, \(button), is not in the array: \(importanceStar)")
        }
        let importanceValue = index + 1
        
        if importanceValue == important {
            important = 0
        } else {
            important = importanceValue
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in importanceStar.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < important
        }
    }
}

