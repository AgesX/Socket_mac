//
//  PacketH.m
//  oneOC
//
//  Created by Jz D on 2020/4/3.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "PacketH.h"

NSString * const MTPacketKeyData = @"data";
NSString * const MTPacketKeyType = @"type";
NSString * const MTPacketKeyAction = @"action";

@implementation PacketH

#pragma mark -
#pragma mark Initialization
- (instancetype)initWithData:(id)data type: (PacketType)type action: (PacketAction)action {
    self = [super init];
 
    if (self) {
        self.data = data;
        self.type = type;
        self.action = action;
    }
 
    return self;
}
 
#pragma mark -
#pragma mark NSCoding Protocol
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.data forKey:MTPacketKeyData];
    [coder encodeInteger:self.type forKey:MTPacketKeyType];
    [coder encodeInteger:self.action forKey:MTPacketKeyAction];
}




- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        _data = [coder decodeObjectForKey: MTPacketKeyData];
        _type = [coder decodeIntegerForKey: MTPacketKeyType];
        _action = [coder decodeIntegerForKey: MTPacketKeyAction];
    }
 
    return self;
}


+ (BOOL)supportsSecureCoding {
   return YES;
}




@end



