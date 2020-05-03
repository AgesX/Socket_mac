//
//  PacketH.h
//  oneOC
//
//  Created by Jz D on 2020/4/3.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



extern NSString * const MTPacketKeyData;
extern NSString * const MTPacketKeyType;
extern NSString * const MTPacketKeyAction;
 

typedef NS_ENUM(NSInteger, PacketType){
    PacketTypeUnknown = -1,
    PacketTypeDidAddDisc,
    PacketTypeStartNewGame
};

 

typedef NS_ENUM(NSInteger, PacketAction){
    PacketActionUnknown = -1
};



//  jiangzhoudeng@163.com

@interface PacketH: NSObject<NSSecureCoding>



@property (strong, nonatomic) id data;
@property (assign, nonatomic) PacketType type;
@property (assign, nonatomic) PacketAction action;
 
#pragma mark -
#pragma mark Initialization
- (instancetype)initWithData: (id)data type:(PacketType)type action:(PacketAction)action;




@end

NS_ASSUME_NONNULL_END


// 网络包， 要有 header 和 body


// header 是信息的摘要

// 是内容控制的枢纽




/*
 
 
 TCP ， 什么数据，都能传输
 
 Even though we can send any type of data through a TCP connection,
 it is recommended to provide a custom structure to hold the data we would like to send.
 
 
 
 
 We can accomplish this by creating a custom packet class. The advantage of this approach becomes evident once we start using the packet class. The idea is simple, though. The class is an Objective-C class that holds data; the body, if you will. It also includes some extra information about the packet, called the header. The main difference with the HTTP protocol is that the header and body are not strictly separated.
 
 
 包信息，需要便于
 编解码
 
 
 The packet class will also need to conform to the NSCoding protocol, which means that instances of the class can be encoded and decoded. This is key if we want to send instances of the packet class through a TCP connection.

 
 
 
 
 
 
 
 
 
 
 Create a new Objective-C class, make it a subclass of NSObject, and name it MTPacket (figure 1). For the game that we are building, the packet class can be fairly simple.
 
 
 包
 The class has three properties, type, action, and data.


 The type property is used to identify the purpose of the packet while the action property contains the intention of the packet.
 
 
 The data property is used to store the actual contents or load of the packet.


 This will all become clearer once we start using the packet class in our game.
 
 
 
 
 */




/*
 
 
 网络传输，要有 header
 
 
 DSA， 要有数据结构， struct 结构体，结构化的数据
 
 
 
 
 */
