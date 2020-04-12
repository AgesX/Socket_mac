//
//  ViewController.m
//  oneOC_mac
//
//  Created by Jz D on 2020/4/2.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "ViewController.h"


#import "HostCtrl.h"

#import "JoinCtrl.h"

#import "GameManager.h"

#import "BoardCell.h"

#import "BoardV.h"

#import "Constants.h"

@interface ViewController()<HostGameViewControllerDelegate, JoinGameViewControllerDelegate, GameManagerProxy, BoardVProxy>



@property (strong, nonatomic) GameManager * gameManager;


@property (weak, nonatomic) IBOutlet NSButton *hostBtn;
@property (weak, nonatomic) IBOutlet NSButton *joinBtn;
@property (weak, nonatomic) IBOutlet NSButton *disconnectBtn;



@property (nonatomic, strong) BoardV *boardView;

@property (weak) IBOutlet NSTextField *gameStateLabel;

@property (weak) IBOutlet NSButton *replayButton;


// 数据，未更改
@property (strong, nonatomic) NSArray<NSArray * > * board;


// 数据，已经更改
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> * matrix;


@property (assign, nonatomic) GameState gameState;



@end




#define kMTMatrixWidth 7
#define kMTMatrixHeight 6





@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
/*
    CGFloat x = self.view.frame.origin.x + self.view.frame.size.width * 0.5;
    CGFloat y = self.view.frame.origin.y + self.view.frame.size.height * 0.5;
 */
    self.boardView = [[BoardV alloc] initWithFrame: CGRectMake(300, 200 , 280, 240)];
    [self.view addSubview: self.boardView];
    
    /*
    self.boardView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints: @[
        [self.boardView.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor],
        [self.boardView.centerYAnchor constraintEqualToAnchor: self.view.centerYAnchor],
        [self.boardView.widthAnchor constraintEqualToConstant: 280 ],
        [self.boardView.heightAnchor constraintEqualToConstant: 240]]];
   */
    
    // Setup View
    [self setupView];
}





- (void)setupView {
    // Reset Game
    [self resetGame];
 
    // Configure Subviews
    [self.boardView setHidden:YES];
    [self.replayButton setHidden:YES];
    [self.disconnectBtn setHidden:YES];
    [self.gameStateLabel setHidden:YES];
    
    
    self.boardView.delegate = self;
}



- (void)addDiscToColumn: (NSEvent *)event {
    if (self.gameState >= GameStateIWin) {
        //  GameStateYouWin,    GameStateIWin
        
        // Notify Players
        [self showWinner];
 
    } else if (self.gameState != GameStateMyTurn) {
        
        //  GameStateYourTurn
        
        
        // Show Alert
        
        NSAlert * a = [[NSAlert alloc] init];
        a.messageText = @"It's not your turn.";
        a.informativeText = @"Warning 不啊";
        [a addButtonWithTitle: @"OK"];
        a.alertStyle = NSAlertStyleWarning;

        [a beginSheetModalForWindow: self.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                NSLog(@"知道了");
            }
        }];
        
 
    } else {
        //  GameStateMyTurn
        
        
        // 计算出了，哪一列
        // 哪一行，怎么算
        NSInteger column = [self columnForPoint: [event locationInWindow]];
        
        
        // MD
        [self addDiscToColumn:column withType: BoardCellTypeMine];
 // 这里是落子了，去更新状态
        // Update Game State
        // 自己操作处理了
        self.gameState = GameStateYourTurn;
        
        
        // 把消息，告知对方
        
        // Send Packet
        [self.gameManager addDiscToColumn:column];
        
        // Notify Players if Someone Has Won the Game
        
        // Notify Players if Someone Has Won the Game
        if ([self hasPlayerOfTypeWon: PlayerTypeMe]) {
            // Show Winner
            [self showWinner];
        }
    }
}



- (void)addDiscToColumn:(NSInteger)column withType:(BoardCellType)cellType {
    // Update Matrix
    NSMutableArray *columnArray = [self.matrix objectAtIndex:column];
    [columnArray addObject: @(cellType)];
 
    // Update Cells
    BoardCell *cell = [[self.board objectAtIndex:column] objectAtIndex: (columnArray.count - 1)];
    cell.cellType = cellType;
    
}




- (void)showWinner {
    if (self.gameState < GameStateIWin){
        return;
    }
 
    // Show Replay Button
    [self.replayButton setHidden:NO];
 
    NSString *message = nil;
 
    if (self.gameState == GameStateIWin) {
        message = @"You have won the game.";
 
    } else if (self.gameState == GameStateYouWin) {
        message = @"Your opponent has won the game.";
    }
 
    // Show Alert
    
    NSAlert * a = [[NSAlert alloc] init];
    a.messageText = @"We Have a Winner";
    a.informativeText = @"赢啦 ✌️";
    [a addButtonWithTitle: @"OK"];
    a.alertStyle = NSAlertStyleWarning;

    [a beginSheetModalForWindow: self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            NSLog(@"知道了");
        }
    }];
    
}




- (NSInteger)columnForPoint:(CGPoint)point {
    return floorf(point.x / floorf(self.boardView.frame.size.width / kMTMatrixWidth));
}





- (BOOL)hasPlayerOfTypeWon: (PlayerType) playerType {
    BOOL _hasWon = NO;
    NSInteger _counter = 0;
    BoardCellType targetType = BoardCellTypeYours;
    if (playerType == PlayerTypeMe){
        targetType = BoardCellTypeMine;
    }
 
    // Check Vertical Matches
    // 竖着来
    for (NSArray *line in self.board) {
        _counter = 0;
 
        for (BoardCell *cell in line) {
            _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
            _hasWon = (_counter > 3) ? YES : _hasWon;
 
            if (_hasWon){
                break;
            }
        }
 
        if (_hasWon){
            break;
        }
    }
 
    if (!_hasWon) {
        // Check Horizontal Matches
        for (int i = 0; i < kMTMatrixHeight; i++) {
            _counter = 0;
 
            for (int j = 0; j < kMTMatrixWidth; j++) {
                BoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:i];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
 
                if (_hasWon) break;
            }
 
            if (_hasWon) break;
        }
    }
 
    if (!_hasWon) {
        // Check Diagonal Matches
        //  对角线
        //  - First Pass
        for (int i = 0; i < kMTMatrixWidth; i++) {
            _counter = 0;
 
            // Forward
            for (int j = i, row = 0; j < kMTMatrixWidth && row < kMTMatrixHeight; j++, row++) {
                BoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
 
                if (_hasWon) break;
            }
 
            if (_hasWon) break;
 
            _counter = 0;
 
            // Backward
            for (int j = i, row = 0; j >= 0 && row < kMTMatrixHeight; j--, row++) {
                BoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
 
                if (_hasWon) break;
            }
 
            if (_hasWon) break;
        }
    }
 
    if (!_hasWon) {
        // Check Diagonal Matches - Second Pass
        for (int i = 0; i < kMTMatrixWidth; i++) {
            _counter = 0;
 
            // Forward
            for (int j = i, row = (kMTMatrixHeight - 1); j < kMTMatrixWidth && row >= 0; j++, row--) {
                BoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
 
                if (_hasWon) break;
            }
 
            if (_hasWon) break;
 
            _counter = 0;
 
            // Backward
            for (int j = i, row = (kMTMatrixHeight - 1); j >= 0 && row >= 0; j--, row--) {
                BoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
 
                if (_hasWon) break;
            }
 
            if (_hasWon) break;
        }
    }
 
    // Update Game State
    if (_hasWon) {
        self.gameState = GameStateYouWin;
        if (playerType == PlayerTypeMe){
            self.gameState = GameStateIWin;
        }
    }
 
    return _hasWon;
}






- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}









- (void)startGameWithSocket:(GCDAsyncSocket *)socket {
    // Initialize Game Controller
    self.gameManager = [[GameManager alloc] initWithSocket:socket];
 
    // Configure Game Controller
    self.gameManager.delegate = self;
 
    // Hide/Show Buttons
    [self.boardView setHidden:NO];
    [self.hostBtn setHidden:YES];
    [self.joinBtn setHidden:YES];
    [self.disconnectBtn setHidden:NO];
    [self.gameStateLabel setHidden:NO];
}





- (void)resetGame {
    for (NSArray * eles in self.board) {
        for (NSView * v in eles){
            [v removeFromSuperview];
        }
    }
    self.board = nil;
    self.matrix = nil;
    // Hide Replay Button
    [self.replayButton setHidden:YES];
 
    // Helpers
    CGSize size = CGSizeMake(280, 240);
    // self.boardView.frame.size;
    CGFloat cellWidth = floorf(size.width / kMTMatrixWidth);
    CGFloat cellHeight = floorf(size.height / kMTMatrixHeight);
    NSMutableArray *buffer = [[NSMutableArray alloc] initWithCapacity:kMTMatrixWidth];
 
    for (int i = 0; i < kMTMatrixWidth; i++) {
        NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity: kMTMatrixHeight];
        //  board 数组里面， 都是一列一列的纵向的数据
        for (int j = 0; j < kMTMatrixHeight; j++) {
            CGRect frame = CGRectMake(i * cellWidth, (size.height - ((j + 1) * cellHeight)), cellWidth, cellHeight);
            BoardCell *cell = [[BoardCell alloc] initWithFrame:frame];
            [cell setAutoresizingMask:( NSViewWidthSizable | NSViewHeightSizable )];
            [self.boardView addSubview:cell];
            [column addObject:cell];
         //   cell.layer.borderColor = NSColor.redColor.CGColor;
          //  cell.layer.borderWidth = 2;
        }
 
        [buffer addObject: [column copy]];
    }
 
    // Initialize Board
    self.board = buffer.copy;
 
    // Initialize Matrix
    self.matrix = [[NSMutableArray alloc] initWithCapacity:kMTMatrixWidth];
 
    for (int i = 0; i < kMTMatrixWidth; i++) {
        NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:kMTMatrixHeight];
        [self.matrix addObject:column];
    }
}








- (IBAction)host:(NSButton *)sender {
    
    HostCtrl* vc = [[HostCtrl alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self presentViewControllerAsModalWindow:vc];
    
    
}




- (IBAction)joinGame:(NSButton *)sender {
    
    JoinCtrl* vc = [[JoinCtrl alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self presentViewControllerAsModalWindow:vc];
}










- (IBAction)disconnectIt:(NSButton *)sender {
    
    
    
    [self endGame];
    
}



- (IBAction)replayG:(NSButton *)sender {
    
    // Reset Game
       [self resetGame];
    
       // Update Game State
       self.gameState = GameStateMyTurn;
    
    
      // 提示对手
      // Notify Opponent of New Game
       [self.gameManager startNewGame];
    
    
    
}





- (void)click:(NSEvent *)event{
    
    if (self.gameState >= GameStateIWin) {
        //  GameStateYouWin,    GameStateIWin
        
        // Notify Players
        [self showWinner];
 
    } else if (self.gameState != GameStateMyTurn) {
        
        //  GameStateYourTurn
        
        
        // Show Alert
        
        NSAlert * a = [[NSAlert alloc] init];
        a.messageText = @"It's not your turn.";
        a.informativeText = @"Warning 不啊";
        [a addButtonWithTitle: @"OK"];
        a.alertStyle = NSAlertStyleWarning;

        [a beginSheetModalForWindow: self.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                NSLog(@"知道了");
            }
        }];
        
 
    } else {
        //  GameStateMyTurn
        
        
        // 计算出了，哪一列
        // 哪一行，怎么算
        
        
        NSPoint p = [self.boardView convertPoint: [event locationInWindow] fromView: nil];
        
        NSInteger column = [self columnForPoint: NSPointToCGPoint(p)];
        
        
        // MD
        [self addDiscToColumn:column withType: BoardCellTypeMine];
 // 这里是落子了，去更新状态
        // Update Game State
        // 自己操作处理了
        self.gameState = GameStateYourTurn;
        
        
        // 把消息，告知对方
        
        // Send Packet
        [self.gameManager addDiscToColumn:column];
        
        // Notify Players if Someone Has Won the Game
        
        // Notify Players if Someone Has Won the Game
        if ([self hasPlayerOfTypeWon: PlayerTypeMe]) {
            // Show Winner
            [self showWinner];
        }
    }
}



- (void)endGame {
    // Clean Up
    self.gameManager.delegate = nil;
    self.gameManager = nil;
    
    // Hide/Show Buttons
    [self.boardView setHidden:YES];
    [self.hostBtn setHidden:NO];
    [self.joinBtn setHidden:NO];
    [self.disconnectBtn setHidden:YES];
    [self.gameStateLabel setHidden:YES];
   
}




#pragma mark -
#pragma mark Host Game View Controller Methods



- (void)controller:(HostCtrl *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Update Game State
    self.gameState = GameStateMyTurn;
    
    // Start Game with Socket
    [self startGameWithSocket:socket];
    
    // Test Connection
    
    NSLog(@"testConnection 来没");
  //  [self.gameManager testConnection];
}



- (void)controllerDidCancelHosting:(HostCtrl *)controller{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}


 
#pragma mark -
#pragma mark Join Game View Controller Methods


- (void)controller:(JoinCtrl *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Update Game State
    self.gameState = GameStateYourTurn;
    // Start Game with Socket
    [self startGameWithSocket:socket];
}




- (void)controllerDidCancelJoining:(JoinCtrl *)controller{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}



#pragma mark -
#pragma mark Join Game View Controller Methods

// 收到了，对方的操作
- (void)manager:(GameManager *)manager didAddDiscToColumn:(NSInteger)column {
    // Update Game
    [self addDiscToColumn:column withType: BoardCellTypeYours];
 
    
    
     if([self hasPlayerOfTypeWon: PlayerTypeYou]) {
            // Show Winner
            [self showWinner];

       }else{
             // Update State
             self.gameState = GameStateMyTurn;
       }
}






- (void)managerDidDisconnect:(GameManager *) manager {
    NSLog(@"%s", __PRETTY_FUNCTION__);
 
    // End Game
    [self endGame];
}





- (void)managerDidStartNewGame: (GameManager *) manager {
    // Reset Game
    [self resetGame];
 
    // Update Game State
    self.gameState = GameStateYourTurn;
}



////




- (void)setGameState: (GameState) gameState {
    if (_gameState != gameState) {
        _gameState = gameState;
 
        // Update View
        [self updateView];
    }
}




- (void)updateView {
    // Update Game State Label
    switch (self.gameState) {
        case GameStateMyTurn: {
            self.gameStateLabel.stringValue = @"It is your turn.";
            break;
        }
        case GameStateYourTurn: {
            self.gameStateLabel.stringValue = @"It is your opponent's turn.";
            break;
        }
        case GameStateIWin: {
            self.gameStateLabel.stringValue = @"You have won.";
            break;
        }
        case GameStateYouWin: {
            self.gameStateLabel.stringValue = @"Your opponent has won.";
            break;
        }
        default: {
            self.gameStateLabel.stringValue = @"";
            break;
        }
    }
}

@end




