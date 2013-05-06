//
//  LGLegoSet.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGLegoSet.h"

@implementation LGLegoSet

-(NSString *)description {
    return [NSString stringWithFormat:@"setID: %@\n \
    setName: %@\n \
    theme: %@\n \
    subtheme: %@\n \
    thumbnailURLString: %@\n \
            imageURLString: %@",
            self.identifier, self.name, self.theme, self.subtheme, self.thumbnailImageURLString, self.imageURLString];
}

@end