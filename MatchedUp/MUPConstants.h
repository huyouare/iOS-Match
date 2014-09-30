//
//  MUPConstants.h
//  MatchedUp
//
//  Created by Jesse Hu on 9/20/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUPConstants : NSObject

#pragma mark - User Profile

extern NSString *const kMUPUserTagLineKey; // NOT Profile

extern NSString *const kMUPUserProfileKey;
extern NSString *const kMUPUserProfileNameKey;
extern NSString *const kMUPUserProfileFirstNameKey;
extern NSString *const kMUPUserProfileLocationKey;
extern NSString *const kMUPUserProfileGenderKey;
extern NSString *const kMUPUserProfileBirthdayKey;
extern NSString *const kMUPUserProfileInterestedInKey;
extern NSString *const kMUPUserProfilePictureURL;
extern NSString *const kMUPUserProfileRelationshipStatusKey;
extern NSString *const kMUPUserProfileAgeKey;

#pragma mark - Photo Class

extern NSString *const kMUPPhotoClassKey;
extern NSString *const kMUPPhotoUserKey;
extern NSString *const kMUPPhotoPictureKey;

#pragma mark - Acitivty Class

extern NSString *const kMUPActivityClassKey;
extern NSString *const kMUPActivityTypeKey;
extern NSString *const kMUPActivityFromUserKey;
extern NSString *const kMUPActivityToUserKey;
extern NSString *const kMUPActivityPhotoKey;
extern NSString *const kMUPActivityTypeLikeKey;
extern NSString *const kMUPActivityTypeDislikeKey;

#pragma mark - Settings

extern NSString *const kMUPMenEnabledKey;
extern NSString *const kMUPWomenEnabledKey;
extern NSString *const kMUPSingleEnabledKey;
extern NSString *const kMUPAgeMaxKey;

#pragma mark - ChatRoom

extern NSString *const kMUPChatRoomClassKey;
extern NSString *const kMUPChatRoomUser1Key;
extern NSString *const kMUPChatRoomUser2Key;

#pragma mark - Chat

extern NSString *const kMUPChatClassKey;
extern NSString *const kMUPChatChatRoomKey;
extern NSString *const kMUPChatFromUserKey;
extern NSString *const kMUPChatToUserKey;
extern NSString *const kMUPChatTextKey;

@end
