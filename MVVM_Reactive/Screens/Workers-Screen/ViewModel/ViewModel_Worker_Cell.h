//
//  WorkerCell-VM.h
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model
#import "WorkerShort.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewModel_Worker_Cell : NSObject

@property (nonatomic, strong) WorkerShort* model; // link on model

@property (nonatomic, strong) NSString* fullNameTitle;
@property (nonatomic, strong) NSString* postTitle;
@property (nonatomic, strong) NSString* cvImageURL;


@property (nonatomic) RACSignal *fullNameSignal;   //NSString
@property (nonatomic) RACSignal *postTitleSignal;  //NSString
@property (nonatomic) RACSignal *cvImageURLSignal; //NSString


#pragma mark - Inits methods
- (instancetype)initWithWorker:(WorkerShort*) worker;

#pragma mark - Binding methods
- (void)bindSignals;




@end
