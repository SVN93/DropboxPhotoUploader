//
//  SVNDropboxPreviewCell.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVNDropboxBundle;

typedef void (^CompletionBlock)(BOOL success);

@interface SVNDropboxPreviewCell : UICollectionViewCell

- (void)setBundle:(SVNDropboxBundle *)bundle;

- (void)downloadImageWithCompletion:(CompletionBlock)completion;

@end
