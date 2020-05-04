//
//  MusicBroswer.swift
//  socketG
//
//  Created by Jz D on 2020/5/4.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa

class MusicBroswer: NSViewController {
    
    
    
    @IBOutlet weak var table: NSTableView!
    
    var files = [URL]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        title = "本地指定文件夹，音乐浏览"

        table.delegate = self
        table.dataSource = self

        
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let src = URL.dir{
            do {
                let properties: [URLResourceKey] = [ URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
                let paths = try FileManager.default.contentsOfDirectory(at: src, includingPropertiesForKeys: properties, options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
                for url in paths{
                    let isDirectory = (try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false
                    let musicExtern = ["mp3", "m4a"]
                    if isDirectory == false, musicExtern.contains(url.pathExtension){
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





extension MusicBroswer: NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
    
    
}



extension MusicBroswer: NSTableViewDelegate{
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSTextField()

        let attributeCut = [NSAttributedString.Key.foregroundColor: NSColor.red, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 25)]
        let attrStringCut = NSAttributedString(string: files[row].lastPathComponent, attributes: attributeCut)
        cell.attributedStringValue = attrStringCut
        
        return cell
    }
    
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 32
    }
    
    
}



