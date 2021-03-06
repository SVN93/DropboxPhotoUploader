//
//  SVNImageCell.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNCollectionCell.h"
#import "SVNImage.h"
#import "DropBlocks.h"

@interface SVNCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic) SVNImage *imageContainer;

@end

@implementation SVNCollectionCell

- (void)setImage:(SVNImage *)image {
    self.imageContainer = image;
    [self.imageView setImage:self.imageContainer];
    NSString *size = [NSString stringWithFormat:@"%0.fx%0.f", self.imageContainer.size.width, self.imageContainer.size.height];
    NSString *description = [NSString stringWithFormat:@"%@ %@", self.imageContainer.fileName, size];
    [self.name setText:description];
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.layer.cornerRadius = 10.0;
    selectedBackgroundView.layer.borderWidth = 1.0;
    [selectedBackgroundView.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

- (SVNImage *)getImage {
    if (_imageContainer != nil) {
        return _imageContainer;
    }
    return nil;
}

- (void)showProgress:(CGFloat)progress {
    [self.progressView setHidden:NO];
    [self.progressLabel setHidden:NO];
    self.progressView.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.02f%%", progress * 100];
}

- (void)hideProgress {
    [self.progressView setHidden:YES];
    [self.progressLabel setHidden:YES];
}


//- (void)uploadImageWithCompletion:(CompletionBlock)completion {
//    // Write a file to the local documents directory
//    NSString *filename = [self.imageContainer fileName];
//    NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
//    [UIImagePNGRepresentation(self.imageContainer) writeToFile:tmpFile atomically:NO];
//    // Upload file to Dropbox
//    NSString *destDir = @"/Photos/";
//    [self.progressView setHidden:NO];
//    [self.progressLabel setHidden:NO];
//    [DropBlocks uploadFile:filename toPath:destDir withParentRev:nil fromPath:tmpFile completionBlock:^(NSString *destDir, DBMetadata *metadata, NSError *error) {
//        [self.progressView setHidden:YES];
//        [self.progressLabel setHidden:YES];
//        
//        if (error) {
//            NSLog(@"Uh oh, something went wrong with this file load. I'd better do something about that.");
//            completion(NO);
//        } else {
//            NSLog(@"Yay, my file loaded. My work here is done.");
//            completion(YES);
//        }
//    } progressBlock:^(CGFloat progress) {
//        self.progressView.progress = progress;
//        self.progressLabel.text = [NSString stringWithFormat:@"%.02f%%", progress * 100];
//    }];
//}



@end
