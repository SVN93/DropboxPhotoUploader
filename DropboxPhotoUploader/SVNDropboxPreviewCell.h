//
//  SVNDropboxPreviewCell.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVNDropboxBundle;

@interface SVNDropboxPreviewCell : UICollectionViewCell

- (void)setBundle:(SVNDropboxBundle *)bundle;

- (SVNDropboxBundle *)getBundle;

//- (void)downloadImageWithCompletion:(CompletionBlock)completion;

- (void)showProgress:(CGFloat)progress;

- (void)hideProgress;

@end
