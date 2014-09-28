//
//  MUPChatViewController.h
//  MatchedUp
//
//  Created by Jesse Hu on 9/27/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface MUPChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) PFObject *chatRoom;

@end
