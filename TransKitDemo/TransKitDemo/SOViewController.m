//
//  SOViewController.m
//  TransKitDemo
//
//  Created by Stephen OHara on 6/05/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import "SOViewController.h"

@interface SOViewController ()

@property (nonatomic, strong) SOCueRunner *cueRunner;
@end

@implementation SOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _cueRunner = [[SOCueRunner alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cues" ofType:@"json"];

    [self.cueRunner loadJSONCuesWithPath:path completionBlock:^(NSError *error) {
        
        if(error){
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onNextButton:(UIButton *)sender {
    
    
    [self.cueRunner nextState];
}

@end
