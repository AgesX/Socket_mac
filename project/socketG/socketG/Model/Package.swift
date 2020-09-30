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
    static let kind = "kind"
}


class Package: NSObject{


    let data: Data?
    let type: PacketType
    let word: String?
    
    let name: String?
    let toTheEnd: Bool
    let kind: Int

    
    init(package info: Data, type t: PacketType){
        data = info
        type = t
        word = nil
        
        name = nil
        toTheEnd = false
        kind = 1
        super.init()
    }
    
    
    init(message info: String){
        data = nil
        type = PacketType.sendData
        word = info
        
        name = nil
        toTheEnd = false
        kind = 2
        super.init()
    }
    
    init(buffer info: Data, name n: String?, to theEnd: Bool){
        data = info
        type = PacketType.sendData
        word = nil
        
        name = n
        toTheEnd = theEnd
        kind = 3
        super.init()
    }
    
    
    
    init(buffer info: Data, name n: String?, pNode p: String?, to theEnd: Bool){
        data = info
        type = PacketType.sendData
        
        word = p // 记录父子绑定关系
        
        name = n
        toTheEnd = theEnd
        kind = 4
        super.init()
    }
    

    required init?(coder: NSCoder) {
        data = coder.decodeObject(forKey: PacketKey.data) as? Data
        type = PacketType(rawValue: coder.decodeInteger(forKey: PacketKey.type)) ?? PacketType.default
        word = coder.decodeObject(forKey: PacketKey.word) as? String
        
        name = coder.decodeObject(forKey: PacketKey.name) as? String
        toTheEnd = coder.decodeBool(forKey: PacketKey.toTheEnd)
        kind = coder.decodeInteger(forKey: PacketKey.kind)
    }
    
}


extension Package: NSCoding, NSSecureCoding{
    
    
    
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: PacketKey.data)
        coder.encode(type.rawValue, forKey: PacketKey.type)
        coder.encode(word, forKey: PacketKey.word)
        
        coder.encode(name, forKey: PacketKey.name)
        coder.encode(toTheEnd, forKey: PacketKey.toTheEnd)
        coder.encode(kind, forKey: PacketKey.kind)
    }
    
    
    
    
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
    
    
    
    
}
