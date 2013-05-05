//
//  LGViewController.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGViewController.h"
#import "LGXMLParser.h"
#import "LGLegoSet.h"
#import "LGResultsViewController.h"

@interface LGViewController ()
-(void)processQueryResults:(NSArray *)results;
@end

@implementation LGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self getQueryResults:@"10221"];
}

-(void)getQueryResults:(NSString *)query {
    
    NSString *queryString = [NSString stringWithFormat:@"http://www.brickset.com/webservices/brickset.asmx/search?apiKey=&userHash=&query=%@&theme=&subtheme=&setNumber=&year=&Owned=&Wanted=", query];
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
        
        [self performSelectorOnMainThread:@selector(processQueryResults:) withObject:finalResult waitUntilDone:NO];
    });
}

-(void)processQueryResults:(NSArray *)results {
    for (LGLegoSet *set in results) {
        NSLog(@"%@", [set description]);
    }
        
    LGResultsViewController *resultsController = [[LGResultsViewController alloc] initWithNibName:@"LGResultsViewController" bundle:nil];
    [self presentViewController:resultsController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
