//
//  Package.swift
//  socketD
//
//  Created by Jz D on 2020/4/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


enum PacketType: Int{
    case `default` = -1, sendData, start
}



struct PacketKey {
    static let data = "data"
    static let type = "type"
    static let word = "word"
    
    static let name = "name"
    static let toTheEnd = "toTheEnd"
}


class Package: NSObject{


    let data: Data?
    let type: PacketType
    let word: String?
    
    let name: String?
    let toTheEnd: Bool


    
    init(package info: Data, type t: PacketType){
        data = info
        type = t
        word = nil
        
        name = nil
        toTheEnd = false
        super.init()
    }
    
    
    init(message info: String){
        data = nil
        type = PacketType.sendData
        word = info
        
        name = nil
        toTheEnd = false
        super.init()
    }
    
    init(buffer info: Data, name n: String?, to theEnd: Bool){
        data = info
        type = PacketType.sendData
        word = nil
        
        name = n
        toTheEnd = theEnd
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        data = coder.decodeObject(forKey: PacketKey.data) as? Data
        type = PacketType(rawValue: coder.decodeInteger(forKey: PacketKey.type)) ?? PacketType.default
        word = coder.decodeObject(forKey: PacketKey.word) as? String
        
        name = coder.decodeObject(forKey: PacketKey.name) as? String
        toTheEnd = coder.decodeBool(forKey: PacketKey.toTheEnd)
    }
    
}


extension Package: NSCoding, NSSecureCoding{
    
    
    
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: PacketKey.data)
        coder.encode(type.rawValue, forKey: PacketKey.type)
        coder.encode(word, forKey: PacketKey.word)
        
        coder.encode(name, forKey: PacketKey.name)
        coder.encode(toTheEnd, forKey: PacketKey.toTheEnd)
    }
    
    
    
    
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
    
    
    
    
}
