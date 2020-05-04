//
//  ViewController.swift
//  socketG
//
//  Created by Jz D on 2020/4/15.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    

    var taskAdmin: TaskManager?

    
    @IBOutlet weak var hostBtn: NSButton!
    @IBOutlet weak var joinBtn: NSButton!
    @IBOutlet weak var disconnectBtn: NSButton!
    
    
    @IBOutlet weak var sendDataButton: NSButton!
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

          
          // Configure Subviews
          let sendData = "send data"
          let attribute = [NSAttributedString.Key.foregroundColor: NSColor.blue]
          let attrString = NSAttributedString(string: sendData, attributes: attribute)
          // assign it to the button
          sendDataButton.attributedTitle = attrString
        
          sendDataButton.isHidden = true
            
          
          let cut = "断开"
          let attributeCut = [NSAttributedString.Key.foregroundColor: NSColor.red]
          let attrStringCut = NSAttributedString(string: cut, attributes: attributeCut)
          disconnectBtn.attributedTitle = attrStringCut
          disconnectBtn.isHidden = true
      }
    
    
    
    
    
      
    
    
    // MARK: Task relevant

    func startTask(with socket: GCDAsyncSocket){
        // Initialize Task Controller
        taskAdmin = TaskManager(socket: socket)
        taskAdmin?.delegate = self
     

        // Hide/Show Buttons
        sendDataButton.isHidden = false
        hostBtn.isHidden = true
        
        joinBtn.isHidden = true
        disconnectBtn.isHidden = false
    }
    
    
    func endTask(){
        
        // Clean Up
        taskAdmin?.delegate = nil
        taskAdmin = nil
               
        // Hide/Show Buttons
        sendDataButton.isHidden = true
        hostBtn.isHidden = false
        
        joinBtn.isHidden = false
        disconnectBtn.isHidden = true
        
    }
    


    
    @IBAction func host(_ sender: NSButton) {
        let vc = HostCtrl(nibName: nil, bundle: nil)
        vc.delegate = self
        presentAsModalWindow(vc)
        
    }
    
    
    
    @IBAction func joinTask(_ sender: NSButton) {
        let vc = JoinCtrl(nibName: nil, bundle: nil)
        vc.delegate = self
        presentAsModalWindow(vc)
        
    }
    
    
    @IBAction func disconnectIt(_ sender: NSButton) {
        endTask()
    }
    
    
    
    
    @IBAction func sendData(_ sender: NSButton) {
        
    }
    
    
    @IBAction func openFile(_ sender: NSButton){
        let path = "/Users/\(NSUserName())/Downloads/socketPlay/"
        print(path)
        if let url = URL(string: path){
            
            if FileManager.default.fileExists(atPath: path) == false{
                do {
                    print(1)
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch{
                    print(2)
                    print(error)
                }
            }
            else{
                print(3)
            }
          //  NSWorkspace.shared.open(url)
        }
        
    }
    
    
    
    
}



// MARK: 15
extension ViewController: HostViewCtrlDelegate{
    func didHostTask(c controller: HostCtrl, On socket: GCDAsyncSocket) {
       
        startTask(with: socket)
    }
    
    
    func didCancelHosting(c controller: HostCtrl) {
        print("\(#file), \(#function)")
    }
    
}




extension ViewController: JoinListCtrlDelegate{
    
    func didJoinTask(c controller: JoinCtrl, on socket: GCDAsyncSocket) {
   
        startTask(with: socket)
    }
    
    func didCancelJoining(c controller: JoinCtrl) {
        print("\(#file), \(#function)")
    }
    
}




extension ViewController: TaskManagerProxy{
    func didDisconnect(manager: TaskManager) {
        endTask()
    }
    

    func didStartNewTask(manager: TaskManager) {
      
    }
    

    func didReceive(packet data: Data, by manager: TaskManager) {
        
        do {
            let dict = try PropertyListSerialization.propertyList(from:data, format: nil) as! [String:Any]
            print(dict)
        } catch {
            print(error)
        }
        
    }
}



extension ViewController{
    
    
}
