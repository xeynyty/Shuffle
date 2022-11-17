//
//  ReaderView.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import SwiftUI

struct ReaderView: View {
    
    @ObservedObject var xml: ParserXML
    
    @State var target = 50
    @State var start = 0
    
    @State var oldHover = 0
    
    @State var size = UserDefaults.standard.double(forKey: "textSize")
    @State var paddingSize = UserDefaults.standard.double(forKey: "padding")
    
    var screen = NSScreen.main?.visibleFrame

    var body: some View {
        VStack {
            
            if xml.ReaderBook != Book() && xml.ReaderBook.text.count != 0 {
                
                ScrollViewReader { scroll in
                    List(start..<(target), id: \.self) { i in
                        
                        HStack {
                            
                            Spacer()
                                .frame(width: 50)
                            
                            Text(xml.ReaderBook.text[i])
                                .fontWeight(UserDefaults.standard.bool(forKey: "isBold") ? .bold : .regular)
                                .font(.system(size: size))
                                .onHover { hover in
                                    
                                    DispatchQueue.main.async {
                                        if hover {
                                            
                                            size = UserDefaults.standard.double(forKey: "textSize")
                                            
                                            if oldHover < i {
                                                
                                                UserDefaults.standard.set(i, forKey: xml.ReaderBook.title)
                                                oldHover = i
                                                
                                            }
                                            
                                            if target + 50 < xml.ReaderBook.text.count {
                                                
                                                self.target += 10
                                                
                                            } else {
                                                
                                                target = xml.ReaderBook.text.count - 1
                                                
                                            }
                                            
                                        }
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
}
