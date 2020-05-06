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
    let stride: Int
    
    init(url src: URL) {
        
        handler = FileHandle(forReadingAtPath: src.file)
        assert(FileHandle(forReadingAtPath: src.file) != nil, "handler 初始化出错")
        var len = 0
        if let data = NSData(contentsOfFile: src.absoluteString){
            len = data.length
        }
        length = UInt64(len)
        name = src.lastPathComponent
        
        offset = 0
        tillEnd = false
        stride = 1024 * 200
    }
    
    
    mutating
    func offsetForward(){
        offset += UInt64(stride)
        //  一次 200 k B
        if offset >= length{
            tillEnd = true
        }
    }
}



