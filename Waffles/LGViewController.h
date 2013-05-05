//
//  LGViewController.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGViewController : UIViewController <NSURLConnectionDelegate>

-(void)getQueryResults:(NSString *)query;

@property(nonatomic, retain) IBOutlet UIImageView *imageView;

@end
