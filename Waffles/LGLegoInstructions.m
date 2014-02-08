//
//  LGLegoInstructions.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/6/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGLegoInstructions.h"

@implementation LGLegoInstructions

-(NSString *)description {
    return [NSString stringWithFormat:@"URLString: %@ description: %@", self.instrURLString, self.instrDescription];
}

@end
