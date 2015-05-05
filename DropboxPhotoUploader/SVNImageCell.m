//
//  SVNImageCell.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNImageCell.h"

@interface SVNImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation SVNImageCell

- (void)setImage:(UIImage *)image {
    [self.imageView setImage:image];
//    [self.name setText:[image accessibilityIdentifier]];
    NSString *size = [NSString stringWithFormat:@"%0.fx%0.f", image.size.width, image.size.height];
    [self.name setText:size];
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
//    [selectedBackgroundView setBackgroundColor:[UIColor redColor]];
    selectedBackgroundView.layer.cornerRadius = 10.0;
    selectedBackgroundView.layer.borderWidth = 1.0;
    [selectedBackgroundView.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

@end
