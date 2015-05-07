//
//  SVNDropboxPreviewCell.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNDropboxPreviewCell.h"
#import "SVNImage.h"
#import "DropBlocks.h"

@interface SVNDropboxPreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic) SVNImage *imageContainer;

@end

@implementation SVNDropboxPreviewCell

- (void)loadImagePreview {
    
}

- (void)downloadImage {
    
}

@end
