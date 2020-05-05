//
//  Package.swift
//  socketD
//
//  Created by Jz D on 2020/4/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation



private
struct HeaderK {
    static let length = "length"
    static let tag = "tag"
}


class Header: NSObject{


    let length: Int
    let tag: Int
    
    init(length count: Int, tag t: Int){
        length = count
        tag = t
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        length = coder.decodeInteger(forKey: HeaderK.length)
        
        tag = coder.decodeInteger(forKey: HeaderK.tag)
    }
    
}


extension Header: NSCoding, NSSecureCoding{
    
    func encode(with coder: NSCoder) {
        coder.encode(length, forKey: HeaderK.length)
        coder.encode(tag, forKey: HeaderK.tag)
    
    }
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
}
