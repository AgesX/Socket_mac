//
//  JoinCtrl.m
//  oneOC_mac
//
//  Created by Jz D on 2020/4/2.
//  Copyright © 2020 Jz D. All rights reserved.
//

#import "JoinCtrl.h"

#include "GCDAsyncSocket.h"


#import "PacketH.h"


@interface JoinCtrl ()<NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate, NSTableViewDelegate, NSTableViewDataSource>
 
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;



@property (weak) IBOutlet NSTableView *tableView;



@end

@implementation JoinCtrl


static NSString *ServiceCell = @"ServiceCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入者";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Start Browsing
    [self startBrowsing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didSelectRow:) name: NSTableViewSelectionDidChangeNotification object: self.tableView];
    
}



- (void)didSelectRow: (NSNotification * ) noti{
    NSTableView * tb = (NSTableView *) noti.object;
    NSInteger row = tb.selectedRow;
    // Fetch Service
    NSNetService *service = [self.services objectAtIndex: row];

    // Resolve Service
    NSLog(@"Resolve 一下， 解析处理");
    service.delegate = self;
    // 点击，服务就 gg
   
    [service resolveWithTimeout:30.0];

    
}






- (void)viewWillDisappear{
    [super viewWillDisappear];

    // Stop Browsing Services
    [self stopBrowsing];
 
}





- (void)cancel:(id)sender {
       // Notify Delegate
       [self.delegate controllerDidCancelJoining:self];
    
       // Stop Browsing Services
       [self stopBrowsing];
    
       // Dismiss View Controller
       [self dismiss];
}




- (void)dealloc {
    if (_delegate) {
        _delegate = nil;
    }


    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void)startBrowsing {
    if (self.services) {
        [self.services removeAllObjects];
    } else {
        self.services = [[NSMutableArray alloc] init];
    }
 
    // Initialize Service Browser
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
 
    // Configure Service Browser
    [self.serviceBrowser setDelegate:self];
    [self.serviceBrowser searchForServicesOfType:@"deng._tcp." inDomain:@"local."];
}



- (void)stopBrowsing {
    if (self.serviceBrowser) {
        [self.serviceBrowser stop];
        [self.serviceBrowser setDelegate:nil];
        [self setServiceBrowser:nil];
    }
}



#pragma mark - Table view data source




- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (self.services){
        return [self.services count];
    }else{
        return 0;
    }
}



- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTextField *cell = [[NSTextField alloc] init];
    
     
    // Fetch Service
    NSNetService *service = [self.services objectAtIndex: row];
    
    cell.stringValue = service.name;
    
    return cell;
}






- (void)netServiceBrowser:(NSNetServiceBrowser *)serviceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Update Services
    [self.services addObject:service];
 
    if(!moreComing) {
        // Sort Services
        [self.services sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
 
        // Update Table View
        [self.tableView reloadData];
    }
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)serviceBrowser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Update Services
    [self.services removeObject:service];
 
    if(!moreComing) {
        // Update Table View
        [self.tableView reloadData];
    }
}


- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)serviceBrowser {
    [self stopBrowsing];
}



- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didNotSearch:(NSDictionary *)userInfo {
    [self stopBrowsing];
}



- (void)netServiceDidResolveAddress:(NSNetService *)service {
    // Connect With Service
    NSLog(@"Deng: Connect With Service");
    if ([self connectWithService:service]) {
        NSLog(@"Did Connect with Service: domain(%@) type(%@) name(%@) port(%i)", [service domain], [service type], [service name], (int)[service port]);
    } else {
        NSLog(@"XXX: Unable to Connect with Service: domain(%@) type(%@) name(%@) port(%i)", [service domain], [service type], [service name], (int)[service port]);
    }
}



- (BOOL)connectWithService:(NSNetService *)service {
    BOOL _isConnected = NO;
 
    // Copy Service Addresses
    NSArray *addresses = [[service addresses] mutableCopy];
 
    if (!self.socket || ![self.socket isConnected]) {
        // Initialize Socket
        NSLog(@"Initialize Socket, 新建了 Socket");
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
 
        // Connect
        while (!_isConnected && [addresses count]) {
            NSData *address = [addresses objectAtIndex:0];
 
            NSError *error = nil;
            if ([self.socket connectToAddress:address error:&error]) {
                _isConnected = YES;
 
            } else if (error) {
                NSLog(@"Unable to connect to address. Error %@ with user info %@.", error, [error userInfo]);
            }
        }
 
    } else {
        _isConnected = [self.socket isConnected];
    }
 
    return _isConnected;
}






// 读数据
- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"Socket Did Connect to Host: %@ Port: %hu", host, port);
    NSLog(@"邓: 故事发生一");

    
       // Notify Delegate
       [self.delegate controller:self didJoinGameOnSocket:socket];
    
       // Stop Browsing
       [self stopBrowsing];
    
       // Dismiss View Controller
       [self dismiss];
}




- (void) dismiss{
    // Dismiss View Controller
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewController:self];
    } else {
        //for the 'show' transition
        [self.view.window close];
    }
}







@end






/*
    Browsing Services
 
 
 
    To browse for services on the local network, we use the NSNetServiceBrowser class. Before putting the NSNetServiceBrowser class to use, we need to create a few private properties. Add a class extension to the MTJoinGameViewController class and declare three properties as shown below.
 
 
 
 The first property, socket of type GCDAsyncSocket, will store a reference to the socket that will be created when a network service resolves successfully.
 
 
 
 
 2
 
 The services property (NSMutableArray) will store all the services that the service browser discovers on the network. Every time the service browser finds a new service, it will notify us and we can add it to that mutable array. This array will also serve as the data source of the view controller's table view.


 The third property, serviceBrowser, is of type NSNetServiceBrowser and will search the network for network services that are of interest to us. Also note that the MTJoinGameViewController conforms to three protocols. This will become clear when we implement the methods of each of these protocols.
 
 */

