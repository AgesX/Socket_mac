//
//  StringAdd.swift
//  socketG
//
//  Created by Jz D on 2020/10/1.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


extension String {

    func range(_ inner: String) -> NSRange{
        return (self as NSString).range(of: inner)
    }

}



extension NSMutableAttributedString{
    var cp: NSAttributedString?{
        return copy() as? NSAttributedString
    }
    
    
}
