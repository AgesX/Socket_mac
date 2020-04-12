//
//  BoardCell.m
//  oneOC
//
//  Created by Jz D on 2020/4/6.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "BoardCell.h"



@interface BoardCell()



@end





@implementation BoardCell

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellType = BoardCellTypeEmpty;
    }
    return self;
}

#pragma mark -
#pragma mark Setters & Getters
- (void)setCellType: (BoardCellType)cellType {
    if (_cellType != cellType) {
        _cellType = cellType;
 
        // Update View
        [self updateView];
    }
}
 
#pragma mark -
#pragma mark Helper Methods
- (void)updateView {
    // Background Color
    
    if (self.cellType == BoardCellTypeMine) {
        self.layer.backgroundColor = [NSColor purpleColor].CGColor;
    }
    else if (self.cellType == BoardCellTypeYours){
        self.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    else{
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
}
 



@end
