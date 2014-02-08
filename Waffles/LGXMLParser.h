//
//  LGXMLParser.h
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import <Foundation/Foundation.h>

enum LGXMLType {
    LGXMLTypeSet = 0,
    LGXMLTypeInstruction = 1,
};

@class LGLegoSet, LGLegoInstructions;
@interface LGXMLParser : NSObject <NSXMLParserDelegate> {
    
    enum LGXMLType _type;
    
    NSMutableArray *_output;
    NSXMLParser *_parser;
    NSData *_data;
    BOOL _storingCharacters;
    
    //Lego Set Parsing
    NSMutableString *_currentString;
    LGLegoSet *_currentSet;
    
    //Instruction Parsing
    LGLegoInstructions *_currentInstructions;
    
}

@property(strong, readonly, nonatomic) NSData *parseData;

-(id)initWithData:(NSData *)data;
-(NSArray *)parsedData;

@end
