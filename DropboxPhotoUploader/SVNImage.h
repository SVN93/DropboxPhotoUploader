//
//  SVNImage.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^CompletionBlock)(BOOL success);
typedef void (^ProgressBlock)(CGFloat progress);

@interface SVNImage : UIImage

@property (readonly, nonatomic) NSString *fileName;

- (id)initWithALAsset:(ALAsset *)asset;

- (void)uploadImageWithCompletion:(CompletionBlock)completion andProgress:(ProgressBlock)progressCallback;

- (CGFloat)getProgress;

- (BOOL)progressViewIsHidden;

@end
