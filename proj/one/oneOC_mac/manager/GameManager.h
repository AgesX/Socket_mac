//
//  GameManager.h
//  oneOC
//
//  Created by Jz D on 2020/4/6.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GCDAsyncSocket;

@protocol GameManagerProxy;

@interface GameManager : NSObject

@property (weak, nonatomic) id<GameManagerProxy> delegate;


#pragma mark -
#pragma mark Initialization
- (instancetype)initWithSocket:(GCDAsyncSocket *)socket;


//  - (void)testConnection;


#pragma mark -
#pragma mark Public Instance Methods

// 我方开启新游戏
- (void)startNewGame;


- (void)addDiscToColumn:(NSInteger)column;



@end



@protocol GameManagerProxy

- (void)manager:(GameManager *)manager didAddDiscToColumn:(NSInteger)column;


- (void)managerDidDisconnect:(GameManager *) manager;

// 对方开启新游戏
- (void)managerDidStartNewGame:(GameManager *)manager;


@end



NS_ASSUME_NONNULL_END
