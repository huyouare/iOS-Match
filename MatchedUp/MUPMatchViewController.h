//
//  MUPMatchViewController.h
//  MatchedUp
//
//  Created by Jesse Hu on 9/27/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUPMatchViewControllerDelegate <NSObject>

- (void)presentMatchesViewController;

@end

@interface MUPMatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;
@property (weak) id <MUPMatchViewControllerDelegate> delegate;

@end
