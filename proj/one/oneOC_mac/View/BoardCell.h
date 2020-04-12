//
//  BoardCell.h
//  oneOC
//
//  Created by Jz D on 2020/4/6.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger, BoardCellType){
    BoardCellTypeEmpty = -1,
    BoardCellTypeMine,
    BoardCellTypeYours
};


@interface BoardCell : NSView


@property (assign, nonatomic) BoardCellType cellType;


@end

NS_ASSUME_NONNULL_END
