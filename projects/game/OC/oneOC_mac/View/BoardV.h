//
//  BoardV.h
//  oneOC_mac
//
//  Created by Jz D on 2020/4/9.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BoardVProxy;


@interface BoardV : NSView

@property (weak, nonatomic) id<BoardVProxy> delegate;


@end


@protocol BoardVProxy



- (void)click:(NSEvent *)event;

@end



NS_ASSUME_NONNULL_END
