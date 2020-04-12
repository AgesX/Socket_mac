//
//  BoardV.m
//  oneOC_mac
//
//  Created by Jz D on 2020/4/9.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "BoardV.h"

@implementation BoardV


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.accessibilityEnabled = YES;
    self.wantsLayer = YES;
    self.needsDisplay = YES;
    self.layer.backgroundColor = NSColor.brownColor.CGColor;
    self.layer.borderColor = NSColor.yellowColor.CGColor;
    self.layer.borderWidth = 2;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void)mouseDown:(NSEvent *)event{
    [self.delegate click: event];
}

- (BOOL)acceptsFirstResponder{
     return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event{
    return YES;
}



- (BOOL)isFlipped{
    return YES;
}

@end



//  https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/HandlingMouseEvents/HandlingMouseEvents.html



// story board 挺好玩的
