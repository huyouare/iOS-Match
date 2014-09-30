//
//  MUPChatViewController.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/27/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPChatViewController.h"
#import "JSMessage.h"

@interface MUPChatViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatTimer;
@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation MUPChatViewController

- (NSMutableArray *)chats
{
    if (!_chats) {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.dataSource = self;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[kMUPChatRoomUser1Key];
    if ([testUser1.objectId isEqual:self.currentUser.objectId]) {
        self.withUser = self.chatRoom[kMUPChatRoomUser2Key];
    } else {
        self.withUser = self.chatRoom[kMUPChatRoomUser1Key];
    }
    self.title = self.withUser[kMUPUserProfileKey][kMUPUserProfileFirstNameKey];
    self.initialLoadComplete = NO;
    
    [self checkForNewChats];
    
    self.chatTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.chatTimer invalidate];
    self.chatTimer = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}

#pragma mark - TableView Delegate

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    if (text.length != 0) {
        PFObject *chat = [PFObject objectWithClassName:kMUPChatClassKey];
        [chat setObject:self.chatRoom forKey:kMUPChatChatRoomKey];
        [chat setObject:self.currentUser forKey:kMUPChatFromUserKey];
        [chat setObject:self.withUser forKey:kMUPChatToUserKey];
        [chat setObject:text forKey:kMUPChatTextKey];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.chats addObject:chat];
            [JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:YES];
        }];
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    
    PFUser *testFromUser = chat[kMUPChatFromUserKey];
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]) {
        return JSBubbleMessageTypeOutgoing;
    } else {
        return JSBubbleMessageTypeIncoming;
    }
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    
    PFUser *testFromUser = chat[kMUPChatFromUserKey];
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    } else {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

#pragma mark - TableView Delegate OPTIONAL

- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}

-(BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark - Messages View Data Source REQUIRED 

- (id<JSMessageData>)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[kMUPChatTextKey];
    JSMessage *jsMessage = [[JSMessage alloc] initWithText:message sender:nil date:nil];
    return jsMessage;
}


- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
    return nil;
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Helper Methods

- (void)checkForNewChats
{
    int oldChatCount = (int)[self.chats count];
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:kMUPChatClassKey];
    [queryForChats whereKey:kMUPChatChatRoomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count]) {
                self.chats = [objects mutableCopy];
                [self.tableView reloadData];
                
                if (self.initialLoadComplete == YES) {
                    [JSMessageSoundEffect playMessageReceivedSound];

                }
                
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}

@end
