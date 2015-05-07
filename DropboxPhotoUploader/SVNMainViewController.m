//
//  ViewController.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNMainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h> 
#import "SVNCollectionCell.h"
#import "SVNImage.h"
#import <DropboxSDK/DropboxSDK.h>

static int count = 0;
static NSString *reusableCellIdentifier = @"SVNReusableCell";
static NSString *SegueToDropboxPreviewVC = @"SegueToDropboxPreviewVC";

@interface SVNMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

@property (nonatomic) NSMutableArray *selectedCells;

@end

@implementation SVNMainViewController

#pragma mark - SVNMainController life cycle

- (void)viewWillAppear:(BOOL)animated {
    [self getAllPictures];
    [_selectedCells removeAllObjects];
    [self checkUploadButtonEnabling];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.allowsMultipleSelection = YES;
    _selectedCells = [NSMutableArray new];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.x
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Actions

- (IBAction)uploadButtonPressed:(UIBarButtonItem *)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    for (SVNCollectionCell *cell in _selectedCells) {
        [cell uploadImage];
    }
}

- (IBAction)downloadButtonPressed:(UIBarButtonItem *)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    [self performSegueWithIdentifier:SegueToDropboxPreviewVC sender:self];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNCollectionCell *selectedCell = (SVNCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:YES];
    [_selectedCells addObject:selectedCell];
    [self checkUploadButtonEnabling];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNCollectionCell *selectedCell = (SVNCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:NO];
    [_selectedCells removeObject:selectedCell];
    [self checkUploadButtonEnabling];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SVNCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCellIdentifier forIndexPath:indexPath];
    SVNImage *image = [imageArray objectAtIndex:indexPath.row];
    [cell setImage:image];
    return cell;
}


#pragma mark - Helpers

- (void)checkUploadButtonEnabling
{
    if (_selectedCells.count) {
        [self.uploadButton setEnabled:YES];
    } else {
        [self.uploadButton setEnabled:NO];
    }
}

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
                             
                             if ([mutableArray count] == count) {
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

@end
