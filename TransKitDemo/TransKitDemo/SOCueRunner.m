//
//  SOCueRunner.m
//  TransKitDemo
//
//  Created by Stephen OHara on 7/05/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import "SOCueRunner.h"

#define kBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SOCueRunner ()

-(void)buildStates;

@property (nonatomic, strong)   TKStateMachine *stateMachine;
@property (nonatomic, strong)   NSMutableDictionary *cuesStore;

@property (nonatomic, strong)   NSMutableArray *states;

@property (nonatomic, assign)   NSInteger currentCueIndex;

@end

@implementation SOCueRunner

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _stateMachine = [TKStateMachine new];
        _states = [[NSMutableArray alloc] init];
        
        self.currentCueIndex = 0;
    }
    return self;
}


-(void)loadJSONCuesWithPath:(NSString*)path completionBlock:(void (^)(NSError *error)) block{
   

    NSURL *url = [NSURL fileURLWithPath:path];
    dispatch_async(kBGQueue, ^{
        
        NSError *err;
        NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&err];
        
        if(err){
            block(err);
        }else{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //parse out the json data and store
                NSError *error;
                _cuesStore = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
                
                if(error)
                    block(error);
               
                [self buildStates];
            });
        }
        
    });
}


-(void)buildStates{

    for(NSDictionary *cue in self.cuesStore[@"cues"]){
        
        TKState *state = [TKState stateWithName:cue[@"title"]];

        [state setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
            NSLog(@"will ENTER %@",[state name]);
            
            //• get worker class
            //• call willEnter
            
        }];

        [state setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
            NSLog(@"did ENTER %@",[state name]);
//            SOCueRunner *cueRunner = [[transition userInfo] objectForKey:@"cueRunner"];
//            [cueRunner nextState];

        }];
        
        
        [state setWillExitStateBlock:^(TKState *state, TKTransition *transition) {
            NSLog(@"will EXIT %@",[state name]);
            
        }];
        
        [state setDidExitStateBlock:^(TKState *state, TKTransition *transition){
            NSLog(@"did EXIT %@",[state name]);
        }];
        
       [self.stateMachine addState:state];
        
    }
    
    [self.stateMachine activateWithBlocks];
    
}

-(void)nextState{
    
    NSLog(@"----------------------------");
    
    TKStateMachine *newStateMachine = [self.stateMachine copy];
    
    NSString *currentTitle = self.cuesStore[@"cues"][self.currentCueIndex][@"title"];

    // move to next
    self.currentCueIndex++;
    if(self.currentCueIndex >= [self.cuesStore[@"cues"] count]){
        self.currentCueIndex  = 0;
    }
    
    NSString *nextTitle = self.cuesStore[@"cues"][self.currentCueIndex][@"title"];
    
    TKState *current = [newStateMachine stateNamed:currentTitle];
    TKState *nextState = [newStateMachine stateNamed:nextTitle];

    newStateMachine.initialState = current;

    NSString *eventName = [NSString stringWithFormat:@"%@%@",[current name],[nextState name]];
    TKEvent *nextEvent = [TKEvent eventWithName:eventName transitioningFromStates:@[current] toState:nextState];

    [newStateMachine addEvent:nextEvent];
    [newStateMachine activate];
  
    //• create class of type [[NSClassFromString(@"NameofClass") alloc] init];
    
    
    NSDictionary *userInfo = @{@"cueRunner": self};
    NSError *error = nil;

    BOOL success = [newStateMachine fireEvent:eventName userInfo:userInfo error:&error];
    
    self.stateMachine = [newStateMachine copy];
    
}

@end



