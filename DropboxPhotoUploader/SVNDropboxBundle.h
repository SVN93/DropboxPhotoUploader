//
//  DropboxBundle.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVNDropboxBundle : NSObject

@property (readwrite) BOOL loaded;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *modified;

- (id)init;

@end
