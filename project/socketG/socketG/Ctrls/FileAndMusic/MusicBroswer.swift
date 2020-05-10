//
//  MusicBroswer.swift
//  socketG
//
//  Created by Jz D on 2020/5/4.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa


protocol MusicBroswerDelegate: class{
    func didSend(data url: URL)
}


class MusicBroswer: NSViewController {
    
    weak var delegate: MusicBroswerDelegate?
    
    @IBOutlet weak var table: NSTableView!
    
    var files = [URL]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        title = "本地指定文件夹，音乐浏览"
        view.frame = NSRect(x: 0, y: 0, width: 500, height: 400)
        table.delegate = self
        table.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(MusicBroswer.didSelectRow(_:)), name: NSTableView.selectionDidChangeNotification, object: table)
        
        
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        files.removeAll()
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
    
    
    
    @objc
    func didSelectRow(_ noti: Notification){
        guard let table = noti.object as? NSTableView else {
            return
        }
        let row = table.selectedRow
        assert(row >= 0, "不能选个负数")
        delegate?.didSend(data: files[row])
        
        
        
        
        ///
        let alert = NSAlert()
        alert.messageText = "选中即发送"
        alert.informativeText = "发送啦"
        alert.addButton(withTitle: "嗯嗯")
        alert.alertStyle = .warning
        if let w = view.window{
            alert.beginSheetModal(for: w) { (returnCode: NSApplication.ModalResponse) in
                if returnCode == .alertFirstButtonReturn{
                    print("ok")
                }
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
        cell.isEditable = false
        //  let cell = tableView.makeView(withIdentifier: .contentFile, owner: self) as! NSTableCellView
        let attribute = [NSAttributedString.Key.foregroundColor: NSColor.red, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 25)]
        let attrString = NSAttributedString(string: files[row].lastPathComponent, attributes: attribute)
        cell.attributedStringValue = attrString
        //  cell.textField?.attributedStringValue = attrString
        return cell
    }
    
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    
}



