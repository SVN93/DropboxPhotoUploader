//
//  SVNDropboxPreviewCell.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNDropboxPreviewCell.h"
#import "SVNImage.h"
#import "SVNDropboxBundle.h"
#import "DropBlocks.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SVNDropboxPreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic) SVNDropboxBundle *cellBundle;

@end

@implementation SVNDropboxPreviewCell

- (void)setBundle:(SVNDropboxBundle *)bundle {
    self.cellBundle = bundle;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.layer.cornerRadius = 10.0;
    selectedBackgroundView.layer.borderWidth = 1.0;
    [selectedBackgroundView.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self setSelectedBackgroundView:selectedBackgroundView];

    if([bundle.path hasSuffix:@"jpg"] || [bundle.path hasSuffix:@"png"] ||
       [bundle.path hasSuffix:@"gif"] || [bundle.path hasSuffix:@"jpeg"])
    {
        if(bundle.loaded)
        {
            
        } else {
            [DropBlocks loadThumbnail:bundle.title ofSize:@"iphone_bestfit" intoPath:bundle.path completionBlock:^(DBMetadata *metadata, NSError *error) {
                bundle.loaded = YES;
                UIImage *thumbnail = [UIImage imageWithContentsOfFile:bundle.path];
                [UIView transitionWithView:self.imageView
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [self.imageView setImage:thumbnail];
                                } completion:nil];
//                NSString *size = [NSString stringWithFormat:@"%0.fx%0.f", thumbnail.size.width, thumbnail.size.height];
//                NSString *description = [NSString stringWithFormat:@"%@ %@", self.name.text, size];
//                [self.name setText:description];
            }];
        }
        
        NSString *cleanFilename = [[bundle.title componentsSeparatedByString:@"/"] lastObject];
        [self.name setText:cleanFilename];
    }

}

- (void)downloadImage {
    [self.progressView setHidden:NO];
    [self.progressLabel setHidden:NO];
    [DropBlocks loadFile:_cellBundle.title intoPath:_cellBundle.path completionBlock:^(NSString *contentType, DBMetadata *metadata, NSError *error) {
        [self.progressView setHidden:YES];
        [self.progressLabel setHidden:YES];
        UIImage *fullImage = [UIImage imageWithContentsOfFile:_cellBundle.path];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[fullImage CGImage] orientation:ALAssetOrientationUp completionBlock:nil];
    } progressBlock:^(CGFloat progress) {
        self.progressView.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.02f%%", progress * 100];
    }];
}

@end
