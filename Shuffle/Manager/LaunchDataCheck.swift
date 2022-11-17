//
//  LaunchDataCheck.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import Foundation

class LaunchCheck: ObservableObject {
    
    func CreateDirectory() {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = dir.appendingPathComponent("Shuffle/")
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
    
    func CheckUserDefaultsSettings() {
        
//        if UserDefaults.standard.double(forKey: "testSize") == nil { UserDefaults.standard.set(20.0, forKey: "textSize") }
//        if UserDefaults.standard.bool(forKey: "isBold") == nil { UserDefaults.standard.set(false, forKey: "isBold") }
//        if UserDefaults.standard.integer(forKey: "padding") == nil { UserDefaults.standard.set(30, forKey: "padding") }
        
    }
    
    
    
}
