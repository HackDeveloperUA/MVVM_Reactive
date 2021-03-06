//
//  Router.h
//  ViewControllers_Lesson
//
//  Created by Uber on 31/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//


// Base Router Implemetation
#import "CoreRouter.h"
#import <NYTPhotoViewer/NYTPhoto.h>

//Controllers
@class HDLoginVC;
@class WorkerTVC;
@class DetailVC;
@class HDPsychedelicDetailTVC;

//ViewModels
@class ViewModel_AccountsData;
@class ViewModel_ListOfWorkers_TableView;
@class ViewModel_ListOfPsychedelicWorkers_TableView;
@class ViewModel_Worker_Detail;

//Models
@class WorkerFull;
@class PhotoModel;
@class NYTPhoto;

#import "CoreRouterProtocol.h"

@interface HDRouter : CoreRouter <CoreRouterProtocol>

//  Core
+ (HDRouter*) sharedRouter;

@property (nonatomic, strong) UINavigationController* mainNavContr;
@property (nonatomic, strong) WorkerTVC* mainWorkersTVC;

// Open Controllers
- (void) openApplication;
- (void) openLoginVC;
- (void) openWorkersTVC;
- (void) openDetailVCwithLinkOnFullCV:(NSString*) link;
- (void) openPsychedelicDetailTVC:(WorkerFull*) workerModel;
- (void) openNYTPhotovVCwithPhotoModel:(id<NYTPhoto>) photoModel;



#pragma mark - Routing method & propierties

// NSUserDefaults properties
@property (nonatomic, assign) BOOL isLogin;

- (void) setIsLoginInUserDefaults:(BOOL) isLogin;
- (BOOL) getIsLoginFromUserDefault;

@end


