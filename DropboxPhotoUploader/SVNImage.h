//
//  SVNImage.h
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SVNImage : UIImage

@property (readonly, nonatomic) NSString *fileName;

- (id)initWithALAsset:(ALAsset *)asset;

@end
