//
//  SVNImageCell.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVNImage;

@interface SVNCollectionCell : UICollectionViewCell

- (void)setImage:(SVNImage *)image;

- (SVNImage *)getImage;

- (void)showProgress:(CGFloat)progress;

- (void)hideProgress;

//- (void)uploadImageWithCompletion:(CompletionBlock)completion;

@end
