//
//  TaskViewController.swift
//  Todo List
//
//  Created by Shaun Macdonald on 05/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

import UIKit
import os.log

// Controller for the task adding/editing view.
class TaskViewController: UIViewController, UITextFieldDelegate,
       UINavigationControllerDelegate {
    
    //MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var checkboxControl: CheckboxControl!
    
    /*
     This value is either passed by `TaskTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        //setup view is task is an existing task
        if let task = task {
            navigationItem.title = task.name
            nameTextField.text = task.name
            ratingControl.important = task.rating
            checkboxControl.rating = task.check
        }
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    // disable Save button while text field is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Navigation
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        // new task not added, disable CloseScene flag
        GlobalVariables.sharedManager.close = false
        GlobalVariables.sharedManager.moodValue -= 6
        
        // Depending on style of presentation (modal or push presentation), this view controller dismissed differently
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
    }
    // Configure view before presentation, in this case fill in task details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        super.prepare(for: segue, sender: sender)
        
        let name = nameTextField.text ?? ""
        let rating = ratingControl.important
        let check = checkboxControl.rating
        
        task = Task(name: name,  rating: rating, check: check)
    }

    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

