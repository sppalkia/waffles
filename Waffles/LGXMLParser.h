//
//  LGXMLParser.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGLegoSet;
@interface LGXMLParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *_output;
    NSXMLParser *_parser;
    NSData *_data;
    BOOL _storingCharacters;
    
    NSMutableString *_currentString;
    LGLegoSet *_currentSet;
}

@property(strong, readonly, nonatomic) NSData *parseData;

-(id)initWithData:(NSData *)data;
-(NSArray *)parsedData;

@end
