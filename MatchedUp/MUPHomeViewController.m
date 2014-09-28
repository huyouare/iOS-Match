//
//  MUPHomeViewController.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/21/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPHomeViewController.h"
#import "MUPTestUser.h"
#import "MUPProfileViewController.h"
#import "MUPMatchViewController.h"

@interface MUPHomeViewController () <MUPMatchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;


@end

@implementation MUPHomeViewController

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
    
    // [MUPTestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPPhotoClassKey];
    [query whereKey:kMUPPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kMUPPhotoUserKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
            [self updateView];
        } else {
            NSLog(@"%@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        MUPProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    } else if ([segue.identifier isEqualToString:@"homeToMatchSegue"]) {
        MUPMatchViewController *matchVC = segue.destinationViewController;
        matchVC.matchedUserImage = self.photoImageView.image;
        matchVC.delegate = self;
    }
}


#pragma mark - IBActions
- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
}

#pragma mark - Helper Methods

- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kMUPPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
    
    PFQuery *queryForLike = [PFQuery queryWithClassName:kMUPActivityClassKey];
    [queryForLike whereKey:kMUPActivityTypeKey equalTo:kMUPActivityTypeLikeKey];
    [queryForLike whereKey:kMUPActivityPhotoKey equalTo:self.photo];
    [queryForLike whereKey:kMUPActivityFromUserKey equalTo:[PFUser currentUser]];
    
    
    PFQuery *queryForDislike = [PFQuery queryWithClassName:kMUPActivityClassKey];
    [queryForDislike whereKey:kMUPActivityTypeKey equalTo:kMUPActivityTypeDislikeKey];
    [queryForDislike whereKey:kMUPActivityPhotoKey equalTo:self.photo];
    [queryForDislike whereKey:kMUPActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *likeOrDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
    [likeOrDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.activities = [objects mutableCopy];
            
            if ([self.activities count] == 0) {
                self.isLikedByCurrentUser = NO;
                self.isDislikedByCurrentUser = NO;
            } else {
                PFObject *activity = self.activities[0]; // Only one actiivty allowed
                if ([activity[kMUPActivityTypeKey] isEqualToString:kMUPActivityTypeLikeKey]) {
                    self.isLikedByCurrentUser = YES;
                    self.isDislikedByCurrentUser = NO;
                } else if ([activity[kMUPActivityTypeKey] isEqualToString:kMUPActivityTypeDislikeKey]) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = YES;
                } else {
                    // Some other activity, or error
                }
                
            }
            
            self.likeButton.enabled = YES;
            self.dislikeButton.enabled = YES;
            self.infoButton.enabled = YES;
        }
    }];
}

- (void)updateView
{
    self.firstNameLabel.text = self.photo[kMUPPhotoUserKey][kMUPUserProfileKey][kMUPUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kMUPPhotoUserKey][kMUPUserProfileKey][kMUPUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kMUPPhotoUserKey][kMUPUserTagLineKey];
}

- (void)setupNextPhoto
{
    if (self.currentPhotoIndex+1 < [self.photos count]) {
        self.currentPhotoIndex++;
        [self queryForCurrentPhotoIndex];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more users to view." message:@"Check back later for more people" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)saveLike
{
    NSLog(@"Saving Like");
    PFObject *likeActivity = [PFObject objectWithClassName:kMUPActivityClassKey];
    [likeActivity setObject:kMUPActivityTypeLikeKey forKey:kMUPActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMUPActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kMUPPhotoUserKey] forKey:kMUPActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kMUPActivityPhotoKey];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        
        [self checkForPhotoUserLikes];
        [self setupNextPhoto];
    }];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMUPActivityClassKey];
    [dislikeActivity setObject:kMUPActivityTypeDislikeKey forKey:kMUPActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMUPActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kMUPPhotoUserKey] forKey:kMUPActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kMUPActivityPhotoKey];

    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject:dislikeActivity];
        [self setupNextPhoto];
    }];
}

- (void)checkLike
{
    if (self.isLikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    } else if (self.isDislikedByCurrentUser) {
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    } else {
        [self saveLike];
    }
}

- (void)checkDislike
{
    if (self.isDislikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    } else if (self.isLikedByCurrentUser) {
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    } else {
        [self saveDislike];
    }
}

- (void)checkForPhotoUserLikes
{
    NSLog(@"Checking for photo user likes");
    PFQuery *query = [PFQuery queryWithClassName:kMUPActivityClassKey];

    [query whereKey:kMUPActivityFromUserKey equalTo:self.photo[kMUPPhotoUserKey]];
    [query whereKey:kMUPActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kMUPActivityTypeKey equalTo:kMUPActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            [self createChatRoom];
        }
    }];
}

- (void)createChatRoom
{
    NSLog(@"Chat Room Created!");
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:self.photo[kMUPPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:self.photo[kMUPPhotoUserKey]];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *chatRoom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatRoom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatRoom setObject:self.photo[kMUPPhotoUserKey] forKey:@"user2"];
            [chatRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Segue to Match");
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        } else {
            NSLog(@"Chat failed.");
        }
    }];
                              
}

#pragma mark - MUPMatchViewControllerDelegate

- (void)presentMatchesViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}

@end
