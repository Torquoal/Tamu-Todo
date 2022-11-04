//
//  GlobalVariables.swift
//  TodoList
//
//  Created by Shaun Macdonald on 15/01/2018.
//  Copyright © 2018 Shaun Macdonald. All rights reserved.
//

class GlobalVariables {
    
    // Gamestate flags
    public var close: Bool = false
    public var love: Bool = false
    public var sleep: Bool = false
    public var earlyNight: Bool = false
    public var help: Bool = false
    
    // Long-term mood value and mood decay rate
    public var moodValue: Double = 50
    public var decayRate: Double = 0.33
    
    // Mutex flags to prevent animation cancelling
    public var resetMutex: Bool =  false
    public var fulfillMutex: Bool = false
    public var sleepMutex: Bool = false
    public var worryMutex: Bool = false
    public var petMutux: Bool = false
    public var mutex: Bool = false
    
    // Logs user usage statistics for analysis via timestamps
    var csvText = "Date,Task\n"
    
    // Enable variables to be accessed by other classes
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
