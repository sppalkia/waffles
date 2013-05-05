//
//  LGViewController.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LGViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

-(void)getQueryResults:(NSString *)query;

@property(nonatomic, strong) IBOutlet UIView *searchFieldContainerView;
@property(nonatomic, strong) IBOutlet UITextField *searchField;

@end
