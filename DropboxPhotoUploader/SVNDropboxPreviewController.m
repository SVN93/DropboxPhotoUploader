//
//  SVNDropboxPreviewController.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 07.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNDropboxPreviewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SVNDropboxPreviewCell.h"
#import "SVNImage.h"
#import "DropBlocks.h"
#import "SVNDropboxBundle.h"

static NSString *reusablePreviewCell = @"SVNReusablePreviewCell";

@interface SVNDropboxPreviewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray *bundles;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButtom;

@property (nonatomic) NSMutableArray *selectedImages;

@end

@implementation SVNDropboxPreviewController

#pragma mark - SVNMainController life cycle

- (void)viewWillAppear:(BOOL)animated {
    [bundles removeAllObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    [DropBlocks loadMetadata:@"/Photos/" withHash:@"" completionBlock:^(DBMetadata *metadata, NSError *error) {
        NSLog(@"Metadata = %@", metadata);
        NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"gif", @"png", nil];
        for (DBMetadata *child in metadata.contents)
        {
            if([child isDirectory])
            {
                SVNDropboxBundle *bun = [SVNDropboxBundle new];
                bun.path = [child path];
                [bundles addObject:bun];
            } else
            {
                NSString *extension = [[child.path pathExtension] lowercaseString];
                if (!child.isDirectory && ([validExtensions indexOfObject:extension] != NSNotFound))
                {
                    NSString *pathComponent = [NSString stringWithFormat:@"photo%d.%@", arc4random()%152345234, extension];
                    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:pathComponent];
                    
                    SVNDropboxBundle *bun = [[SVNDropboxBundle alloc] init];
                    bun.title = [child path];
                    bun.path = path;
                    bun.size = [child humanReadableSize];
                    
                    NSString *modStr = [[child lastModifiedDate] description];
                    if([modStr hasSuffix:@"+0000"])
                    {
                        bun.modified = [modStr substringToIndex:[modStr rangeOfString:@"+0000"].location];
                    } else
                        bun.modified = modStr;
                    
                    [bundles addObject:bun];
                    NSLog(@"Bundles count = %lu", (unsigned long)[bundles count]);
                }
            }
        }
        
        [self.collectionView reloadData];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.allowsMultipleSelection = YES;
    _selectedImages = [NSMutableArray new];
    bundles = [NSMutableArray new];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)downloadButtonPressed:(UIBarButtonItem *)sender {
    
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNDropboxPreviewCell *selectedCell = (SVNDropboxPreviewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:YES];
//    [_selectedImages addObject:[imageArray objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVNDropboxPreviewCell *selectedCell = (SVNDropboxPreviewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelected:NO];
//    [_selectedImages removeObject:[imageArray objectAtIndex:indexPath.row]];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Bundles count = %lu", (unsigned long)[bundles count]);
    return [bundles count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SVNDropboxPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusablePreviewCell forIndexPath:indexPath];
//    SVNImage *image = [imageArray objectAtIndex:indexPath.row];
//    [cell setImage:image];
    return cell;
}

@end