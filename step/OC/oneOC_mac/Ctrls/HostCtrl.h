//
//  HostC.h
//  oneOC_mac
//
//  Created by Jz D on 2020/4/2.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@class GCDAsyncSocket;
@protocol HostGameViewControllerDelegate;
 
@interface HostCtrl: NSViewController
 
@property (weak, nonatomic) id<HostGameViewControllerDelegate> delegate;
 
@end
 
@protocol HostGameViewControllerDelegate
- (void)controller:(HostCtrl *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket;
- (void)controllerDidCancelHosting:(HostCtrl *)controller;
@end


NS_ASSUME_NONNULL_END
