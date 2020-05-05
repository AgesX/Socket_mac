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


private
struct PacketKey {
    static let data = "data"
    static let type = "type"
}


class Package: NSObject{


    let data: Data
    let type: PacketType
    
    init(data packet: Data, type t: PacketType){
        data = packet
        type = t
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        let datum = coder.decodeObject(forKey: PacketKey.data) as? Data
        data = datum ?? Data.dummy
        
        type = PacketType(rawValue: coder.decodeInteger(forKey: PacketKey.type)) ?? PacketType.default

    }
    
}


extension Package: NSCoding, NSSecureCoding{
    
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: PacketKey.data)
        coder.encode(type.rawValue, forKey: PacketKey.type)
    
    }
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
}
