//
//  Extern.swift
//  socketD
//
//  Created by Jz D on 2020/4/23.
//  Copyright © 2020 Jz D. All rights reserved.
//

import AppKit




extension Array {
    public subscript(index: UInt) -> Element {
        get{
            return self[Int(index)]
        }
        set{
            self[Int(index)] = newValue
        }
    }
}



public func / (left: CGFloat, right: Int) -> CGFloat {
    return left/CGFloat(right)
}


public func * (left: CGFloat, right: Int) -> CGFloat {
    return left * CGFloat(right)
}


public func * (left: Int, right: CGFloat) -> CGFloat {
    return CGFloat(left) * right
}



extension NSViewController{
    
    func dismiss(){
        // Dismiss View Controller
        if let p = presentingViewController{
            p.dismiss(self)
        }
        else{
            view.window?.close()
        }
    }
}
