//
//  MUPProfileViewController.h
//  MatchedUp
//
//  Created by Jesse Hu on 9/21/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUPProfileViewControllerDelegate <NSObject>

- (void)didPressLike;
- (void)didPressDislike;

@end

@interface MUPProfileViewController : UIViewController

@property (strong, nonatomic) PFObject *photo;
@property (weak, nonatomic) id<MUPProfileViewControllerDelegate> delegate;

@end
