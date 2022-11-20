//
//  ParserXML.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import Foundation
import SwiftyXMLParser

// Book struct
struct Book: Hashable {
    
    var fileName: String = ""
    var title: String = ""
    var genre: String = ""
    var text: Array<String> = []
    var image: Data = Data()
    
}

// Type of parse data in FB2
enum parsedTypeData: Hashable, Encodable {
    
    case title
    case genre
    case text
    case image
    case all
    
}

// Main Parser class
class ParserXML: ObservableObject {
    
    @Published var BookList: [Book] = []
    @Published var ReaderBook: Book = Book()
    
    // Parse data func, best func
    func parseDataFromFB2(fileName: String, dataType: [parsedTypeData], listID: Int) {
        
        let queue = DispatchQueue.main
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            do {
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(fileName)
                    let rawText = try String(contentsOf: fileURL, encoding: .utf8)
                    
                    let xml = try! XML.parse(rawText)
                    
                    // File name
                    queue.async {
                        self.BookList[listID].fileName = fileName
                    }
                    
                    // Parse title
                    if dataType.contains(.title) || dataType.contains(.all) {
                        if let text = xml["FictionBook", "description", "title-info", "book-title"].text {
                            queue.async {
                                self.BookList[listID].title = text
                            }
                        }
                    }
                    // Parse genres
                    if dataType.contains(.genre) || dataType.contains(.all) {
                        if let text = xml["FictionBook", "description", "title-info", "genre"].text {
                            queue.async {
                                self.BookList[listID].genre = text
                            }
                        }
                    }
                    
                    // Parse image
                    if dataType.contains(.image) || dataType.contains(.all) {
                        
                        if let text = xml["FictionBook", "binary"].text {
                            
                            if text != "" {
                                queue.async {
                                    self.BookList[listID].image = Data(base64Encoded: text)!
                                }
                            }
                            
                        }
                        
                    }
                    
                    // Parse text
                    if dataType.contains(.text) || dataType.contains(.all) {
                        
                        self.ParseText(fileName, listID)
                        
                    }
                    
                }
                
            }
            catch { print("error", error) }
            
        }
        
    }
    
    // Parse all books in /Documents/...
    func ParseListOfBooks() {
        
        let documentDirectoryPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: documentDirectoryPath)
        
        while let file = files?.nextObject() {
            
            if "\(file)".contains(".fb2") {
                
                // Create new array item for new book
                self.BookList.append(Book())
                
                // Parse new book in created array item
                self.parseDataFromFB2(
                    fileName: file as! String,
                    dataType: [.all],
                    listID: self.BookList.count - 1
                )
                
            }
            
        }
        
    }
    
    // Func for parsing text from FB2
    func ParseText(_ file: String, _ id: Int) {
        var tempOutputText: [String] = []
        
        DispatchQueue.global(qos: .default).async {
            do {
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(file)
                    let rawText = try String(contentsOf: fileURL, encoding: .utf8)
                    
                    let xml = try! XML.parse(rawText)
                    
                    //MARK: - Body
                    
                    let numHit = xml.FictionBook.body.all?.count
                    for i in 0...(numHit ?? 0) {
                        for _ in xml["FictionBook", "body", i] {
                            // print("Body: ",hit)
                            
                            //MARK: - Body -> Selection
                            let numJit = xml.FictionBook.body[i].section.all?.count
                            for j in 0...(numJit ?? 0) {
                                for _ in xml["FictionBook", "body", i, "section", j] {
                                    // print("Body -> Selection: ", jit )
                                    
                                    // MARK: - Selections -> P
                                    let numPit2 = xml.FictionBook.body[i].section[j].all?.count
                                    for _ in 0...(numPit2 ?? 0) {
                                        for pit in xml["FictionBook", "body", i, "section", j, "p"] {
                                            //  print("Selections -> P: ", jit )
                                            if (pit.text ?? "").count > 3 {
                                                tempOutputText.append(pit.text ?? "error")
                                            }
                                        }
                                    }
                                    
                                    // MARK: - Body -> Selection -> Selection
                                    let numKit = xml.FictionBook.body[i].section[j].all?.count
                                    for k in 0...(numKit ?? 0) {
                                        for _ in xml["FictionBook", "body", i, "section", j, "section", k] {
                                            //print("Selection -> Selection: ", jit )
                                            
                                            // MARK: - Body -> Selection -> Selection -> P
                                            let numPit = xml.FictionBook.body[i].section[j].section.all?.count
                                            for k in 0...(numPit ?? 0) {
                                                for pit in xml["FictionBook", "body", i, "section", j, "section", k, "p"] {
                                                    //print("Selection -> Selection -> P: ", jit )
                                                    if (pit.text ?? "").count > 3 {
                                                        tempOutputText.append(pit.text ?? "error")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.BookList[id].text = tempOutputText
                        print("Added text: ", tempOutputText.count, " to ", self.BookList[id].title)
                        
                        tempOutputText = []
                        
                    }
                }
                
                
                
            }
            catch { print("error", error) }
        }
        
    }
    
}
