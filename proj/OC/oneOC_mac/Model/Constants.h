//
//  Constants.h
//  oneOC
//
//  Created by Jz D on 2020/4/6.
//  Copyright © 2020 Jz D. All rights reserved.
//

#ifndef Constants_h
#define Constants_h



typedef NS_ENUM(NSInteger, GameState){
    GameStateUnknown = -1,
    GameStateMyTurn,
    GameStateYourTurn,
    GameStateIWin,
    GameStateYouWin
};




typedef NS_ENUM(NSInteger, PlayerType){
    PlayerTypeMe = 0,
    PlayerTypeYou
};



/*
    The MTPlayerType type is defined in MTConstants.h.

 Even though we could pass 0 for player A and 1 for player B,
 
 our code becomes much more readable (and maintainable) by declaring a custom type.
 
 */

#endif /* Constants_h */
