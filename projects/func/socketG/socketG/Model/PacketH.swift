//
//  PacketH.swift
//  socketD
//
//  Created by Jz D on 2020/4/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


enum PacketType: Int{
    case unknown = -1, didAddDisc, startNewTask
}


enum PacketAction: Int{
    case unknown = -1
    case go = 0
}




struct PacketKey {
    static let data = "data"
    static let type = "type"
    static let action = "action"
}


class PacketH: NSObject{


    let data: Any
    let type: PacketType
    let action: PacketAction
    

    
    init(info d: Any, type t: PacketType, action a: PacketAction){
        data = d
        type = t
        action = a
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        data = coder.decodeObject(forKey: PacketKey.data) ?? [:]
        type = PacketType(rawValue: coder.decodeInteger(forKey: PacketKey.type)) ?? PacketType.unknown
        action = PacketAction(rawValue: coder.decodeInteger(forKey: PacketKey.action)) ?? PacketAction.unknown
    }
    
}


extension PacketH: NSCoding, NSSecureCoding{
    
    
    
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: PacketKey.data)
        coder.encode(type.rawValue, forKey: PacketKey.type)
        coder.encode(action.rawValue, forKey: PacketKey.action)
    }
    
    
    
    
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
    
    
    
    
}
