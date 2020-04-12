//
//  AppDelegate.m
//  oneOC_mac
//
//  Created by Jz D on 2020/4/2.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end



/*
 
 
 第三卷
 
 
 https://code.tutsplus.com/tutorials/creating-a-game-with-bonjour-sending-data--mobile-16437?_ga=2.20155902.773556673.1585714382-399465906.1583664348
 
 
 
 As we saw in the previous tutorial, the CocoaAsyncSocket library makes working with sockets quite easy. However, there is more to the story than sending a simple string from one device to another, as we did in the previous tutorial. In the first article of this series, I wrote that the TCP protocol can manage a continuous stream of data in two directions. The problem, however, is that it is literally a continuous stream of data. The TCP protocol takes care of sending the data from one end of the connection to the other, but it is up to the receiver to make sense of what is being sent through that connection.

 
 
 
 There are several solutions to this problem. The HTTP protocol, which is built on top of the TCP protocol, sends an HTTP header with every request and response. The HTTP header contains information about the request or response, which the receiver can use to make sense of the incoming stream of data.
 
 
 
 
Head 的意义
 
 
 One key component of the HTTP header is the length of the body.
 
 If the receiver knows the length of the body of the request or response, it can extract the body from the incoming stream of data.

 
 
 
 
 
 
 
 That's great, but how does the receiver know how long the header is? Every HTTP header field ends with a CRLF (Carriage Return, Line Feed) and the HTTP header itself also ends with a CRLF. This means that the header of each HTTP request and response ends with two CRLFs. When the receiver reads the incoming data from the read stream, it only has to search for this pattern (two consecutive CRLFs) in the read stream. By doing so, the receiver can identify and extract the header of the HTTP request or response. With the header extracted, extracting the body of the HTTP request or response is pretty straightforward.

 
 
 
 HTTP 的 header , body 的 data 长度
 
 
 Socket 的 header , packet 的 data 长度
 
 
 
 
 The strategy that we will be using differs from how the HTTP protocols operates. Every packet of data that we send through the connection is prefixed with a header that has a fixed length. The header is not as complex as an HTTP header. The header that we will be using contains one piece of information, the length of the body or packet that comes after the header. In other words, the header is nothing more than a number that informs the receiver of the length of the body. With that knowledge, the receiver can successfully extract the body or packet from the incoming stream of data. Even though this is a simple approach, it works surprisingly well as you will see in this tutorial.
 
 
 
 */



//  Handling Mouse Events
