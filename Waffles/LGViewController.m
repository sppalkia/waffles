//
//  LGViewController.m
//  Waffles
//
//  Created by Shoumik Palkar on 5/4/13.
//  Copyright (c) 2013 Shoumik Palkar. All rights reserved.
//

#import "LGViewController.h"
#import "LGResultsViewController.h"
#import "LGXMLParser.h"
#import "LGLegoSet.h"

@interface LGViewController ()
-(void)processQueryResults:(NSArray *)results;
@end

@implementation LGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.searchFieldContainerView.layer.cornerRadius = 4.0f;
}

-(void)viewDidAppear:(BOOL)animated {    
    [self.searchField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated {
    [self.searchField resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.searchField setText:@""];
    [super viewDidDisappear:animated];
}

#pragma mark - Query Handling

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
    
    if (results.count  > 0) {
        LGResultsViewController *controller = [[LGResultsViewController alloc] initWithNibName:@"LGResultsViewController" bundle:nil results:results];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"No Results"
                                    message:@"There were no results for this search. Try something else!"
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                                               otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 1) {
        [self getQueryResults:textField.text];
        return YES;
    }
    return NO;
}

@end
