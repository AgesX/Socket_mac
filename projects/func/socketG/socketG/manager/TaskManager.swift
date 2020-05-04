//
//  TaskManager.swift
//  socketD
//
//  Created by Jz D on 2020/4/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


protocol TaskManagerProxy: class{
    func didReceive(packet data: Data, by manager: TaskManager)
    
    func didDisconnect(manager: TaskManager)
    func didStartNewTask(manager: TaskManager)
}


struct Tag {
    static let head = 0
    static let body = 1
}


class TaskManager : NSObject{
    

    weak var delegate: TaskManagerProxy?

    var socket: GCDAsyncSocket
    
    
    init(socket s: GCDAsyncSocket){
        socket = s
        super.init()
        socket.delegate = self
        socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: Tag.head)
    }


    func startNewTask(){
        let packet = Package(data: Data.start, type: .start)
        send(with: packet)
    }



    fileprivate
    func send(with packet: Package){
        
             // packet to buffer
             // 包，到 缓冲
               
             // Encode Packet Data

             do {
                 let encoded = try NSKeyedArchiver.archivedData(withRootObject: packet, requiringSecureCoding: false)
                 
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
            NSKeyedUnarchiver.setClass(Package.self, forClassName: "socketD.Package")
            //  NSKeyedUnarchiver.setClass(Package.self, forClassName: "socketG.Package")
            NSKeyedUnarchiver.setClass(Package.self, forClassName: "Package")
            let packet = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, Package.self], from: data) as! Package
             
               print("Packet Data > \(packet.data)")
               print("Packet Type > \(packet.type)")
         
               switch packet.type {
                    case .start:
                        delegate?.didStartNewTask(manager: self)
                    case .sendData:
                        delegate?.didReceive(packet: packet.data, by: self)
                    default:
                        ()
               }
            
        } catch {
            print(error)
        }
        
    }

    func send(packet data: Data){
        // Send Packet
        let packet = Package(data: data, type: .sendData)
        send(with: packet)
    }


    
}



extension TaskManager: GCDAsyncSocketDelegate{


    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
 
        switch tag {
        case 0:
            print(1)
            let d = NSData(data: data)
            let bodyLength = parse(header: d)
            socket.readData(toLength: bodyLength, withTimeout: -1.0, tag: 1)
        case 1:
            print(2)
            parse(body: data)
            socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: 0)
        default:
            ()
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

