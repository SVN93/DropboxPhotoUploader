//
//  SVNImage.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNImage.h"

@interface SVNImage ()

@property (readwrite, nonatomic) NSString *fileName;

@end

@implementation SVNImage

- (id)initWithALAsset:(ALAsset *)asset {
    self = [super initWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//    self = [super initWithCGImage:[asset thumbnail]];
    if (self) {
        self.fileName = [[asset defaultRepresentation] filename];
    }
    return self;
}

@end
