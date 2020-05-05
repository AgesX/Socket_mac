//
//  Talk.swift
//  socketG
//
//  Created by Jz D on 2020/5/5.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


private
struct TalkK{
    static let word = "word"
}



class Talk: NSObject{

    let word: String
    
    init(word txt: String){
        word = txt
        
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        let w = coder.decodeObject(forKey: TalkK.word) as? String
        word = w ?? String.dummy
        
    }
    
}


extension Talk: NSCoding, NSSecureCoding{
    
    func encode(with coder: NSCoder) {
        coder.encode(word, forKey: TalkK.word)
    
    }
    
    
    static var supportsSecureCoding: Bool {
        true
    }
    
}
