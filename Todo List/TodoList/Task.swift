//
//  Task.swift
//  Todo List
//
//  Created by Shaun Macdonald on 13/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

import UIKit
import os.log

class Task: NSObject, NSCoding{
    
    //MARK: NSCoding
    
    // tasks and encoding and decoded when stored or retrieved.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(check, forKey: PropertyKey.check)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
                let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
                let check = aDecoder.decodeInteger(forKey: PropertyKey.check)
        // initialisers
        self.init(name: name, rating: rating, check:check)
    }
    
    //MARK: Properties
    
    // task attributes
    var name: String
    var rating: Int
    var check: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let rating = "rating"
        static let check = "check"
    }
    
    //MARK: Initialization
    init?(name: String, rating: Int, check: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be 0 or 1
        guard (rating == 0) || (rating == 1) else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.rating = rating
        self.check = check
        
    }
}
