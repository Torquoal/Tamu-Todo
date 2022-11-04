//
//  TaskTableViewController.swift
//  TodoList
//
//  Created by Shaun Macdonald on 14/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UITableViewController {
    
    //MARK: Properties
    
    // list of tasks on the table
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the Tamu 'Back' button at the bottom of the to-do list screen.
        let newFrame = view.frame
        let w = newFrame.midX
        let h = newFrame.height
        let tamuButton  = UIButton(frame: CGRect(x: w/3, y: h*0.86, width: w*1.33, height: h/4))
        tamuButton.setImage(UIImage(named: "tamuClose"), for: .normal)
        tamuButton.addTarget(self, action: #selector(tamuButtonAction), for: .touchUpInside)
        self.navigationController?.view.addSubview(tamuButton)
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // load tasks
        if let savedTasks = loadTasks() {
            tasks = savedTasks
        }
        
        // log navigation
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Navigated to To Do List \n"
        GlobalVariables.sharedManager.csvText += newLine
    }
    
    // tamuButton function to navigate back to the game
    @IBAction func tamuButtonAction(sender: UIButton!) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Returned to Pet \n"
        GlobalVariables.sharedManager.csvText += newLine
        self.performSegue(withIdentifier: "unwindToGame", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TaskTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TaskTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let task = tasks[indexPath.row]
        
        cell.nameLabel.text = task.name
        cell.ratingControl.important = task.rating
        cell.checkboxControl.rating = task.check
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
            // Save changes to tasks list
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Allows cells toe be rearranged.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let rowToMove = tasks[fromIndexPath.row]
        tasks.remove(at: fromIndexPath.row)
        tasks.insert(rowToMove, at: toIndexPath.row)
        saveTasks()
    }
    
    // MARK: - Navigation
    
    // Actions to take before navigating to another view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new task.", log: OSLog.default, type: .debug)
            
            // put Tamu into close state after adding a new task
            GlobalVariables.sharedManager.close = true
            GlobalVariables.sharedManager.moodValue += 6
            if (GlobalVariables.sharedManager.moodValue > 100){ GlobalVariables.sharedManager.moodValue = 100 }
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            let currentDateTime = Date()
            let timestamp = formatter.string(from: currentDateTime)
            let newLine = timestamp + ", New Task \n"
            GlobalVariables.sharedManager.csvText += newLine
            
        case "ShowDetail":
            guard let taskDetailViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTaskCell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.task = selectedTask
        default:
            print("Tamu")
        }
    }
    
    //MARK: Actions
    
    // navigation from add/edit screen to the to-do list.
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task.
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new task.
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveTasks()
        }
    }
    
    // Save current task list to phone memory
    private func saveTasks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Tasks successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save tasks...", log: OSLog.default, type: .error)
        }
    }
    
    // Restore list from phone memory
    private func loadTasks() ->[Task]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Task.ArchiveURL.path) as? [Task]
    }
}
