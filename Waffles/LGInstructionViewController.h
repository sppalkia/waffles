//
//  LGInstructionViewController.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/6/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGLegoSet;
@interface LGInstructionViewController : UIViewController

@property(strong, nonatomic) LGLegoSet *legoSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil legoSet:(LGLegoSet *)legoSet;

@end
