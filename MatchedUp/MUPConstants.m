//
//  MUPConstants.m
//  MatchedUp
//
//  Created by Jesse Hu on 9/20/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import "MUPConstants.h"

@implementation MUPConstants

#pragma mark - User Profile

NSString *const kMUPUserTagLineKey              = @"tagLine"; // NOT Profile

NSString *const kMUPUserProfileKey              = @"profile";
NSString *const kMUPUserProfileNameKey          = @"name";
NSString *const kMUPUserProfileFirstNameKey     = @"firstName";
NSString *const kMUPUserProfileLocationKey      = @"location";
NSString *const kMUPUserProfileGenderKey        = @"gender";
NSString *const kMUPUserProfileBirthdayKey      = @"birthday";
NSString *const kMUPUserProfileInterestedInKey  = @"interestedIn";
NSString *const kMUPUserProfilePictureURL       = @"pictureURL";
NSString *const kMUPUserProfileAgeKey           = @"age";
NSString *const kMUPUserProfileRelationshipStatusKey = @"relationshipStatus";

#pragma mark - Photo Class

NSString *const kMUPPhotoClassKey               = @"Photo";
NSString *const kMUPPhotoUserKey                = @"user";
NSString *const kMUPPhotoPictureKey             = @"image";

#pragma mark - Acitivty Class

NSString *const kMUPActivityClassKey            = @"Activity";
NSString *const kMUPActivityTypeKey             = @"type";
NSString *const kMUPActivityFromUserKey         = @"fromUser";
NSString *const kMUPActivityToUserKey           = @"toUser";
NSString *const kMUPActivityPhotoKey            = @"photo";
NSString *const kMUPActivityTypeLikeKey         = @"like";
NSString *const kMUPActivityTypeDislikeKey      = @"dislike";

#pragma mark - Settings

NSString *const kMUPMenEnabledKey               = @"men";
NSString *const kMUPWomenEnabledKey             = @"women";
NSString *const kMUPSingleEnabledKey           = @"single";
NSString *const kMUPAgeMaxKey                   = @"ageMax";


@end
