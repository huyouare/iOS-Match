//
//  MUPTransitionAnimator.h
//  MatchedUp
//
//  Created by Jesse Hu on 10/1/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUPTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;

@end
