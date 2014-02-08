//
//  LGXMLParser.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGXMLParser.h"
#import "LGLegoSet.h"
#import "LGLegoInstructions.h"

@implementation LGXMLParser
@synthesize parseData=_data;

-(id)initWithData:(NSData *)data {
    if (self = [super init]) {
        
        _data = data;
        _parser = [[NSXMLParser alloc] initWithData:data];
        _parser.delegate = self;
        
        _storingCharacters = NO;
        _currentSet = nil;
        
        _currentString = [[NSMutableString alloc] init];
        [_currentString setString:@""];
        
        _output = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)parsedData {
    [_parser parse];
    return [[NSArray alloc] initWithArray:_output];
}

#pragma mark - NSXMLParserDelegate

//marks start of new set
static NSString *kName_DELIMITER = @"setData";

//set properties
static NSString *kName_setID = @"setID";
static NSString *kName_setName = @"setName";
static NSString *kName_theme = @"theme";
static NSString *kName_subtheme = @"subtheme";
static NSString *kName_imageURL = @"imageURL";
static NSString *kName_thumbnailURL = @"thumbnailURL";

//marks start of new instruction
static NSString *kName_INSTR_DELIMITER = @"instructionsData";

//instruction properties
static NSString *kName_instrURL = @"URL";
static NSString *kName_instrDescription = @"description";

-(void)finishSet {
    [_output addObject:_currentSet];
    _currentSet = nil;
}

-(void)finishInstruction {
    [_output addObject:_currentInstructions];
    _currentInstructions = nil;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)
                                                                    qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kName_DELIMITER]) {
        _type = LGXMLTypeSet;
        _currentSet = nil;
        _currentSet = [[LGLegoSet alloc] init];
    }
    else if ([elementName isEqualToString:kName_INSTR_DELIMITER]) {
        _type = LGXMLTypeInstruction;
        _currentInstructions = nil;
        _currentInstructions = [[LGLegoInstructions alloc] init];
    }
    else if ([elementName isEqualToString:kName_setID] || [elementName isEqualToString:kName_setName] ||
             [elementName isEqualToString:kName_theme] || [elementName isEqualToString:kName_subtheme] ||
             [elementName isEqualToString:kName_imageURL] || [elementName isEqualToString:kName_thumbnailURL] ||
              (([elementName isEqualToString:kName_instrURL] || [elementName isEqualToString:kName_instrDescription]) && _type == LGXMLTypeInstruction)) {
        
        _storingCharacters = YES;
        [_currentString setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kName_DELIMITER]) {
        [self finishSet];
    }
    else if ([elementName isEqualToString:kName_INSTR_DELIMITER]) {
        [self finishInstruction];
    }    
    else if ([elementName isEqualToString:kName_setID]) {
        _currentSet.identifier = _currentString;
    }
    else if ([elementName isEqualToString:kName_setName]) {
        _currentSet.name = _currentString;
    }
    else if ([elementName isEqualToString:kName_theme]) {
        _currentSet.theme = _currentString;
    }
    else if ([elementName isEqualToString:kName_subtheme]) {
        _currentSet.subtheme = _currentString;
    }
    else if ([elementName isEqualToString:kName_imageURL]) {
        _currentSet.imageURLString = _currentString;
    }
    else if ([elementName isEqualToString:kName_thumbnailURL]) {
        _currentSet.thumbnailImageURLString = _currentString;
    }
    else if ([elementName isEqualToString:kName_instrURL]) {
        _currentInstructions.instrURLString = _currentString;
    }
    else if ([elementName isEqualToString:kName_instrDescription]) {
        _currentInstructions.instrDescription = _currentString;
    }
    
    _storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_storingCharacters) [_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", [parseError debugDescription]);
}

#pragma mark - NSObject Methods

-(NSString *)description {
    return @"LGXMLParser: <Insert Description Here>";
}

@end
