//
//  Extern.swift
//  socketD
//
//  Created by Jz D on 2020/4/23.
//  Copyright © 2020 Jz D. All rights reserved.
//

import AppKit



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


