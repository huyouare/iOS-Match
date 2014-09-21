//
//  MUPHomeViewController.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/21/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPHomeViewController.h"

@interface MUPHomeViewController ()

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
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPPhotoClassKey];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - IBActions
- (IBAction)likeButtonPressed:(UIButton *)sender
{
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
}

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
}

#pragma mark - Helper Methods

- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[@"image"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)updateView
{
    self.firstNameLabel.text = self.photo[@"user"][@"profile"][@"first_name"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[@"user"][@"profile"][@"age"]];
    self.tagLineLabel.text = self.photo[@"user"][@"tagLine"];
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
    PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
    [likeActivity setObject:@"like" forKey:@"type"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [likeActivity setObject:self.photo forKey:@"photo"];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self setupNextPhoto];
    }];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:@"Activity"];
    [dislikeActivity setObject:@"dislike" forKey:@"type"];
    [dislikeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [dislikeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [dislikeActivity setObject:self.photo forKey:@"photo"];

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

@end
