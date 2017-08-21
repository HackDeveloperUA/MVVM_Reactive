//
//  DetailController_VM.h
//  MVVM_NonReactive
//
//  Created by Uber on 09/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

// Another fraemworks
#import <NYTPhotoViewer/NYTPhoto.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class WorkerFull;
@class PhotoModel;
@class NYTPhoto;

@interface ViewModel_Worker_Detail : NSObject

// Link on model
@property (nonatomic, strong) WorkerFull *model;

@property (nonatomic, strong) NSString* fullNameTitle;
@property (nonatomic, strong) NSString* postTitle;
@property (nonatomic, strong) NSString* mainTextTitle;
@property (nonatomic, strong) NSString* cvImageURL;
@property (nonatomic, strong) NSString* linkOnFullCV;


#pragma mark - Signals for normal data
@property (nonatomic) RACSignal *fullName_Signal;     //NSString
@property (nonatomic) RACSignal *postTitle_Signal;    //NSString
@property (nonatomic) RACSignal *cvImageURL_Signal;   //NSString
@property (nonatomic) RACSignal *mainText_Signal;     //NSString
@property (nonatomic) RACSignal *linkOnFullCV_Signal; //NSString

#pragma mark - Init methods

- (instancetype)initWithWorker:(WorkerFull*) worker;
- (instancetype)initWithLinkOnFull_CV_Model:(NSString*) link;


#pragma mark - Binding methods
- (void)bindSignals;


#pragma mark - UI handlers

- (void) goToPscychedelicTVC_Clicked;
- (void) openImgCVonFullScreenWithPhotoModel:(id<NYTPhoto>) model;

#pragma mark - API

#pragma mark - Setters

@end
