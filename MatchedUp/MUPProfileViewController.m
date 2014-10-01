//
//  MUPProfileViewController.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/21/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPProfileViewController.h"

@interface MUPProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@end

@implementation MUPProfileViewController

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
    
    PFFile *photoFile = self.photo[kMUPPhotoPictureKey];
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    
    PFUser *user = self.photo[kMUPPhotoUserKey];
    self.locationLabel.text = user[kMUPUserProfileKey][kMUPUserProfileLocationKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kMUPUserProfileKey][kMUPUserProfileAgeKey]];
    if (user[kMUPUserProfileKey][kMUPUserProfileRelationshipStatusKey] == nil) {
        self.statusLabel.text = @"Single"; // Assume the user is single
    }
    else {
        self.statusLabel.text = user[kMUPUserProfileKey][kMUPUserProfileRelationshipStatusKey];
    }
    self.tagLineLabel.text = user[kMUPUserTagLineKey];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.title = user[kMUPUserProfileKey][kMUPUserProfileFirstNameKey];
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
    [self.delegate didPressLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self.delegate didPressDislike];
}

@end
