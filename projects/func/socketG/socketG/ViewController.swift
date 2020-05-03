//
//  ViewController.swift
//  socketG
//
//  Created by Jz D on 2020/4/15.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    

    var gameManager: GameManager?

    
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
            
          
          disconnectBtn.isHidden = true
      }
    
    
    
    
    
      
    
    
    // MARK: game relevant

    func startGame(with socket: GCDAsyncSocket){
        // Initialize Game Controller
        gameManager = GameManager(socket: socket)
        gameManager?.delegate = self
     

        // Hide/Show Buttons
        sendDataButton.isHidden = false
        hostBtn.isHidden = true
        
        joinBtn.isHidden = true
        disconnectBtn.isHidden = false
    }
    
    
    func endGame(){
        
        // Clean Up
        gameManager?.delegate = nil
        gameManager = nil
               
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
    
    
    
    @IBAction func joinGame(_ sender: NSButton) {
        let vc = JoinCtrl(nibName: nil, bundle: nil)
        vc.delegate = self
        presentAsModalWindow(vc)
        
    }
    
    
    @IBAction func disconnectIt(_ sender: NSButton) {
        endGame()
    }
    
    
    
    
    @IBAction func sendData(_ sender: NSButton) {
        
    }
    
}



// MARK: 15
extension ViewController: HostViewCtrlDelegate{
    func didHostGame(c controller: HostCtrl, On socket: GCDAsyncSocket) {
       
        startGame(with: socket)
    }
    
    
    func didCancelHosting(c controller: HostCtrl) {
        print("\(#file), \(#function)")
    }
    
}




extension ViewController: JoinListCtrlDelegate{
    
    func didJoinGame(c controller: JoinCtrl, on socket: GCDAsyncSocket) {
   
        startGame(with: socket)
    }
    
    func didCancelJoining(c controller: JoinCtrl) {
        print("\(#file), \(#function)")
    }
    
}




extension ViewController: GameManagerProxy{
    func didDisconnect(manager: GameManager) {
        endGame()
    }
    

    func didStartNewGame(manager: GameManager) {
      
    }
    

    
    
    func didAddDisc(manager: GameManager, to column: UInt) {
        
       
    }
}



extension ViewController{
    
    
}
