//
//  TaskManagerAdd.swift
//  socketG
//
//  Created by Jz D on 2020/9/30.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa
import Foundation

struct SoundSrc {
    static let kinds = ["mp3", "m4a", "txt", "wav"]
}




extension TaskManager{
    
    
    func send(folder url: URL){
        do {
            let properties: [URLResourceKey] = [ URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
            let paths = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            for url in paths{
                let isDirectory = (try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false
                if isDirectory{
                    ()
                } else if SoundSrc.kinds.contains(url.pathExtension){
                    sources.append(url)
                }
            }
        } catch let error{
            print("error: \(error.localizedDescription)")
        }

        
    }
    
    
    
    
    
    
    
    func sendInFolder(){
        let beyond: Bool = fileAdmin?.beyond ?? true
        let toTheEnd: Bool = fileAdmin?.tillEnd ?? true
        guard beyond == false else {
            stopSendingFile()
            return
        }
        if toTheEnd{
            fileAdmin?.beyond = true
        }
        do {
            try fileAdmin?.handler?.seek(toOffset: fileAdmin?.offset ?? 0)
            fileAdmin?.offsetForward()
            var blockLength = fileAdmin?.stride ?? 0
            if toTheEnd{
                blockLength = fileAdmin?.rest ?? 0
            }
            guard let body = fileAdmin?.handler?.readData(ofLength: blockLength) else{
                return
            }
            let packet = Package(buffer: body, name: fileAdmin?.name, pNode: fileAdmin?.dir, to: toTheEnd)
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
                socket.write(d, withTimeout: -1.0, tag: Tag.folder.rawValue)
            }
            
        }catch{
            print(error)
        }
           
    }
    
    
}
