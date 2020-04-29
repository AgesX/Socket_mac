//
//  BoardCell.swift
//  socketG
//
//  Created by Jz D on 2020/4/26.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa


enum BoardCellType: Int{
    case empty = -1, mine = 0, yours = 1
}





class BoardCell: NSView {

    var _cellType = BoardCellType.empty
     
     
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         wantsLayer = true
     }
     
     required init?(coder: NSCoder) {
         fatalError()
     }
     
     var cellType: BoardCellType{
         get{
             return _cellType
         }
         set{
             if _cellType != newValue{
                 _cellType = newValue
                 switch newValue {
                 case .mine:
                     layer?.backgroundColor = NSColor.yellow.cgColor
                 case .yours:
                     layer?.backgroundColor = NSColor.red.cgColor
                 default :
                     //  .empty
                     layer?.backgroundColor = NSColor.white.cgColor
                 }
             }
         }
     }
     
     
   
    
    override var wantsUpdateLayer: Bool{
        return true
    }
}
