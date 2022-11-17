//
//  ParserXML.swift
//  Shuffle
//
//  Created by Влад Кеиг on 17.11.2022.
//

import Foundation
import SwiftyXMLParser

struct Book: Hashable {
    
    var title: String = ""
    var genre: String = ""
    var text: Array<String> = []
    
}

class ParserXML: ObservableObject {
    
    @Published var ListOfBook: [Book] = [Book(title: "", genre: "", text: [])]
    @Published var ReaderBook: Book = Book()
    @Published var TargetTextArray: [String] = []
    
    func ParseTitleAndGenre(_ path: String) {
        
        var output = Book()
        
        DispatchQueue.main.async {
            do {
                
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent("Shuffle/\(path)")
                    let rawText = try String(contentsOf: fileURL, encoding: .utf8)
                    
                    let xml = try! XML.parse(rawText)
                    
                    // title
                    
                    if let text = xml["FictionBook", "description", "title-info", "book-title"].text {
                        output.title = text
                    }
                    
                    // genre
                    
                    if let text = xml["FictionBook", "description", "title-info", "genre"].text {
                        output.genre = text
                    }
                    
                }
                
            }
            catch { print("error", error) }
            
        }
        
    }
    
    func ParseListOfBooks() {
        
        var tempArray: [Book] = []
        
        let documentDirectoryPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = "\(documentDirectoryPath)/Shuffle/"
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: myFilesPath)
        
        while let file = files?.nextObject() {
            
            if "\(file)".contains(".fb2") {
                
                DispatchQueue.main.async {
                    
                    var temp = Book()
                    
                    do {
                        
                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            let fileURL = dir.appendingPathComponent("Shuffle/\(file)")
                            let rawText = try String(contentsOf: fileURL, encoding: .utf8)
                            
                            let xml = try! XML.parse(rawText)
                            
                            // title
                            
                            if let text = xml["FictionBook", "description", "title-info", "book-title"].text {
                                temp.title = text
                            }
                            
                            // genre
                            
                            if let text = xml["FictionBook", "description", "title-info", "genre"].text {
                                temp.genre = text
                            }
                            // text
                            
                            self.ParseText("\(file)", tempArray.count)
                            
                        }
                        tempArray.append(temp)
                        //print("Append", temp)
                        
                    }
                    catch { print("error", error) }
                    
                    DispatchQueue.main.async {
                            
                        self.ListOfBook = tempArray
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func ParseText(_ file: String, _ id: Int) {
        var tempOutputText: [String] = []
        
        let queue = DispatchQueue.global(qos: .background)
        
        queue.async {
            do {
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent("Shuffle/\(file)")
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
                        
                        self.ListOfBook[id].text = tempOutputText
                        print("Added text: ", tempOutputText.count, " to ", self.ListOfBook[id].title)
                        
                        tempOutputText = []
                        
                    }
                }

            
                
            }
            catch { print("error", error) }
        }

    }
    
    func TargetString(_ target: Int) {
        
        //let max = 100
        
        print("Text count: ", self.ReaderBook.text.count)
        

        
        if target > 30 {
            
            let array = self.ReaderBook.text[(target-50)...(target+100)]
            
            self.TargetTextArray.append(contentsOf: array)
        } else {
            
            let array = self.ReaderBook.text[(target)...(target+140)]
            
            self.TargetTextArray.append(contentsOf: array)
            
        }
    }
    
}
