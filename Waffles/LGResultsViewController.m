//
//  LGResultsViewController.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/5/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGResultsViewController.h"
#import "LGResultsCollectionLayout.h"
#import "LGTitleReusableView.h"
#import "LGResultCell.h"
#import "LGLegoSet.h"

static NSString * const ResultCellIdentifier = @"PhotoCell";
static NSString * const TitleIdentifier = @"AlbumTitle";

@interface LGResultsViewController ()

@property (nonatomic, weak) IBOutlet LGResultsCollectionLayout *layout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (atomic, strong) NSMutableDictionary *imageCache;
@end

@implementation LGResultsViewController

- (id)initWithNibName:(NSString *)n bundle:(NSBundle *)b results:(NSArray *)results {
    if (self = [super initWithNibName:n bundle:b]) {
        self.searchResults = [[NSMutableArray alloc] initWithArray:results];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageCache = [[NSMutableDictionary alloc] initWithCapacity:self.searchResults.count];
    
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    [self.collectionView registerClass:[LGResultCell class]
            forCellWithReuseIdentifier:ResultCellIdentifier];
    
    [self.collectionView registerClass:[LGTitleReusableView class]
            forSupplementaryViewOfKind:LGResultsCollectionLayoutAlbumTitleKind
                   withReuseIdentifier:TitleIdentifier];

    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.imageCache removeAllObjects];
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.layout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
        
        self.layout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    }
    else {
        self.layout.numberOfColumns = 2;
        self.layout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.searchResults.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGResultCell *resultCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:ResultCellIdentifier
                                              forIndexPath:indexPath];
    
    LGLegoSet *set = [self.searchResults objectAtIndex:[indexPath section]];
    
    // load photo images in the background
    __weak LGResultsViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [self.imageCache objectForKey:set.identifier];
        
        if (!image) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:set.imageURLString]];
            image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
            
            if (set.identifier && image) {
                [self.imageCache setObject:image forKey:set.identifier];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                LGResultCell *cell = (LGResultCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    
    return resultCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    LGTitleReusableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:TitleIdentifier
                                              forIndexPath:indexPath];
    
    LGLegoSet *legoSet = [self.searchResults objectAtIndex:indexPath.section];
    titleView.titleLabel.text = legoSet.name;
    return titleView;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollPoint = scrollView.contentOffset.y;
    if (scrollPoint < -250.0f) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self.imageCache removeAllObjects];
            [self.searchResults removeAllObjects];
        }];
    }
}



@end
