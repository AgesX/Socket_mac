//
//  JoinCtrl.swift
//  socketG
//
//  Created by Jz D on 2020/4/26.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa


protocol JoinListCtrlDelegate: class{

    func didJoinTask(c controller: JoinCtrl, on socket: GCDAsyncSocket)
}




class JoinCtrl: NSViewController {
    
    var services = [NetService]()
    var socket: GCDAsyncSocket?
    var serviceBrowser: NetServiceBrowser?
    
    weak var delegate: JoinListCtrlDelegate?
    
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加入者"

        tableView.delegate = self
        tableView.dataSource = self
        
        // Start Browsing
        startBrowsing()
        NotificationCenter.default.addObserver(self, selector: #selector(didSelect(row:)), name: NSTableView.selectionDidChangeNotification, object: tableView)
        
    }
    
    

    override func viewWillDisappear() {
        super.viewWillDisappear()
        cancel()
    }
    
    

    @objc
    func didSelect(row noti: NSNotification){
        if let tb = noti.object as? NSTableView{
            let row = tb.selectedRow
            
            // Fetch Service
            let service = services[row]
            service.delegate = self;
            // 点击，服务就 gg
            service.resolve(withTimeout: 30.0)
        }
        
    }
    
    
      func cancel(){
          stopBrowsing()
      }
      
      

      func startBrowsing(){
          services = []
       
          // Initialize Service Browser
          serviceBrowser = NetServiceBrowser()
       
          // Configure Service Browser
          serviceBrowser?.delegate = self
          serviceBrowser?.searchForServices(ofType: "_deng._tcp.", inDomain: "local.")
      }

      
    
    func stopBrowsing(){
        serviceBrowser?.stop()
        serviceBrowser?.delegate = nil
        serviceBrowser = nil
    }

    
    
}




extension JoinCtrl: NetServiceDelegate, NetServiceBrowserDelegate{
    
    
    
    func connectWith(service s: NetService) -> Bool{
        var isConnected = false
     
        // Copy Service Addresses
        guard let addresses = s.addresses else{
            return false
        }
        
        var condition = false
        
        if let ss = socket{
            if ss.isConnected == false{
                condition = true
            }
            else{
                isConnected = ss.isConnected
            }
        }
        if socket == nil || condition{
            
            // Initialize Socket
            
            socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
            
            // Connect
            while isConnected == false, addresses.count > 0 {
                let address = addresses[0]
                
                do {
                    if let sss = socket{
                        try sss.connect(toAddress: address)
                        // 结果 bool ,
                        //  就是 ok,
                        //  不 ok, 顺带 error 信息
                        isConnected = true
                    }
                } catch {
                    print("Unable to connect to address. Error \(error) with user info ")
                }
            }
        }
     
        return isConnected;
    }



    
    
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        
        
        // Update Services
        services.append(service)
     
        if !moreComing{
            // Sort Services
            services.sort { (lhs, rhs) -> Bool in
                lhs.name > rhs.name
            }
            // Update Table View
            tableView.reloadData()
        }
    }


    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        // Update Services
        if let index = services.firstIndex(where: {  (s) -> Bool in
            s == service
        }){
             services.remove(at: index)
        }
      
        if !moreComing{
            // Update Table View
            tableView.reloadData()
        }
    }


    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        stopBrowsing()
        
    }



    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        stopBrowsing()
        
    }

    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        sender.delegate = nil
    }


    func netServiceDidResolveAddress(_ sender: NetService) {

        // Connect With Service
     
        if connectWith(service: sender){
            print("Did Connect with Service:  domain(\(sender.domain)) type(\(sender.type)) name(\(sender.name)) port(\(sender.port)")
        }
        else{
            print("Unable to Connect with Service:  domain(\(sender.domain)) type(\(sender.type)) name(\(sender.name)) port(\(sender.port)")
        }
    }


  
}


extension JoinCtrl: GCDAsyncSocketDelegate{
    
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {

           print("Socket Did Connect to Host: \(host) Port: \(port)")
        
           // Notify Delegate
           delegate?.didJoinTask(c: self, on: sock)

           // Stop Browsing
           stopBrowsing()
        
           // Dismiss View Controller
           dismiss()
    }



}




extension JoinCtrl: NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return services.count
    }
    
    
}



extension JoinCtrl: NSTableViewDelegate{
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSTextField()
        cell.stringValue = services[row].name
        return cell
    }
    
    
}



