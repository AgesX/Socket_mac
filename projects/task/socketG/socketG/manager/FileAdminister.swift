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
    var beyond: Bool
    let stride: Int
    
    var rest: Int
    
    init(url src: URL) {
        
        handler = FileHandle(forReadingAtPath: src.file)
        print(src.file)
        assert(FileHandle(forReadingAtPath: src.file) != nil, "handler 初始化出错")
        
        var len = 0
        if let data = NSData(contentsOfFile: src.file){
            len = data.length
        }
        length = UInt64(len)
        name = src.lastPathComponent
        
        offset = 0
        tillEnd = false
        beyond = false
        stride = 1024 * 200
        
        rest = 0
    }
    
    
    mutating
    func offsetForward(){
        offset += UInt64(stride)
        print("进度:")
        print(Double(offset)/Double(length))
        print("\n\n")
        //  一次 200 k B
        if offset >= length{
            tillEnd = true
            rest = stride - Int(offset - length)
        }
    }
}



