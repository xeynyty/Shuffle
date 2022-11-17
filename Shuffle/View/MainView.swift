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
            
            Text("It's a welcome window in Shuffle!")
                .font(.system(size: 30))
                .font(.title)
                .fontWeight(.ultraLight)
            
            HStack {
                Text("Alpha")
                    .font(.system(size: 15))
                    .font(.callout)
                    .fontWeight(.bold)
                Text("version 0.1 from 18/11/2022")
                    .font(.system(size: 15))
                    .font(.callout)
                    .fontWeight(.ultraLight)
            }
            
            Button(action: { openFile.toggle() }, label: {
                
                Text("\(Image(systemName: "plus.app")) Add FB2 book")
                    .padding(.all, 15)
                    .font(.system(size: 20))
                    .fontWeight(.light)
                
                
            })
            .containerShape(Rectangle())
            .buttonStyle(.plain)
            .background(.blue)
            .cornerRadius(5)
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.data]) { res in
                do {
                    
                    let url = try res.get()
                    
                    let rawText = try Data(contentsOf: url)
                    
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent("Shuffle/\(Date()).fb2")
                        
                        FileManager.default.createFile(atPath: "\(fileURL)", contents: nil)
                        
                        try rawText.write(to: fileURL)
                        
                        print("ADD \(url) -> \(fileURL)")
                        
                    }
                    xml.ParseListOfBooks()
                    
                }
                catch { print("error", error) }
                
            }
            
            Spacer()
            
            Link("github.com/xeynyty", destination: URL(string: "https://github.com/xeynyty")!)
                .padding()
                .font(.system(size: 15))
                .font(.callout)
                .fontWeight(.ultraLight)
                
        }
    }
}

extension String {
    func substring(from left: String, to right: String) -> String {
        if let match = range(of: "(?<=\(left))[^\(right)]+", options: .regularExpression) {
            return String(self[match])
        }
        return ""
    }
}
