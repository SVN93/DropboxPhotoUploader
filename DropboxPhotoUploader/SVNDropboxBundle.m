//
//  DropboxBundle.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVNDropboxBundle.h"
#import "DropBlocks.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SVNDropboxBundle ()

@end

@implementation SVNDropboxBundle {
    CGFloat _currentProgress;
    BOOL _progressViewIsHidden;
}

- (id)init
{
    self = [super init];
    
    if(self) {
        self.loaded = NO;
        self.title = nil;
        self.path = nil;
        self.modified = nil;
        self.size = nil;
        _progressViewIsHidden = YES;
        _currentProgress = 0;

    }
    return self;
}

- (void)downloadImageWithCompletion:(CompletionBlock)completion andProgress:(ProgressBlock)progressCallback {
    _progressViewIsHidden = NO;
    [DropBlocks loadFile:self.title intoPath:self.path completionBlock:^(NSString *contentType, DBMetadata *metadata, NSError *error) {
        UIImage *fullImage = [UIImage imageWithContentsOfFile:self.path];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[fullImage CGImage] orientation:ALAssetOrientationUp completionBlock:nil];
        
        if (error) {
            NSLog(@"Uh oh, something went wrong with this file download. I'd better do something about that.");
            _progressViewIsHidden = YES;
            completion(NO);
        } else {
            NSLog(@"Yay, my file downloaded. My work here is done.");
            _progressViewIsHidden = YES;
            completion(YES);
        }
    } progressBlock:^(CGFloat progress) {
        _currentProgress = progress;
        progressCallback(progress);
    }];
}

- (CGFloat)getProgress {
    return _currentProgress;
}

- (BOOL)progressViewIsHidden {
    return _progressViewIsHidden;
}

@end
