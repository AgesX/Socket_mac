//
//  FileAdminister.swift
//  socketG
//
//  Created by Jz D on 2020/5/5.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation




struct FileAdminister {
    let handler: FileHandle?
    let length: UInt64
    let name: String
    
    var offset: UInt64
    var tillEnd: Bool
    
    init(url src: URL) {
        handler = FileHandle(forReadingAtPath: src.absoluteString)
        var len = 0
        if let data = NSData(contentsOfFile: src.absoluteString){
            len = data.length
        }
        length = UInt64(len)
        name = src.lastPathComponent
        
        offset = 0
        tillEnd = false
    }
    
    
    mutating
    func offsetForward(){
        offset += 1024 * 200
        //  一次 200 k B
        if offset >= length{
            tillEnd = true
        }
    }
}



