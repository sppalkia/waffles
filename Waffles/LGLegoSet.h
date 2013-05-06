//
//  LGLegoSet.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGLegoSet : NSObject

@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *theme;
@property(copy, nonatomic) NSString *subtheme;
@property(copy, nonatomic) NSString *year;

@property(copy, nonatomic) NSString *identifier;
@property(copy, nonatomic) NSString *thumbnailImageURLString;
@property(copy, nonatomic) NSString *imageURLString;

@end
