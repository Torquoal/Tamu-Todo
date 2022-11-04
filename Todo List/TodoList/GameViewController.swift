//
//  GameViewController.swift
//  Todo List
//
//  Created by Shaun Macdonald on 05/12/2017.
//  Copyright © 2017 Shaun Macdonald. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // Container for SKSprite game views to display within
    @IBOutlet weak var sceneView: SKView!
    
    // Sleep Schedule Variables
    var minBedTimeHour = 22
    var minBedTimeMinute = 0
    var maxBedTimeHour = 23
    var maxBedTimeMinutes = 59
    
    // Triggers when view opened
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameState()
    }
    
    // Primary game logic. Decides which game scene to load based on global flags and mutex. Triggers whenever scene is navigated to.
    @objc func loadGameState(){
        
        
        //set sleep flag to true if withing sleeping hours. If so, set animation mutex
        if (isSleepingHours(hours: maxBedTimeHour, minutes: maxBedTimeMinutes) ||
        ((GlobalVariables.sharedManager.earlyNight) &&
        (isSleepingHours(hours: minBedTimeHour, minutes: minBedTimeMinute)))){
            GlobalVariables.sharedManager.sleep = true
            GlobalVariables.sharedManager.mutex = true
        } else {
            GlobalVariables.sharedManager.sleep = false
            GlobalVariables.sharedManager.earlyNight = false
        }
        
        // is sleep flag, run sleep. disable close and sleep
        if (GlobalVariables.sharedManager.sleep){
            loadSleepLevel("SleepScene")
            GlobalVariables.sharedManager.sleep = false
            GlobalVariables.sharedManager.close = false
        
        // if close flag, run close. petting button will also now be active.
        } else if (GlobalVariables.sharedManager.close){
            loadCloseLevel("CloseScene")
        
        // if love flag, run love. prevent close for trigger after. Run love 2 times, then return to normal.
        } else if (GlobalVariables.sharedManager.love){
            loadLoveLevel("LoveScene")
            GlobalVariables.sharedManager.love = false
            GlobalVariables.sharedManager.close = false
            _ = Timer.scheduledTimer(withTimeInterval:4.2, repeats: false) { (timer) in
                self.loadGameState()
            }
         
        // if no flags, check MoodValue and run GameScene or Neutral Scene
        } else {
            // If MoodValue is below 40, run NeutralScene and log it.
            if (GlobalVariables.sharedManager.moodValue <= 40){
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .long
                let currentDateTime = Date()
                let timestamp = formatter.string(from: currentDateTime)
                let newLine = timestamp + ", Neutral Trigger \n"
                GlobalVariables.sharedManager.csvText += newLine
                loadNeutralLevel("NeutralScene")
                
                // If MoodValue is below 10, periodically throw WorryScenes
                if (GlobalVariables.sharedManager.moodValue <= 10){
                    let randIn2 = Double(arc4random_uniform(2))
                    let delay = (randIn2+1) * 12
                    _ = Timer.scheduledTimer(withTimeInterval:delay, repeats: false) { (timer) in
                        self.triggerWorryScene()
                    }
                }
            } else {
                // if MoodValue is above 40, run GameScene.
                loadGameLevel("GameScene")
                
                GlobalVariables.sharedManager.mutex = false
                // if MoodValue is above 90, periodically run FulfilledScene
                if (GlobalVariables.sharedManager.moodValue >= 90)
                && (GlobalVariables.sharedManager.mutex == false){
                    let randIn4 = Double(arc4random_uniform(4))
                    let delay = (randIn4+2) * 2.7
                    _ = Timer.scheduledTimer(withTimeInterval:delay, repeats: false) { (timer) in
                        self.triggerFulfilledScene()
                    }
                }
                        }
        }
        
        // Reload gamestate every 12 minutes to account for time events such as waking up in the morning or decaying mood over time
        if (GlobalVariables.sharedManager.resetMutex == false){
            GlobalVariables.sharedManager.resetMutex = true
            print("Delayed Reset")
            _ = Timer.scheduledTimer(withTimeInterval:720, repeats: false) { (timer) in
                GlobalVariables.sharedManager.moodValue = GlobalVariables.sharedManager.moodValue - GlobalVariables.sharedManager.decayRate
                if (GlobalVariables.sharedManager.moodValue < 0) { GlobalVariables.sharedManager.moodValue = 0}
                print("MoodScore: \(GlobalVariables.sharedManager.moodValue)")
                GlobalVariables.sharedManager.mutex = false
                GlobalVariables.sharedManager.resetMutex = false
                GlobalVariables.sharedManager.close = false
                self.loadGameState()
            }
        }
    }
    
    /*
     ** Methods for calling each tamu gamestate scene
     */
    
    func loadFulfilledLevel(_ levelName: String) {
        let scene = FulfilledScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    func loadJumpLevel(_ levelName: String) {
        let scene = JumpScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    func loadHelpLevel(_ levelName: String) {
        let scene = helpScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    func loadNeutralLevel(_ levelName: String) {
        let scene = NeutralScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    func loadPetLevel(_ levelName: String) {
        let scene = PetScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    func loadGameLevel(_ levelName: String) {
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    func loadLoveLevel(_ levelName: String) {
        let scene = LoveScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
    }
    
    func loadWorryLevel(_ levelName: String) {
        let scene = WorryScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
    }
    
    func loadCloseLevel(_ levelName: String) {
        let scene = CloseScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
    }
    
    func loadSleepLevel(_ levelName: String) {
        let scene = SleepScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
    }
    
    // Displays a static HelpScene
    @IBAction func loadHelpScene(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Opened Help \n"
        GlobalVariables.sharedManager.csvText += newLine
        if (GlobalVariables.sharedManager.help == false){
            loadHelpLevel("helpScene")
            GlobalVariables.sharedManager.help = true
        } else {
            loadGameState()
            GlobalVariables.sharedManager.help = false
        }
    }
    
    // log and then display WorryScene
    func triggerWorryScene(){
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Triggered Worry Scene \n"
        GlobalVariables.sharedManager.csvText += newLine
        if (GlobalVariables.sharedManager.mutex == false){
            GlobalVariables.sharedManager.mutex = true
            print("here")
            loadWorryLevel("WorryScene")
            _ = Timer.scheduledTimer(withTimeInterval:3.7, repeats: false) { (timer) in
                GlobalVariables.sharedManager.mutex = false
                self.loadGameState()
            }
        } else {
            //GlobalVariables.sharedManager.mutex = false
            print("Mutex cancels worry")
        }
    }
    
    /*
     ** Petting Methods: user interaction with Tamu while in different gamestates
     */
    
    // If the pet is above 40 MoodValue and isnt in another animation, trigger the JumpScene when the user taps Tamu.
    @IBAction func centralPetZone(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Central Pet \n"
        GlobalVariables.sharedManager.csvText += newLine
        if (40 < GlobalVariables.sharedManager.moodValue)
        && (GlobalVariables.sharedManager.close == false)
        && (GlobalVariables.sharedManager.sleep == false)
        && (GlobalVariables.sharedManager.mutex == false)
        && (!isSleepingHours(hours: maxBedTimeHour, minutes: maxBedTimeMinutes)){
            GlobalVariables.sharedManager.mutex = true
            loadJumpLevel("JumpScene")
            _ = Timer.scheduledTimer(withTimeInterval:0.6, repeats: false) { (timer) in
                GlobalVariables.sharedManager.mutex = false
                self.loadGameState()
            }
        }
    }
    
    // log then display FulfilledScene
    func triggerFulfilledScene(){
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Fulfill Trigger \n"
        GlobalVariables.sharedManager.csvText += newLine
        if (GlobalVariables.sharedManager.mutex == false){
            loadFulfilledLevel("FulfilledScene")
            GlobalVariables.sharedManager.mutex = true
            _ = Timer.scheduledTimer(withTimeInterval:7.29, repeats: false) { (timer) in
                //GlobalVariables.sharedManager.fulfillMutex = false
                GlobalVariables.sharedManager.mutex = false
                self.loadGameState()
            }
        } else {
            //GlobalVariables.sharedManager.mutex = false
            print("Mutex cancels fulfilled")
        }
    }
    
    // reload tamu gamestate on navigation unwind to react to list changes
    @IBAction func unwindToGame(sender: UIStoryboardSegue) {
            loadGameState()
    }
    
    // displays SleepScene if the user taps the space over the bed icon. Action is logged.
    @IBAction func tapBedToNapOrSleep(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Tapped Bed\n"
        GlobalVariables.sharedManager.csvText += newLine
        loadSleepLevel("SleepScene")
        GlobalVariables.sharedManager.mutex = true

        if (isSleepingHours(hours: minBedTimeHour, minutes: minBedTimeMinute)){
            GlobalVariables.sharedManager.sleep = true
            GlobalVariables.sharedManager.earlyNight =  true
        } else {
            GlobalVariables.sharedManager.sleep = false
        }
        GlobalVariables.sharedManager.close = false
        
    }
    // when a task is added CloseScene is displayed. Tapping over that icon throws PetScene and then refreshes state. Action logged.
    @IBAction func petTamu(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let currentDateTime = Date()
        let timestamp = formatter.string(from: currentDateTime)
        let newLine = timestamp + ", Petted Tamu \n"
        GlobalVariables.sharedManager.csvText += newLine
        if (GlobalVariables.sharedManager.close){
            loadPetLevel("PetScene")
            GlobalVariables.sharedManager.close = false
            _ = Timer.scheduledTimer(withTimeInterval:3.5, repeats: false) { (timer) in
                self.loadGameState()
            }
        }
    }
    
    // returns if current time is between 8:30am and 00:00am or not.
    func isSleepingHours (hours: Int, minutes: Int) -> Bool {
        var output = false
        let calendar = Calendar.current
        let now = Date()
        let eight_thirty_this_morning = calendar.date(
            bySettingHour: 8,
            minute: 30,
            second: 0,
            of: now)!
    
        let bedtime = calendar.date(
            bySettingHour: hours,
            minute: minutes,
            second: 0,
            of: now)!
        
        if now <= eight_thirty_this_morning ||
            now >= bedtime
        {
            output = true
        }
        return output
    }
    
    // copies the current user logged action string to the iPhone clipboard for submission.
    @IBAction func copyStatsToClipboard(_ sender: Any) {
        UIPasteboard.general.string = GlobalVariables.sharedManager.csvText
    }
}
