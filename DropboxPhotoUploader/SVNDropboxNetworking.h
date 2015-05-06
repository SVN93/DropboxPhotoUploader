//
//  SVNDropboxNetworking.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UPCompletionBlock)(BOOL success);
//typedef void (^UPCompletionBlock)(BOOL success, NSDictionary *response, NSError *error);

@interface SVNDropboxNetworking : NSObject

+ (id)sharedManager;

+ (void)uploadFile:filename toPath:destDir withParentRev:(NSString *)parentRev fromPath:(NSString *)sourcePath withCallback:(UPCompletionBlock)callback;

@end
