//
//  SVNImage.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNImage.h"
#import "DropBlocks.h"

@interface SVNImage ()

@property (readwrite, nonatomic) NSString *fileName;

@end

@implementation SVNImage {
    CGFloat _currentProgress;
    BOOL _progressViewIsHidden;
}

- (id)initWithALAsset:(ALAsset *)asset {
    self = [super initWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//    self = [super initWithCGImage:[asset thumbnail]];
    if (self) {
        self.fileName = [[asset defaultRepresentation] filename];
        _progressViewIsHidden = YES;
        _currentProgress = 0;
    }
    return self;
}

- (void)uploadImageWithCompletion:(CompletionBlock)completion andProgress:(ProgressBlock)progressCallback {
    _progressViewIsHidden = NO;
    // Write a file to the local documents directory
    NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingPathComponent:self.fileName];
    [UIImagePNGRepresentation(self) writeToFile:tmpFile atomically:NO];
    // Upload file to Dropbox
    NSString *destDir = @"/Photos/";
    [DropBlocks uploadFile:self.fileName toPath:destDir withParentRev:nil fromPath:tmpFile completionBlock:^(NSString *destDir, DBMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"Uh oh, something went wrong with this file load. I'd better do something about that.");
            _progressViewIsHidden = YES;
            completion(NO);
        } else {
            NSLog(@"Yay, my file loaded. My work here is done.");
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
