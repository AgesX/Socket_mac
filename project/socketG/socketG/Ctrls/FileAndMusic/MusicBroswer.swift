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


enum SourceOption{
    case file, folder
    
    
    static let row = "row"
    static let kind = "kind"
}

class MusicBroswer: NSViewController {
    
    weak var delegate: MusicBroswerDelegate?
    
    @IBOutlet weak var table: NSTableView!
    
    var files = [URL]()
    var folders = [URL]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        title = "本地指定文件夹，音乐浏览"
        view.frame = NSRect(x: 0, y: 0, width: 500, height: 400)
        table.delegate = self
        table.dataSource = self
        var row = table.selectedRow
        var kind = SourceOption.file
        if row >= folders.count{
            row -= folders.count
            kind = .file
        }
        
        let info: [String : Any] = [SourceOption.row: row,
                                    SourceOption.kind: kind]
        NotificationCenter.default.addObserver(self, selector: #selector(MusicBroswer.didSelectRow(_:)), name: NSTableView.selectionDidChangeNotification, object: info)
        
        
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
                    if isDirectory{
                        folders.append(url)
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
    
    
    
    @objc
    func didSelectRow(_ noti: Notification){
        guard let table = noti.object as? [String : Any], let row = table[SourceOption.row] as? Int, let kind = table[SourceOption.kind] as? SourceOption else {
            return
        }
        assert(row >= 0, "不能选个负数")
        switch kind {
        case .file:
            delegate?.didSend(data: files[row])
        case .folder:
            ()
        }
        
        
        
        
        
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
        return folders.count + files.count
    }
    
    
}



extension MusicBroswer: NSTableViewDelegate{
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let folderCount = folders.count
        if row < folderCount{
            let cell = NSTextField()
            cell.isEditable = false
          
            let attribute = [NSAttributedString.Key.foregroundColor: NSColor.green, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 25)]
            let info = folders[row].lastPathComponent + "    >"
            let attrString = NSAttributedString(string: info, attributes: attribute)
            cell.attributedStringValue = attrString
          
            return cell
        }
        else{
            let item = row - folderCount
            let cell = NSTextField()
            cell.isEditable = false
           
            let attribute = [NSAttributedString.Key.foregroundColor: NSColor.red, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 25)]
            let attrString = NSAttributedString(string: files[item].lastPathComponent, attributes: attribute)
            cell.attributedStringValue = attrString
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if row < folders.count{
            return 70
            
        }
        else{
            return 40
        }
        
    }
    
    
}



