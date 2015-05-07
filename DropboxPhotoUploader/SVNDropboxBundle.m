//
//  DropboxBundle.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNDropboxBundle.h"

@interface SVNDropboxBundle ()

@end

@implementation SVNDropboxBundle

- (id)init
{
    self = [super init];
    
    if(self) {
        self.loaded = NO;
        self.title = nil;
        self.path = nil;
        self.modified = nil;
        self.size = nil;
    }
    return self;
}

@end
