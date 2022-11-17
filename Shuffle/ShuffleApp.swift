//
//  ShuffleApp.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import SwiftUI

@main
struct ShuffleApp: App {
    
    @ObservedObject var launch: LaunchCheck = LaunchCheck()
    
    @State var i = 0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            
            CommandMenu("Settings") {
                
                Button("Bold text") {
                    UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "isBold"), forKey: "isBold")
                }.keyboardShortcut("b")
                
                
                Menu("Font size") {
                    
                    Button("Increase") {
                        
                        if UserDefaults.standard.double(forKey: "textSize") < 40.0 {
                            let size = UserDefaults.standard.double(forKey: "textSize") + 2
                            
                            UserDefaults.standard.set(size, forKey: "textSize")
                        }
                        
                    }.keyboardShortcut("+")
                    
                    Button("Decrease") {
                        
                        if UserDefaults.standard.double(forKey: "textSize") > 10.0 {
                            let size = UserDefaults.standard.double(forKey: "textSize") - 2
                            
                            UserDefaults.standard.set(size, forKey: "textSize")
                        }
                        
                    }.keyboardShortcut("-")
                }
                
            }
            
            
            
        }
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType { get {.none} set {} }
}
