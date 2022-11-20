//
//  ReaderView.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import SwiftUI

struct ReaderView: View {
    // Require ParserXML class for parent
    @ObservedObject var xml: ParserXML
    // Good State var for goor view, UwU, we need it
    @State var target = 50
    @State var oldHover = 0
    @State var size = UserDefaults.standard.double(forKey: "textSize")
    @State var paddingSize = UserDefaults.standard.double(forKey: "padding")
    
    var body: some View {
        VStack {
            
            if xml.ReaderBook != Book() && xml.ReaderBook.text.count != 0 {
                
                ScrollViewReader { scroll in
                    List(0..<(target), id: \.self) { ID in
                        
                        HStack {
                            
                            Spacer()
                                .frame(width: 50)
                            
                            HStack {
                                Text(xml.ReaderBook.text[ID])
                                    .fontWeight(UserDefaults.standard.bool(forKey: "isBold") ? .bold : .regular)
                                    .font(.system(size: size))
                                Spacer()
                            }
                            .onHover { hover in
                                DispatchQueue.main.async {
                                    if hover { CheckUploadData(ID) }
                                }
                            }
                            Spacer()
                                .frame(width: 50)
                        }
                        
                    }
                    .onAppear {
                        
                        DispatchQueue.global(qos: .userInteractive).async {
                            oldHover = UserDefaults.standard.integer(forKey: xml.ReaderBook.title)
                            
                            if oldHover > target && oldHover < xml.ReaderBook.text.count + 50 { target = oldHover + 50 }
                            if target > xml.ReaderBook.text.count { target = xml.ReaderBook.text.count }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            scroll.scrollTo(UserDefaults.standard.integer(forKey: xml.ReaderBook.title))
                        }
                        
                        
                    }
                    .navigationTitle(xml.ReaderBook.title)
                    .toolbar {
                        
                        Button(action: {
                            
                            scroll.scrollTo(UserDefaults.standard.integer(forKey: xml.ReaderBook.title))
                            
                        }, label: {
                            
                            Text("Go to last read")
                            
                        })
                        
                        
                    }
                    
                    
                }
                
                
                
                
            } else {
                
                Text("Please choise book in library tab")
                
            }
            
        }
    }
    
    func CheckUploadData(_ hoverOn: Int) {
        // Check for update oldHover data
        if oldHover < hoverOn {
            UserDefaults.standard.set(hoverOn, forKey: xml.ReaderBook.title)
            oldHover = hoverOn
        }
        // If still have <25 text - upload new 100 with check
        if target - hoverOn < 25 {
            
            if target + 100 < xml.ReaderBook.text.count {
                
                target += 100
                
            } else {
                
                target = xml.ReaderBook.text.count
                
            }
            
        }
        
        
    }
    
}
