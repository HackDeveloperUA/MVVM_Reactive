//
//  LoginVC-VM-AccountsData.m
//  MVVM_NonReactive
//
//  Created by Uber on 27/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "HDAccountsDataViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation HDAccountsDataViewModel

#pragma mark - UI Handler

- (RACSignal*) signInBtnClicked:(NSString*)login
                        andPass:(NSString*) pass
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [[[ServerManager sharedManager] getAccountsData]
           subscribeNext:^(NSDictionary* response){
              
           if ([[response objectForKey:login] isEqualToString:pass]){
               [subscriber sendCompleted];
           } else {
               SMErrorAuthentication* err = [[SMErrorAuthentication alloc] initWithTitle:@"Ошибка"
                                                                            withSubtitle:@"Неправильный логин или пароль"
                                                                             withMessage:@""];
               [subscriber sendError:err];
                  }
         }];
        
        return nil;
    }];
}
@end


