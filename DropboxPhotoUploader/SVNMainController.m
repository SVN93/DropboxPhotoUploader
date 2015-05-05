//
//  ViewController.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNMainController.h"
#include <AssetsLibrary/AssetsLibrary.h> 
#include "SVNImageCell.h"

static int count = 0;
static NSString *reusableCellIdentifier = @"SVNReusableCell";

@interface SVNMainController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
    NSMutableArray *selectedImages;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SVNMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.allowsMultipleSelection = YES;
    selectedImages = [NSMutableArray new];
    [self getAllPictures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNImageCell *selectedCell = (SVNImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:YES];
    [selectedImages addObject:[imageArray objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNImageCell *selectedCell = (SVNImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:NO];
    [selectedImages removeObject:[imageArray objectAtIndex:indexPath.row]];
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
    mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation] url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count]==count)
                             {
                                 imageArray=[[NSArray alloc] initWithArray:mutableArray];
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
    NSLog(@"all pictures are %@", imgArray);
}

@end
