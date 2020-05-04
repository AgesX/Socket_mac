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
        
        /*
        NSFileManager       *fm = [NSFileManager defaultManager];
        NSURL               *downloadsURL;

        downloadsURL = [fm URLForDirectory:NSDownloadsDirectory
                           inDomain:NSUserDomainMask appropriateForURL:nil
                           create:YES error:nil];
        */
        
        
        
        
        let path = "/Users/\(NSUserName())/Downloads/socketPlay/)"
        print(path)
        if let src = URL(string: path){
            
            if FileManager.default.fileExists(atPath: path) == false{
                do {
                    
                    let url = try FileManager.default.url(for: FileManager.SearchPathDirectory.downloadsDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
                    
                    
                    if FileManager.default.fileExists(atPath: path) == false{
                        print(url.path)
                        print(1)
                    
                        try FileManager.default.createDirectory(atPath: "/My/Custom/Path", withIntermediateDirectories: true, attributes: nil)
                        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                        NSWorkspace.shared.open(url)
                    }
                    else{
                        print(2___)
                    }
                } catch{
                    print(2)
                    print(error)
                }
            }
            else{
                print(3)
            }
          
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
