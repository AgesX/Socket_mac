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




extension NSViewController{
    
    func dismiss(){
        // Dismiss View Controller
        if let p = presentingViewController{
            p.dismiss(self)
        }
        else{
            view.window?.close()
        }
    }
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
    
}
