//
//  SVNNetworkManager.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^UPCompletionBlock)(BOOL success);

@interface SVNNetworkManager : NSObject

+ (id)sharedManager;

//+ (void)uploadFile:filename toPath:destDir withParentRev:(NSString *)parentRev fromPath:(NSString *)sourcePath withCallback:(UPCompletionBlock)callback;

@end
