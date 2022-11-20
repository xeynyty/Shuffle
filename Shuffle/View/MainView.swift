//
//  MainView.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import SwiftUI
import SafariServices

struct MainView: View {
    
    @State var openFile = false
    @ObservedObject var xml: ParserXML = ParserXML()
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("It's a welcome screen in Shuffle!")
                .font(.system(size: 30))
                .font(.title)
                .fontWeight(.ultraLight)
                .padding(.bottom,10)
            
            
            
            VStack {
                // Add book button
                Button(action: { openFile.toggle() }, label: {
                    
                    HStack {
                        Text("\(Image(systemName: "plus.app"))")
                            .font(.system(size: 20))
                            .padding(.all, 15)
                        Spacer()
                        Text("ADD FB2 BOOK")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                            .padding(.all, 15)
                        Spacer()
                    }
                    .background(Color.accentColor)
                    .cornerRadius(5)
                    
                    
                })
                .buttonStyle(.plain)
                .fileImporter(isPresented: $openFile, allowedContentTypes: [.data]) { res in
                    do {
                        
                        let url = try res.get()
                        
                        let rawText = try Data(contentsOf: url)
                        
                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            let fileURL = dir.appendingPathComponent("\(Date()).fb2")
                            
                            FileManager.default.createFile(atPath: "\(fileURL)", contents: nil)
                            
                            try rawText.write(to: fileURL)
                            
                            print("ADD \(url) -> \(fileURL)")
                            
                        }
                        xml.ParseListOfBooks()
                        
                    }
                    catch { print("error", error) }
                    
                }
                
                // Divider
                HStack {
                    
                    Rectangle()
                        .frame(height: 1)
                    
                    Text("OR")
                    
                    Rectangle()
                        .frame(height: 1)
                    
                }
                .foregroundColor(.gray)
                
                // Open folder button
                Button(action: {
                    
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        NSWorkspace.shared.open(dir)
                    }
                    
                }, label: {
                    
                    HStack {
                        Text("\(Image(systemName: "folder.fill"))")
                            .font(.system(size: 20))
                            .padding(.all, 15)
                        Spacer()
                        Text("OPEN APP FOLDER")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                            .padding(.all, 15)
                        Spacer()
                    }
                    .background(Color.accentColor)
                    .cornerRadius(5)
                    
                })
                .buttonStyle(.plain)

            }
            .frame(width: 350)
            
            Spacer()
            
            // Footer git url and version
            HStack {
                Link("github.com/xeynyty", destination: URL(string: "https://github.com/xeynyty")!)
                    .padding()
                    .font(.system(size: 15))
                    .font(.callout)
                    .fontWeight(.ultraLight)
                
                Text("Alpha version 0.2 from 20/11/2022")
                    .font(.system(size: 15))
                    .font(.callout)
                    .fontWeight(.ultraLight)
            }
        }
    }
}
