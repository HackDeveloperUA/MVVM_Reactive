//
//  ViewModel_WorkerBigName_Cell.h
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewModel_BasedWorker_Cell.h"

// Reactive
#import <ReactiveCocoa/ReactiveCocoa.h>


@class WorkerFull;

@interface ViewModel_WorkerBigName_Cell : ViewModel_BasedWorker_Cell

@property (nonatomic, strong) WorkerFull* model; // link on model

@property (nonatomic, strong) NSString* fullNameTitle;
@property (nonatomic, strong) NSString* postInCompany;



@property (nonatomic) RACSignal *fullNameSignal;   //NSString
@property (nonatomic) RACSignal *postTitleSignal;  //NSString


#pragma mark - Init methods
- (instancetype)initWithWorker:(WorkerFull*) worker;

#pragma mark - Binding methods
- (void)bindSignals;

@end
