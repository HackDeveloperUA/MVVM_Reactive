//
//  Router.m
//  ViewControllers_Lesson
//
//  Created by Uber on 31/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//


// https://stackoverflow.com/questions/18331751/storyboard-and-custom-init
#import "HDRouter.h"


 // Controllers
 #import "LoginVC.h"
 #import "WorkerTVC.h"
 #import "DetailVC.h"
 #import "PsychedelicDetailTVC.h"
 // From custom library
 #import <NYTPhotoViewer/NYTPhotosViewController.h>

 // ViewModels
 #import "ViewModel_AccountsData.h"
 #import "ViewModel_ListOfWorkers_TableView.h"
 #import "ViewModel_Worker_Detail.h"
 #import "ViewModel_ListOfPsychedelicWorkers_TableView.h"

// Model
#import "WorkerFull.h"
#import "PhotoModel.h"

@implementation HDRouter

#pragma mark - Core

+ (HDRouter*) sharedRouter {
    
    static HDRouter* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HDRouter alloc] init];
        manager.window = [HDRouter getApplicationWindow];
    });
    return manager;
}



#pragma mark - Open Controllers

- (void) openApplication
{
    BOOL isLogin = [self getIsLoginFromUserDefault];
    
    if (!isLogin){
        [self openLoginVC];
    } else {
        [self openWorkersTVC];
    }
}


#pragma mark - Open Controllers

- (void) openLoginVC
{
    LoginVC* vc = [[LoginVC alloc] init];
    vc.vmAccountsData       = [[ViewModel_AccountsData alloc] init];
    
    [HDRouter setToRootView:vc andAnimationOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}


- (void) openWorkersTVC
{
    if (![self haveControllerForMenuInMemory]){
         [self initInMemoryControllersForMenu];
    }
    [HDRouter setToRootView:self.mainNavContr andAnimationOptions:UIViewAnimationOptionTransitionFlipFromRight];
}


- (void) openDetailVCwithLinkOnFullCV:(NSString*) link
{
    DetailVC* vc = [DetailVC new];
    vc.vmWorkerDetail = [[ViewModel_Worker_Detail alloc] initWithLinkOnFull_CV_Model: link];
    
    if ([self haveControllerForMenuInMemory]){
        [HDRouter pushTo:vc inNavContr:self.mainNavContr];
    }
}

- (void) openPsychedelicDetailTVC:(WorkerFull*) workerModel
{
    ViewModel_ListOfPsychedelicWorkers_TableView* vm = [[ViewModel_ListOfPsychedelicWorkers_TableView alloc] initWithWorker:workerModel];
    
    PsychedelicDetailTVC* vc = [[PsychedelicDetailTVC alloc] initWithVM:vm];
    
    
    if ([self haveControllerForMenuInMemory]){
        [HDRouter pushTo:vc inNavContr:self.mainNavContr];
    }
}


- (void) openNYTPhotovVCwithPhotoModel:(id<NYTPhoto>) photoModel
{
    NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photoModel]];
    [HDRouter present:photoVC animated:YES];
}

#pragma mark - NSUserDefault

- (void) setIsLoginInUserDefaults:(BOOL) isLogin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:isLogin]  forKey:@"isLogin"];
}


- (BOOL) getIsLoginFromUserDefault
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"isLogin"];
}


#pragma mark - Helpers

- (BOOL) haveControllerForMenuInMemory
{
    if (_mainNavContr && _mainWorkersTVC)
        return YES;
    return NO;
}


- (void) initInMemoryControllersForMenu
{
    self.mainWorkersTVC = [[WorkerTVC alloc] init];
    self.mainWorkersTVC.vmListOfWorkers_TableView = [[ViewModel_ListOfWorkers_TableView alloc] init];
    self.mainNavContr = [[UINavigationController alloc] initWithRootViewController: _mainWorkersTVC];

    self.mainNavContr.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.mainNavContr.navigationBar.tintColor = [UIColor whiteColor];
    [self.mainNavContr.navigationBar setTitleTextAttributes:  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18]}];
}


- (void) removeFromMemoryControllersForMenu
{
    self.mainWorkersTVC = nil;
    self.mainNavContr   = nil;
}




@end
