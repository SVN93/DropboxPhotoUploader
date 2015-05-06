//
//  ViewController.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNMainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h> 
#import "SVNImageCell.h"
#import "SVNImage.h"
//#import <DropboxSDK/DropboxSDK.h>

static int count = 0;
static NSString *reusableCellIdentifier = @"SVNReusableCell";

@interface SVNMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

//@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic) NSMutableArray *selectedImages;

@end

@implementation SVNMainViewController

#pragma mark - SVNMainController life cycle

- (void)viewWillAppear:(BOOL)animated {
    [self getAllPictures];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.allowsMultipleSelection = YES;
//    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    self.restClient.delegate = self;
    _selectedImages = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.x
}


#pragma mark - Buttons

- (IBAction)uploadButtonPressed:(UIBarButtonItem *)sender {
//    if (![[DBSession sharedSession] isLinked]) {
//        [[DBSession sharedSession] linkFromController:self];
//    }
    
//    for (SVNImage *image in _selectedImages) {
//        // Write a file to the local documents directory
//        NSString *filename = [image fileName];
//        NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
//        [UIImagePNGRepresentation(image) writeToFile:tmpFile atomically:NO];
//        
//        // Upload file to Dropbox
//        NSString *destDir = @"/Photos/";
//        
//        // Uploading...
//        [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:tmpFile];
//    }
}

- (IBAction)downloadButtonPressed:(UIBarButtonItem *)sender {
//    if (![[DBSession sharedSession] isLinked]) {
//        [[DBSession sharedSession] linkFromController:self];
//    }
    
//    [self.restClient loadMetadata:@"dropbox"];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNImageCell *selectedCell = (SVNImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:YES];
    [_selectedImages addObject:[imageArray objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNImageCell *selectedCell = (SVNImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:NO];
    [_selectedImages removeObject:[imageArray objectAtIndex:indexPath.row]];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SVNImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCellIdentifier forIndexPath:indexPath];
    UIImage *image = [imageArray objectAtIndex:indexPath.row];
    [cell setImage:image];
    return cell;
}


#pragma mark - Helpers

-(void)getAllPictures {
    imageArray = [[NSArray alloc] init];
    mutableArray = [[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation] url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             SVNImage *image = [[SVNImage alloc] initWithALAsset:asset];
                             [mutableArray addObject:image];
                             
                             if ([mutableArray count] == count)
                             {
                                 imageArray = [[NSArray alloc] initWithArray:mutableArray];
                                 [self allPhotosCollected:imageArray];
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count = (int)[group numberOfAssets];
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

-(void)allPhotosCollected:(NSArray*)imgArray {
    //write your code here after getting all the photos from library...
    imageArray = [NSArray arrayWithArray:imgArray];
    [self.collectionView reloadData];
//    NSLog(@"all pictures are %@", imgArray);
}


//#pragma mark - DBRestClientDelegate
//
//- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
//              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
//    NSLog(@"File uploaded successfully to path: %@", metadata.path);
//}
//
//- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
//    NSLog(@"File upload failed with error: %@", error);
//}
//
//- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
//    if (metadata.isDirectory) {
//        NSLog(@"Folder '%@' contains:", metadata.path);
//        for (DBMetadata *file in metadata.contents) {
//            NSLog(@"	%@", file.filename);
//        }
//    }
//}
//
//- (void)restClient:(DBRestClient *)client
//loadMetadataFailedWithError:(NSError *)error {
//    NSLog(@"Error loading metadata: %@", error);
//}
//
//- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
//       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
//    NSLog(@"File loaded into path: %@", localPath);
//}
//
//- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
//    NSLog(@"There was an error loading the file: %@", error);
//}

@end
