//
//  AppDelegate.swift
//  Todo List
//
//  Created by Shaun Macdonald on 05/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userDefaults = UserDefaults.standard
    
     // Run when app launches from close
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // compare current datetime to previous and deduct mood accordingly
        let date = UserDefaults.standard.object(forKey: "prevTime") as? Date
        if (date != nil){
            let diff = Calendar.current.dateComponents([.minute], from: date!, to: Date()).minute
            let moodDrop = ((Double(diff!)) / 12.0) * GlobalVariables.sharedManager.decayRate
            let prevMood = UserDefaults.standard.object(forKey: "prevMood") as? Double
            GlobalVariables.sharedManager.moodValue = prevMood! - moodDrop
            if (GlobalVariables.sharedManager.moodValue < 0) { GlobalVariables.sharedManager.moodValue = 0}
            print("mood term updated: \(GlobalVariables.sharedManager.moodValue)")
        }
        
        // log opening time
        let prevLogs = userDefaults.object(forKey: "prevLogs") as? String
        if (prevLogs != nil){
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            let currentDateTime = Date()
            let timestamp = formatter.string(from: currentDateTime)
            let newLine = timestamp + ", Open \n"
            GlobalVariables.sharedManager.csvText = prevLogs! + newLine
        }
        
        return true
    }

    // Sent when the application is about to move from active to inactive state. No behaviour required here
    func applicationWillResignActive(_ application: UIApplication) {}

    // Triggers when close returns to iOS homescreen from app.
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // store current datetime to iPhone storage to enable latter mood decay
        print(Date())
        print("mood bg saved: \(GlobalVariables.sharedManager.moodValue)")
        userDefaults.set(Date(), forKey:"prevTime")
        userDefaults.set(GlobalVariables.sharedManager.moodValue, forKey:"prevMood")
        userDefaults.set(GlobalVariables.sharedManager.csvText, forKey:"prevLogs")
    }

    // Application opened from iPhone menu
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // compare current datetime to previous and deduct mood accordingly
        let date = UserDefaults.standard.object(forKey: "prevTime") as? Date
        let diff = Calendar.current.dateComponents([.minute], from: date!, to: Date()).minute
        print(String(describing:("Datetime difference: \(String(describing: diff))")))
        let moodDrop = ((Double(diff!)) / 12.0) * GlobalVariables.sharedManager.decayRate
        print("moodDrop: \(moodDrop)")
        let prevMood = UserDefaults.standard.object(forKey: "prevMood") as? Double
        GlobalVariables.sharedManager.moodValue = (prevMood! - moodDrop)
        if (GlobalVariables.sharedManager.moodValue < 0) { GlobalVariables.sharedManager.moodValue = 0}
        print("mood bg updated: \(GlobalVariables.sharedManager.moodValue)")
        
        // log opening time
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let prevLogs = UserDefaults.standard.object(forKey: "prevLogs") as? String
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Open \n"
        GlobalVariables.sharedManager.csvText = prevLogs! + newLine
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. Not needed.
    func applicationDidBecomeActive(_ application: UIApplication) {}

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        
        // Store current date for latter mood decay
        print("mood saved terminate: \(GlobalVariables.sharedManager.moodValue)")
        userDefaults.set(Date(), forKey:"prevTime")
        userDefaults.set(GlobalVariables.sharedManager.moodValue, forKey:"prevMood")
        userDefaults.set(GlobalVariables.sharedManager.csvText, forKey:"prevLogs")
    }


}

