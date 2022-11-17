//
//  ContentView.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import SwiftUI

enum SidebarMenu: String, Hashable, CaseIterable {
    
    case main = "Main"
    case library = "Library"
    case reader = "Reader"
    
}

struct ContentView: View {
    
    @ObservedObject var xml: ParserXML = ParserXML()
    @ObservedObject var launch: LaunchCheck = LaunchCheck()
    
    @State private var selectedTab: SidebarMenu = .main
    @State var selectedBook = Book()
    
    var body: some View {
        
        NavigationSplitView {
            
            List(SidebarMenu.allCases, id: \.self, selection: $selectedTab) { tab in
                
                NavigationLink(tab.rawValue, value: tab)
                
            }
            .navigationSplitViewColumnWidth(150)
            
        } detail: {
            
            VStack {
                switch selectedTab {
                    
                case .main:
                    MainView()
                    
                case .library:
                    LibraryView(xml: xml, selectedBook: $selectedBook, selectedTab: $selectedTab)
                    
                case .reader:
                    ReaderView(xml: xml)
                    
                }
            }
            .navigationSplitViewColumnWidth(700)
            
        }
        .frame(minWidth: 700, minHeight: 500)
        .onAppear {
            
            xml.ParseListOfBooks()
            launch.CreateDirectory()
            
        }

        
    }
    
    
}
