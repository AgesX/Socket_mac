//
//  URL_add.swift
//  socketG
//
//  Created by Jz D on 2020/10/1.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation



extension URL{
    
    var dir: String{
        let dir = deletingLastPathComponent()
        return dir.lastPathComponent
    }
    
    
    
    
}
