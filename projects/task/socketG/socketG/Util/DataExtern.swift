//
//  Extern.swift
//  socketD
//
//  Created by Jz D on 2020/4/23.
//  Copyright © 2020 Jz D. All rights reserved.
//

import AppKit



extension Data{
    
    static let start: Data = {() -> Data in
        if let d = "start".data(using: String.Encoding.ascii){
            return d
        }
        fatalError("Data start")
    }()
    
    static let dummy: Data = {() -> Data in
        if let d = "dummy".data(using: String.Encoding.ascii){
            return d
        }
        fatalError("Data dummy")
    }()
    
    
    
}


extension String{
    static let dummy = "嗯嗯"
}



extension URL{
    static var dir: URL?{
        var pathURL: URL? = nil
        let path = "/Users/\(NSUserName())/Downloads/socketPlay"
        if let url = URL(string: path){
            if FileManager.default.fileExists(atPath: path) == false{
                do {
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                } catch{
                    print(error)
                }
            }
            pathURL = url
        }
        return pathURL
    }
    
    
    
    static var src: URL?{
        var pathURL: URL? = nil
        if let url = URL.dir{
            pathURL = url.appendingPathComponent("prefer.plist")
        }
        return pathURL
    }
    
    
    var file: String{
        absoluteString.replacingOccurrences(of: "file://", with: "")
    }
    
}




extension NSUserInterfaceItemIdentifier{

    static let contentFile = NSUserInterfaceItemIdentifier(rawValue: "content_file")
    
    
}




