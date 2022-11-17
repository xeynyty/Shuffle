//
//  LibraryView.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import SwiftUI

struct LibraryView: View {
    
    @ObservedObject var xml: ParserXML
    
    @Binding var selectedBook: Book
    @Binding var selectedTab: SidebarMenu
    
    var body: some View {
        
        VStack {
        
            List(0..<xml.ListOfBook.count, id: \.self) { book in

                Item(xml: xml, selectedBook: $selectedBook, selectedTab: $selectedTab, book: book)

            }
            
        }
        .onAppear {
            

            
        }
        
    }
}

struct Item: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var xml: ParserXML
    
    @Binding var selectedBook: Book
    @Binding var selectedTab: SidebarMenu
    
    var book: Int
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            HStack {
                
                Text(xml.ListOfBook[book].title)
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
                
                Text("Readed: \( String(format: "%.2f", 100 / ( Double(xml.ListOfBook[book].text.count) / Double(UserDefaults.standard.integer(forKey: xml.ListOfBook[book].title)) ) ))% ")
                    .font(.subheadline)
                    .fontWeight(.light)
                
            }
            HStack {
                
                Text(xml.ListOfBook[book].genre)
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                
            }
            
        }
        .contentShape(Rectangle())
        .padding(.all, 12)
        .background(selectedBook == xml.ListOfBook[book] ? .blue.opacity(0.7) : colorScheme == .dark ? Color(hex: 0x2f3134) : Color(hex: 0xececec))
        .cornerRadius(10)
        .onTapGesture {
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)){
                selectedBook = xml.ListOfBook[book]
            }
            
            xml.ReaderBook = xml.ListOfBook[book]
            
            //if xml.ReaderBook.text.count > 0 {
                selectedTab = .reader
            //}
            
        }
        
    }
    
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
