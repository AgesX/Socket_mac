//
//  BoardV.swift
//  socketG
//
//  Created by Jz D on 2020/4/26.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa


protocol BoardVProxy: class{
    func click(event e: NSEvent)

}


class BoardV: NSView {
    
    
    weak var delegate: BoardVProxy?
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
