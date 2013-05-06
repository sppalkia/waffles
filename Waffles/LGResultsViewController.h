//
//  LGResultsViewController.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/5/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGResultsViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

- (id)initWithNibName:(NSString *)n bundle:(NSBundle *)b results:(NSArray *)results;

@end
