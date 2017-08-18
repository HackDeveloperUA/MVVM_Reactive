//
//  DetailController_VM.h
//  MVVM_NonReactive
//
//  Created by Uber on 09/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkerFull.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewModel_Worker_Detail : NSObject

@property (nonatomic, strong) NSString* fullNameTitle;
@property (nonatomic, strong) NSString* postTitle;
@property (nonatomic, strong) NSString* mainTextTitle;
@property (nonatomic, strong) NSString* cvImageURL;
@property (nonatomic, strong) NSString* linkOnFullCV;


@property (nonatomic) RACSignal *fullName_Signal;     //NSString
@property (nonatomic) RACSignal *postTitle_Signal;    //NSString
@property (nonatomic) RACSignal *cvImageURL_Signal;   //NSString
@property (nonatomic) RACSignal *mainText_Signal;     //NSString
@property (nonatomic) RACSignal *linkOnFullCV_Signal; //NSString

// Link on model
@property (nonatomic, strong) WorkerFull *modelData;

#pragma mark - Binding methods
- (void)bindSignals;

#pragma mark - Init methods

- (instancetype)initWithWorker:(WorkerFull*) worker;
- (instancetype)initWithLinkOnFull_CV_Model:(NSString*) link;


#pragma mark - None Reactive API Method

- (void) getDetailWorkerModelFromServer:(NSString*) link
                             onSuccess:(void(^)(BOOL successOperation)) success
                              onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode)) failure;

#pragma mark - Reactive API Method

- (RACSignal*) getSignal_DetailWorkerModelFromServer:(NSString*) link;


#pragma mark - UI handlers

- (void) goToPscychedelicTVC_Clicked;

@end
