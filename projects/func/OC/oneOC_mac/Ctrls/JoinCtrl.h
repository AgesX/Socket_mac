//
//  JoinCtrl.h
//  oneOC_mac
//
//  Created by Jz D on 2020/4/2.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@class GCDAsyncSocket;
@protocol JoinGameViewControllerDelegate;
 
@interface JoinCtrl: NSViewController
 
@property (weak, nonatomic) id<JoinGameViewControllerDelegate> delegate;
 
@end
 
@protocol JoinGameViewControllerDelegate


- (void)controller:(JoinCtrl *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket;
- (void)controllerDidCancelJoining:(JoinCtrl *)controller;


@end


NS_ASSUME_NONNULL_END

