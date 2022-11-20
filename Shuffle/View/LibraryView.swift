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
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 300))
    ]

    
    var body: some View {
        
        VStack {
            List(0..<xml.BookList.count, id: \.self) { bookID in

                Item(xml: xml, selectedBook: $selectedBook, selectedTab: $selectedTab, bookID: bookID)

            }
        }

    }
}

struct Item: View {

@Environment(\.colorScheme) var colorScheme

@ObservedObject var xml: ParserXML

// Bindings for change Book & Tab in app
@Binding var selectedBook: Book
@Binding var selectedTab: SidebarMenu

// Book ID in BookList array
var bookID: Int

    var body: some View {

        // One line of LibraryView list of book
        HStack {

            Image(nsImage: NSImage(data: xml.BookList[bookID].image) ?? NSImage())
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)

            VStack(spacing: 10) {
                
                HStack {
                    // Title
                    Text(xml.BookList[bookID].title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .redacted(reason: xml.BookList[bookID].title != "" ? .privacy : .placeholder)

                    Spacer()

                    // Get % of read book
                    Text("Readed: \(CalculateReadedProcent())")
                        .redacted(reason: xml.BookList[bookID].text.count > 0 ? .privacy : .placeholder)


                }
                .padding(.top,10)
                
                Spacer()
                
                HStack {
                    // Genres of book
                    Text(xml.BookList[bookID].genre)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .redacted(reason: xml.BookList[bookID].genre != "" ? .privacy : .placeholder)
                    Spacer()

                }
                .padding(.bottom,10)

            }
            .padding(.all, 12)
        }
        .frame(height: 130)
        .contentShape(Rectangle())
        .background(selectedBook == xml.BookList[bookID] ? Color.accentColor.opacity(0.7) : colorScheme == .dark ? Color(hex: 0x2f3134) : Color(hex: 0xececec))
        .cornerRadius(5)
        .onTapGesture {
            // Change selectedBook for highlight selected line of list with animation
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                selectedBook = xml.BookList[bookID]
            }
            // Change book in ReaderView
            xml.ReaderBook = xml.BookList[bookID]
            // Change tab on ReaderView
            selectedTab = .reader

        }

    }
    
    // Calculate % of read book
    func CalculateReadedProcent() -> String {
        return "\( String(format: "%.2f", 100 / ( Double(xml.BookList[bookID].text.count) / Double(UserDefaults.standard.integer(forKey: xml.BookList[bookID].title)))))% "
    }
    
}
// HEX extension for Color
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
