//
//  HostCtrl.swift
//  socketG
//
//  Created by Jz D on 2020/4/26.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa



protocol HostViewCtrlDelegate: class{
    func didHostGame(c controller: HostCtrl, On socket: GCDAsyncSocket)
    func didCancelHosting(c controller: HostCtrl)
}



class HostCtrl: NSViewController {
    
    
    weak var delegate: HostViewCtrlDelegate?
    
    var service: NetService?
    var socket: GCDAsyncSocket?
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
          title = "主机";
          
          startBroadcast()
      }
      


    override func viewWillDisappear() {
        super.viewWillDisappear()
        cancel()
    }
      
      
      func cancel(){
          delegate?.didCancelHosting(c: self)
          endBroadcast()
      }



      
      
      func startBroadcast(){
          // Initialize GCDAsyncSocket
          socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
          do {
              try socket?.accept(onPort: 0)
              service = NetService(domain: "local.", type: "_deng._tcp.", name: "", port: Int32(socket?.localPort ?? 0))
              service?.delegate = self
              service?.publish()
          } catch{
              print("Unable to create socket. Error \(error) with user info .")
          }

      }

    
    func endBroadcast(){
        socket?.setDelegate(nil, delegateQueue: nil)
        socket = nil
        
        service?.delegate = nil
        service = nil
    }
}






extension HostCtrl: NetServiceDelegate{
    
    
    func netServiceWillPublish(_ sender: NetService) {
        print("∑  ø  Bonjour sender Published: domain(\(sender.domain)) type(\(sender.type)) name(\(sender.name)) port(\(sender.port)")
    }
    
    
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to Publish sender: domain(\(sender.domain)) type(\(sender.type)) name(\(sender.name)) port(\(sender.port)")
    }
}


extension HostCtrl: GCDAsyncSocketDelegate{
    
    
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {

        
        print("Accepted New Socket from \(sock.connectedHost): \(sock.connectedPort)")
        delegate?.didHostGame(c: self, On: newSocket)
        endBroadcast()
        dismiss()
    }



}
