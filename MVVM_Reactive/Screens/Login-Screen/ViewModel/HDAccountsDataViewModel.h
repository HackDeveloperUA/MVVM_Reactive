//
//  LoginVC-VM-AccountsData.h
//  MVVM_NonReactive
//
//  Created by Uber on 27/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

// ServerManager
#import "ServerManager.h"

// Error Handlers
#import "SMErrorAuthentication.h"


@interface HDAccountsDataViewModel : NSObject

#pragma mark - UI Handler


- (RACSignal*) signInBtnClicked:(NSString*)login
                        andPass:(NSString*) pass;

@end


