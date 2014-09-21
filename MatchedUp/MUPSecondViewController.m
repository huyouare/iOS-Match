//
//  MUPSecondViewController.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/14/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPSecondViewController.h"

@interface MUPSecondViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@end

@implementation MUPSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPPhotoClassKey];
    [query whereKey:kMUPPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kMUPPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.profilePictureImageView = [UIImage imageWithData:data];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
