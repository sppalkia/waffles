//
//  LGInstructionViewController.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/6/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGInstructionViewController.h"
#import "LGLegoSet.h"
#import "LGLegoInstructions.h"
#import "LGXMLParser.h"

@interface LGInstructionViewController ()

@property(strong, nonatomic) IBOutlet UIWebView *documentView;
@property(strong, nonatomic) NSURL *pageURL;

@end

@implementation LGInstructionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil legoSet:(LGLegoSet *)legoSet
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.legoSet = legoSet;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self getSetInstructions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSetInstructions {
    NSString *queryString = [NSString stringWithFormat:@"http://www.brickset.com/webservices/brickset.asmx/listInstructions?setID=%@", self.legoSet.identifier];
    NSString *urlString = [queryString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
                
        LGXMLParser *parser = [[LGXMLParser alloc] initWithData:receivedData];
        NSArray *finalResult = [parser parsedData];
                
        [self performSelectorOnMainThread:@selector(processResults:) withObject:finalResult waitUntilDone:NO];
    });
}

-(void)processResults:(NSArray *)results {
    for (LGLegoInstructions *instrs in results) {
        
        NSLog(@"%@", [instrs description]);
        
        if ([instrs.instrDescription rangeOfString:@"may not be available"].location == NSNotFound) {
            self.pageURL = [NSURL URLWithString:instrs.instrURLString];
        }
    }
    NSLog(@"%@", [self.pageURL description]);
    [self.documentView loadRequest:[NSURLRequest requestWithURL:self.pageURL]];
}

@end
