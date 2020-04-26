//
//  GameManager.swift
//  socketD
//
//  Created by Jz D on 2020/4/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


protocol GameManagerProxy: class{
    
    
    func didAddDisc(manager: GameManager, to column: UInt)
    func didDisconnect(manager: GameManager)
    func didStartNewGame(manager: GameManager)

}


struct Tag {
    static let head = 0
    static let body = 1
}


class GameManager : NSObject{
    

    weak var delegate: GameManagerProxy?

    var socket: GCDAsyncSocket
    
    
    init(socket s: GCDAsyncSocket){
        socket = s
        super.init()
        socket.delegate = self
        socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: Tag.head)
    }


    func startNewGame(){
        let packet = PacketH(info: ["1": 1], type: .startNewGame, action: .go)
        send(packet: packet)
    }



    
    func send(packet p: PacketH){
        
        
             // packet to buffer
             // 包，到 缓冲
               
             // Encode Packet Data

             do {
                 let encoded = try NSKeyedArchiver.archivedData(withRootObject: p, requiringSecureCoding: false)
                 
                 // Initialize Buffer
                 let buffer = NSMutableData()
             
                // buffer = header + packet
                
                // Fill Buffer
                 var headerLength = encoded.count
                
                 buffer.append(&headerLength, length: MemoryLayout<UInt64>.size)
                 encoded.withUnsafeBytes { (p) in
                     let bufferPointer = p.bindMemory(to: UInt8.self)
                     if let address = bufferPointer.baseAddress{
                         buffer.append(address, length: headerLength)
                     }
                 }
                 

                // Write Buffer
                 if let d = buffer.copy() as? Data{
                     socket.write(d, withTimeout: -1.0, tag: 0)
                 }
                 
                 
             } catch {
                 print(error)
             }
             
             
    }

    
    func parse(header data: NSData) -> UInt{
        var headerLength: UInt = 0
        data.getBytes(&headerLength, length: MemoryLayout<UInt>.size)
        return headerLength
    }


    
    func parse(body data: Data){
        do {
            NSKeyedUnarchiver.setClass(PacketH.self, forClassName: "PacketH")
            let packet = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, PacketH.self], from: data) as! PacketH
             
               print("Packet Data > \(packet.data)")
               print("Packet Type > \(packet.type)")
               print("Packet Action > \(packet.action)")
            
               // 落子了
               if packet.type == .didAddDisc{
                    if let dic = packet.data as? [String: UInt], let column = dic["column"]{
                        delegate?.didAddDisc(manager: self, to: column)
                    }
               }
               else if packet.type == .startNewGame{

                     // 这里真的走了，  点击 replay 的时候
                   // 新开一局
                   // Notify Delegate
                    delegate?.didStartNewGame(manager: self)
               }
            
            
        } catch {
            print(error)
        }
        
    }




 
    

    func addDiscTo(column c: UInt){
        // Send Packet
        let load = ["column": c]
        let packet = PacketH(info: load, type: .didAddDisc, action: .go)
        send(packet: packet)
    }


    
}



extension GameManager: GCDAsyncSocketDelegate{


    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
 
        if tag == 0{
            let d = NSData(data: data)
            let bodyLength = parse(header: d)
            socket.readData(toLength: bodyLength, withTimeout: -1.0, tag: 1)
        } else if (tag == 1) {
            parse(body: data)
            socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: 0)
        }
    }


    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {

        
        if socket == sock{
            socket.delegate = nil;
        }
     
        // Notify Delegate
        delegate?.didDisconnect(manager: self)
    }





}
