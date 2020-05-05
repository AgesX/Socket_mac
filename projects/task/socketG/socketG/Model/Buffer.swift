//
//  Buffer.swift
//  socketG
//
//  Created by Jz D on 2020/5/5.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation



private
struct BufferK{
    static let data = "data"
    static let name = "name"
    static let toTheEnd = "toTheEnd"
    
}



class Buffer: NSObject{

    let data: Data
    let name: String
    let toTheEnd: Bool
    
    init(_ name: String, buffer packet: Data, to theEnd: Bool){
        self.name = name
        data = packet
        toTheEnd = theEnd
        
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        let datum = coder.decodeObject(forKey: BufferK.data) as? Data
        data = datum ?? Data.dummy
        
        let n = coder.decodeObject(forKey: BufferK.name) as? String
        name = n ?? String.dummy
        
        toTheEnd = coder.decodeBool(forKey: BufferK.toTheEnd)
    }
    
}


extension Buffer: NSCoding, NSSecureCoding{
    
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: BufferK.data)
        coder.encode(name, forKey: BufferK.name)
        coder.encode(toTheEnd, forKey: BufferK.toTheEnd)
    }
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
}
