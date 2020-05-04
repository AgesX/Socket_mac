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
