//
//  DataPersistence.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 14/12/23.
//

import Foundation
import os.log

//Struct for all data persistence loads and saves to resuse code in multiple view controllers
struct DataPersistence {
    
    //Save the user preferences
    static func savePreferences(userPreferences: UserPreferences) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: userPreferences, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Preferences successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save preferences...", log: OSLog.default, type: .error)
        }
    }
    
    //Save method to load user preferences from the device if any are saved
    static func loadPreferences() -> UserPreferences? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")
        
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loadedPreferences = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserPreferences.self, from: data) {
                    return loadedPreferences
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
}

