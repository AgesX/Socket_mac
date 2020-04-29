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
    

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    func setup(){
        
        wantsLayer = true
        needsDisplay = true
        layer?.backgroundColor = NSColor.brown.cgColor
        layer?.borderColor = NSColor.yellow.cgColor;
        layer?.borderWidth = 2;
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    override func mouseUp(with event: NSEvent) {
        delegate?.click(event: event)
    }
    
    
    override var acceptsFirstResponder: Bool{
        return true
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override var isFlipped: Bool{
        return true
    }
    
    
}
