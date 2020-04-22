//
//  GameManager.m
//  oneOC
//
//  Created by Jz D on 2020/4/6.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "GameManager.h"
 
#import "PacketH.h"

#include "GCDAsyncSocket.h"

 
#define TAG_HEAD 0
#define TAG_BODY 1
 
@interface GameManager()<GCDAsyncSocketDelegate>
 
@property (strong, nonatomic) GCDAsyncSocket *socket;
 
@end




@implementation GameManager



#pragma mark -
#pragma mark Initialization
- (instancetype)initWithSocket:(GCDAsyncSocket *)socket {
    self = [super init];
 
    if (self) {
        // Socket
        self.socket = socket;
        self.socket.delegate = self;
 
        // Start Reading Data
        [self.socket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:TAG_HEAD];
    }
 
    return self;
}



/*

- (void)testConnection {
    NSLog(@"testConnection 来了没有");
    // Create Packet
   // NSString *message = @"This is a proof of concept. 哈哈哈 😄";
    NSString *message = @"This is a proof of con";
    PacketH *packet = [[PacketH alloc] initWithData:message type:0 action:0];
 
    // Send Packet
    [self sendPacket: packet];
}


*/





- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
 
    if (self.socket == socket) {
        self.socket.delegate = nil;
        self.socket = nil;
    }
 
    // Notify Delegate
    [self.delegate managerDidDisconnect:self];
}



 
- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag {
    if (tag == 0) {
        uint64_t bodyLength = [self parseHeader:data];
        [socket readDataToLength:bodyLength withTimeout:-1.0 tag:1];
 
    } else if (tag == 1) {
        [self parseBody:data];
        [socket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
    }
}




/*
 Before we look at the implementation of parseHeader:,
 
 let's first continue our exploration of socket:didReadData:withTag:.
 
 
 If tag is equal to 1, we know that we have read the complete encoded packet. We parse the packet and repeat the cycle by telling the socket to watch out for the header of the next packet that arrives.
 
 
 
 不知道，下一个包，什么时候来
 
 
 It is important that we pass -1 for timeout (no timeout) as we don't know when the next packet will arrive.
 
 */

- (uint64_t)parseHeader:(NSData *)data {
    NSInteger headerLength = 0;
    [data getBytes: &headerLength length:sizeof(uint64_t)];
    return headerLength;
}




- (void)parseBody:(NSData *)data {
    NSLog(@"body 来了");
    NSError * error;
    NSSet *classes = [NSSet setWithObjects: NSDictionary.class, PacketH.class, nil];
    PacketH *packet = [NSKeyedUnarchiver unarchivedObjectOfClasses: classes fromData: data error: &error];
    
    NSLog(@"errorUnfold: %@", error);
    NSLog(@"Packet Data > %@", packet.data);
    NSLog(@"Packet Type > %li", (long)packet.type);
    NSLog(@"Packet Action > %li", (long)packet.action);
     
    // 落子了
    if (packet.type == PacketTypeDidAddDisc) {
        
           NSNumber *column = [(NSDictionary *)[packet  data] objectForKey:@"column"];
           NSLog(@"走 A, \n 列 %@", column);
           if (column) {
               // Notify Delegate
               NSLog(@" √ 来了没有， ha ha ha, \n 列 %@", column);
               [self.delegate manager:self didAddDiscToColumn: column.integerValue];
           }
    }
    else if ([packet type] == PacketTypeStartNewGame) {
         NSLog(@"走 B");
          // 这里真的走了，  点击 replay 的时候
        // 新开一局
        // Notify Delegate
        [self.delegate managerDidStartNewGame:self];
    }
}







- (void)addDiscToColumn:(NSInteger)column {
    // Send Packet
    NSDictionary *load = @{ @"column" : @(column) };
    PacketH *packet = [[PacketH alloc] initWithData:load type: PacketTypeDidAddDisc action:0];
    [self sendPacket: packet];
}







/*
 When a connection is established, the application instance hosting the game is notified of this by the invocation of the socket:didAcceptNewSocket: delegate method of the GCDAsyncSocketDelegate protocol.
 
 
 We implemented this method in the previous article. Take a look at its implementation below to refresh your memory.


 The last line of its implementation should now be clear.

 We tell the new socket to start reading data and we pass a tag, an integer, as the last parameter.
 
 
 不清楚，什么时间
 We don't set a timeout (-1)
 because we don't know when we can expect the first packet to arrive.
 
 */




- (void)sendPacket:(PacketH *)packet {
    
    
    // packet to buffer
    // 包，到 缓冲
    
    //  https://stackoverflow.com/questions/51372551/how-to-replace-nskeyedarchivers-initializer-initforwritingwith-in-ios-12-to
    
    // Encode Packet Data
    NSError * error;
    NSData * encoded = [NSKeyedArchiver archivedDataWithRootObject:packet requiringSecureCoding:NO error: &error];
    NSLog(@"error: %@", error);
    // Initialize Buffer
    NSMutableData *buffer = [[NSMutableData alloc] init];
 
    // buffer = header + packet
    
    // Fill Buffer
    
    uint64_t headerLength = encoded.length;
    [buffer appendBytes:&headerLength length:sizeof(uint64_t)];
    [buffer appendBytes: encoded.bytes length: headerLength];
 
    // Write Buffer
    [self.socket writeData:buffer withTimeout:-1.0 tag:0];
}

/*
 
 As I wrote earlier, we can only send binary data through a TCP connection.
 
 
 We then create another NSMutableData instance, which will be the data object that we will pass to the socket a bit later. The data object, however, does not only hold the encoded MTPacket instance.

 It also needs to include the header that precedes the encoded packet. We store the length of the encoded packet in a variable named headerLength which is of type uint64_t. We then append the header to the NSMutableData buffer.
 
 
 Did you spot the & symbol preceding headerLength?

 The appendBytes:length: method expects a buffer of bytes, not the value of the headerLength value. Finally, we append the contents of packetData to the buffer. The buffer is then passed to writeData:withTimeout:tag:.
 
 The CocoaAsyncSocket library takes care of the nitty gritty details of sending the data.
 
 
 
 */




- (void)startNewGame {
    // Send Packet
    NSDictionary *load = nil;
    PacketH *packet = [[PacketH alloc] initWithData:load type: PacketTypeStartNewGame action:0];
    [self sendPacket:packet];
}





- (void)dealloc {
    if (_socket) {
        [_socket setDelegate:nil delegateQueue:NULL];
        [_socket disconnect];
        _socket = nil;
    }
}


@end



/*
 
 
  Another reason is that
 
 the only responsibility of the MTHostGameViewController and MTJoinGameViewController classes
 
 is finding players on the local network and establishing a connection.



 They shouldn't have any other responsibilities.
 
 
 */
