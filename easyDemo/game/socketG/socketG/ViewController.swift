//
//  ViewController.swift
//  socketG
//
//  Created by Jz D on 2020/4/15.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Cocoa

enum GameState: Int{
    case unknown = -1, myTurn, yourOpponentTurn, IWin, yourOpponentWin
}

enum PlayerType: Int{
    case me = 0, you
}



struct Matrix{
    static let w = 7
    static let h = 6
}


class ViewController: NSViewController {
    
    var board = [[BoardCell]]()
    var matrix = [[BoardCellType]]()
    var gameManager: GameManager?

    
    @IBOutlet weak var hostBtn: NSButton!
    @IBOutlet weak var joinBtn: NSButton!
    @IBOutlet weak var disconnectBtn: NSButton!
    
    
    @IBOutlet weak var replayButton: NSButton!
    @IBOutlet weak var gameStateLabel: NSTextField!
    
    lazy var boardView: BoardV = { () -> BoardV in
         let x = (view.bounds.width - 280) * 0.5
         let y = (view.bounds.height - 240) * 0.5
         let f = CGRect(x: x, y: y, width: 280, height: 240)
         let v = BoardV(frame: f)
         v.delegate = self
         return v
    }()
      

    private var _gameState = GameState.myTurn
    var gameState: GameState{
        get{
            return _gameState
        }
        set{
            if newValue != _gameState{
                _gameState = newValue
                switch _gameState{
                    case .myTurn:
                        gameStateLabel.stringValue = "It is your turn."
                    case .yourOpponentTurn:
                        gameStateLabel.stringValue = "It is your opponent's turn."
                    case .IWin:
                        gameStateLabel.stringValue = "You have won."
                    case .yourOpponentWin:
                        gameStateLabel.stringValue = "Your opponent has won."
                    default:
                        gameStateLabel.stringValue = ""
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

          // Reset Game
          resetGame()
          view.addSubview(boardView)
          // Configure Subviews
          boardView.isHidden = true
          replayButton.isHidden = true
          
          disconnectBtn.isHidden = true
          gameStateLabel.isHidden = true
      }
    
    
    
    
    
    func showWinner(){
        
        switch gameState {
        case .IWin, .yourOpponentWin:
            replayButton.isHidden = false
            var message = "你 gg 了，Your opponent has won the game."
            if case GameState.IWin = gameState{
                message = "赢啦 ✌️ - You have won the game."
            }
            
            let alert = NSAlert()
            alert.messageText = message
            alert.informativeText = "We Have a Winner"
            alert.addButton(withTitle: "知道了")
            alert.alertStyle = .warning
            if let w = view.window{
                alert.beginSheetModal(for: w) { (returnCode: NSApplication.ModalResponse) in
                    if returnCode == .alertFirstButtonReturn{
                        print("知道了")
                    }
                }
            }
        default:
            ()
        }
        
    }
      
    
    
    // MARK: game relevant

    func startGame(with socket: GCDAsyncSocket){
        // Initialize Game Controller
        gameManager = GameManager(socket: socket)
        gameManager?.delegate = self
     

        // Hide/Show Buttons
        boardView.isHidden = false
        hostBtn.isHidden = true
        
        joinBtn.isHidden = true
        disconnectBtn.isHidden = false
        gameStateLabel.isHidden = false
    }
    
    
    func endGame(){
        
        // Clean Up
        gameManager?.delegate = nil
        gameManager = nil
               
        // Hide/Show Buttons
        boardView.isHidden = true
        hostBtn.isHidden = false
        
        joinBtn.isHidden = false
        disconnectBtn.isHidden = true
        gameStateLabel.isHidden = true
        
    }
    

    func hasPlayerWon(of type: PlayerType) -> Bool{
        var hasWon = false
        var counter = 0;
        var targetType = BoardCellType.yours
        if type == .me{
            targetType = .mine
        }
        // Check Vertical Matches
        // 竖着来
        Outer: for line in board{
            counter = 0
            for cell in line{
                if cell.cellType == targetType{
                    counter += 1
                }
                else{
                    counter = 0
                }
                hasWon = (counter > 3)
                if hasWon{
                    break Outer
                }
            }
        }
        if hasWon == false{
            Outer: for i in 0..<(Matrix.h){
                counter = 0
                for j in 0..<Matrix.w{
                    let cell = board[j][i]
                    if cell.cellType == targetType{
                        counter += 1
                    }
                    else{
                        counter = 0
                    }
                    hasWon = (counter > 3)
                    if hasWon{
                        break Outer
                    }
                }
            }
        }
        if hasWon == false{
            Outer: for i in 0..<Matrix.w{
                // 算法有问题，所以需要正着来一遍，倒着来一遍
                counter = 0
                var j = i
                var row = 0
                while j < Matrix.w, row < Matrix.h {
                    let cell = board[j][row]
                    if cell.cellType == targetType{
                        counter += 1
                    }
                    else{
                        counter = 0
                    }
                    hasWon = (counter > 3)
                    if hasWon{
                        break Outer
                    }
                    j += 1
                    row += 1
                }
                
                // Backward
                
                counter = 0
                j = i
                row = 0
                while j > 0, row < Matrix.h{
                    let cell = board[j][row]
                    if cell.cellType == targetType{
                        counter += 1
                    }
                    else{
                        counter = 0
                    }
                    hasWon = (counter > 3)
                    if hasWon{
                        break Outer
                    }
                    j -= 1
                    row += 1
                }
            }
            
            
        }
        
        if hasWon == false{
           
            // Check Diagonal Matches - Second Pass
            Outer: for i in 0..<Matrix.w{
                
                counter = 0;
     
                // Forward
                var j = i
                var row = Matrix.h - 1
                while j < Matrix.w, row >= 0 {
                    let cell = board[j][row]
                    if cell.cellType == targetType{
                        counter += 1
                    }
                    else{
                        counter = 0
                    }
                    hasWon = (counter > 3)
                    
                    if hasWon{
                        break Outer
                    }
                    
                    j += 1
                    row -= 1
                }
                counter = 0
                
     
                // Backward
                j = i
                row = Matrix.h - 1
                while j >= 0, row >= 0{
                    let cell = board[j][row]
                    if cell.cellType == targetType{
                        counter += 1
                    }
                    else{
                        counter = 0
                    }
                    hasWon = (counter > 3)
                    
                    if hasWon{
                        break Outer
                    }
                    j -= 1
                    row -= 1
                }
     
            }
        }
     
        // Update Game State
        if hasWon{
            gameState = .yourOpponentWin
            if type == .me{
                gameState = .IWin
            }
     
        }
        return hasWon
    }

    
    func resetGame(){
         for eles in board{
             eles.forEach { $0.removeFromSuperview() }
         }
         board = []
         matrix = []
         
         // Hide Replay Button
         replayButton.isHidden = true
      
         // Helpers
         let size = boardView.frame.size
         let cellWidth = size.width / Matrix.w
         let cellHeight = size.height / Matrix.h
         var buffer = [[BoardCell]]()
         for i in 0..<Matrix.w{
             var column = [BoardCell]()
             for j in 0..<Matrix.h{
                 let frame = CGRect(x: i * cellWidth, y: size.height - (j + 1) * cellHeight, width: cellWidth, height: cellHeight)
                 let cell = BoardCell(frame: frame)
                 cell.autoresizingMask = [.width, .height]
                 boardView.addSubview(cell)
                 column.append(cell)
             }
             buffer.append(column)
         }
         board = buffer
         matrix = [[]]
         
         // 有 Matrix.w 个空盒子，可以装东西
         let array = repeatElement([BoardCellType](), count: Matrix.w)
         matrix.append(contentsOf: array)
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
    
    
    @IBAction func replayG(_ sender: NSButton) {
        resetGame()
        gameState = .myTurn
        gameManager?.startNewGame()
        
    }
    
}



// MARK: 15
extension ViewController: HostViewCtrlDelegate{
    func didHostGame(c controller: HostCtrl, On socket: GCDAsyncSocket) {
        gameState = .myTurn
        startGame(with: socket)
    }
    
    
    func didCancelHosting(c controller: HostCtrl) {
        print("\(#file), \(#function)")
    }
    
}




extension ViewController: JoinListCtrlDelegate{
    
    func didJoinGame(c controller: JoinCtrl, on socket: GCDAsyncSocket) {
        gameState = .yourOpponentTurn
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
        resetGame()
        gameState = .yourOpponentTurn
    }
    

    
    
    func didAddDisc(manager: GameManager, to column: UInt) {
        addDiscTo(column: column, with: .yours)
        if hasPlayerWon(of: .you){
            showWinner()
        }
        else{
            gameState = .myTurn
        }
    }
}



extension ViewController: BoardVProxy{
    
    
    func click(event e: NSEvent) {
        switch gameState {
            case .myTurn:
                let p = boardView.convert( e.locationInWindow, from: nil )
                let colume = column(for: NSPointToCGPoint(p))
                addDiscTo(column: colume, with: .mine)
                gameState = .yourOpponentTurn
                // Send Packet
                gameManager?.addDiscTo(column: colume)
                // Notify Players if Someone Has Won the Game
                if hasPlayerWon(of: .me){
                    showWinner()
                }
            case .yourOpponentWin, .IWin:
                showWinner()
            default:
                //  .unknown, .yourOpponentTurn
                let alert = NSAlert()
                alert.messageText = "Warning 不啊"
                alert.informativeText = "It's not your turn."
                alert.addButton(withTitle: "OK")
                alert.alertStyle = .warning
                if let w = view.window{
                    alert.beginSheetModal(for: w) { (returnCode: NSApplication.ModalResponse) in
                        if returnCode == .alertFirstButtonReturn{
                            print("知道了")
                        }
                    }
                }
            }
            
    }
    
    
    
    func column(for point: CGPoint) -> UInt{
        return UInt(point.x)/UInt(boardView.frame.size.width / Matrix.w);
    }
    


    func addDiscTo(column c: UInt, with type: BoardCellType){
        // Update Matrix
      
        matrix[c].append(type)
        // Update Cells
        let cell = board[c][matrix[c].count - 1]
        cell.cellType = type
        
    }
}
