//
//  MusicBroswer.swift
//  socketG
//
//  Created by Jz D on 2020/5/4.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa




class InnerBroswer: NSViewController {
    
    weak var delegate: MusicBroswerDelegate?
    
    @IBOutlet weak var table: NSTableView!
    
    var files = [URL]()
    
    var source: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        
        view.frame = NSRect(x: 0, y: 0, width: 500, height: 400)
        table.delegate = self
        table.dataSource = self

        
        
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        files.removeAll()
        if let src = source{
            title = src.lastPathComponent
            do {
                let properties: [URLResourceKey] = [ URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
                let paths = try FileManager.default.contentsOfDirectory(at: src, includingPropertiesForKeys: properties, options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
                for url in paths{
                    let isDirectory = (try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false
                    let musicExtern = SoundSrc.kinds
                    if isDirectory{
                        ()
                    } else if musicExtern.contains(url.pathExtension){
                        files.append(url)
                    }
                }
                table.reloadData()
            } catch let error{
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    
}





extension InnerBroswer: NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
    
    
}



extension InnerBroswer: NSTableViewDelegate{
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        

         let cell = NSTextField()
         cell.isEditable = false
        
         let attribute = [NSAttributedString.Key.foregroundColor: NSColor.red, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 25)]
         let attrString = NSAttributedString(string: files[row].lastPathComponent, attributes: attribute)
         cell.attributedStringValue = attrString
         return cell
    }
    
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
        
    }
    
    
}



