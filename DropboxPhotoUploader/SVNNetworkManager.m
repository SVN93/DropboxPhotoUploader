//
//  SVNNetworkManager.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 06.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNNetworkManager.h"
#import <DropboxSDK/DropboxSDK.h>

@interface SVNNetworkManager () <DBRestClientDelegate>

@property (nonatomic) DBRestClient *restClient;

@end

@implementation SVNNetworkManager

+ (id)sharedManager {
    static SVNNetworkManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    
    if (self) {
                self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
                self.restClient.delegate = self;
    }
    
    return self;
}

+ (void)uploadFile:filename toPath:destDir withParentRev:(NSString *)parentRev fromPath:(NSString *)sourcePath withCallback:(UPCompletionBlock)callback {
    SVNNetworkManager *dropboxNetworking = [self sharedManager];
//    [dropboxNetworking.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:sourcePath];
    callback(YES);
}


#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}

@end
