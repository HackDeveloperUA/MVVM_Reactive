//
//  WorkerTVC.h
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

// ViewModeles
#import "ViewModel_ListOfWorkers_TableView.h"

/*
 RU:
 Экран с таблицией топ работников Apple
 
 EN:
 The screen with table top Apple workers
 */

@class Router;

@interface HDWorkerTVC : UITableViewController

@property (nonatomic, strong) ViewModel_ListOfWorkers_TableView* vmListOfWorkers_TableView; // link on controller viewmodel

@end
