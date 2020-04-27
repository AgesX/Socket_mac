//
//  AppDelegate.swift
//  socketG
//
//  Created by Jz D on 2020/4/15.
//  Copyright © 2020 Jz D. All rights reserved.
//
 
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let window = NSApplication.shared.windows[0]
        if let s = window.screen{
            let xPos = (s.frame.width - window.frame.width) * 0.5
            let yPos = (s.frame.height - window.frame.height) * 0.5
            window.setFrame(NSRect(x: xPos, y: yPos, width: window.frame.width, height: window.frame.height), display: true)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

