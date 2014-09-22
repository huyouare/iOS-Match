//
//  MUPTestUser.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/21/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPTestUser.h"

@implementation MUPTestUser

+ (void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Julie",
                                      @"gender" : @"female",
                                      @"location": @"Berlin, Germany",
                                      @"name": @"Julie Adams"};
            [newUser setObject:profile forKey:@"profile"];
            
        }
    }];
}

@end
