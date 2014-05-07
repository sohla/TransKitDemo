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
            NSLog(@"will enter %@",[state name]);
        }];

        [state setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
            NSLog(@"did enter %@",[state name]);
        }];
        
        
        [state setWillExitStateBlock:^(TKState *state, TKTransition *transition) {
            NSLog(@"will exit %@",[state name]);
        }];
        
        [state setDidExitStateBlock:^(TKState *state, TKTransition *transition){
            NSLog(@"did exit %@",[state name]);
        }];
        
       [self.stateMachine addState:state];
        
    }
    
}

-(void)nextState{
    
    NSLog(@"----------------------------");
    TKStateMachine *newStateMachine = [self.stateMachine copy];
    
    NSString *currentTitle = self.cuesStore[@"cues"][self.currentCueIndex][@"title"];

    self.currentCueIndex++;

    if(self.currentCueIndex >= [self.cuesStore[@"cues"] count]){
        self.currentCueIndex  = 0;
    }
    
    NSString *nextTitle = self.cuesStore[@"cues"][self.currentCueIndex][@"title"];
    
    TKState *current = [newStateMachine stateNamed:currentTitle];
    TKState *nextState = [newStateMachine stateNamed:nextTitle];

    newStateMachine.initialState = current;
    
//    NSLog(@"%@->%@",[current name],[nextState name]);

    NSString *eventName = [NSString stringWithFormat:@"%@%@",[current name],[nextState name]];
    
    TKEvent *nextEvent = [TKEvent eventWithName:eventName transitioningFromStates:@[current] toState:nextState];

    
    [newStateMachine addEvent:nextEvent];
    [newStateMachine activate];
    
    NSDictionary *userInfo = nil;
    NSError *error = nil;

    BOOL success = [newStateMachine fireEvent:eventName userInfo:userInfo error:&error];
    
    self.stateMachine = [newStateMachine copy];
    
}

@end
/*    TKStateMachine *inboxStateMachine = [TKStateMachine new];
 
 TKState *unread = [TKState stateWithName:@"Unread"];
 [unread setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
 NSLog(@"enter unread");
 }];
 TKState *read = [TKState stateWithName:@"Read"];
 [read setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
 NSLog(@"%@->%@",[[transition sourceState] name],[[transition destinationState] name]);
 NSLog(@"enter read");
 }];
 [read setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
 NSLog(@"exit read");
 }];
 TKState *deleted = [TKState stateWithName:@"Deleted"];
 [deleted setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
 NSLog(@"deleted");
 }];
 
 [inboxStateMachine addStates:@[ unread, read, deleted ]];
 inboxStateMachine.initialState = unread;
 
 TKEvent *viewMessage = [TKEvent eventWithName:@"View Message" transitioningFromStates:@[ unread ] toState:read];
 TKEvent *deleteMessage = [TKEvent eventWithName:@"Delete Message" transitioningFromStates:@[ read, unread ] toState:deleted];
 TKEvent *markAsUnread = [TKEvent eventWithName:@"Mark as Unread" transitioningFromStates:@[ read, deleted ] toState:unread];
 
 [inboxStateMachine addEvents:@[ viewMessage, deleteMessage, markAsUnread ]];
 
 // Activate the state machine
 [inboxStateMachine activate];
 
 //[inboxStateMachine isInState:@"Unread"]; // YES, the initial state
 
 
 
 // Fire some events
 NSDictionary *userInfo = nil;
 NSError *error = nil;
 BOOL success = [inboxStateMachine fireEvent:@"View Message" userInfo:userInfo error:&error]; // YES
 
 NSLog(@"%d",success);
 
 
 
 Cue
 Go
 Stop
 Pause
 
 <>previous
 <>next
 
 */




