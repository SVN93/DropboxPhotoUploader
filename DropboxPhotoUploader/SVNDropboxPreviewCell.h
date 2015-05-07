//
//  SVNDropboxPreviewCell.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVNImage;

@interface SVNDropboxPreviewCell : UICollectionViewCell

- (void)loadImagePreview;

- (void)downloadImage;

@end
