//
//  PhotoModel.m
//  MVVM_Reactive
//
//  Created by Uber on 20/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "HDPhotoModel.h"

@implementation HDPhotoModel

- (instancetype)initFromUIImageView:(UIImageView*) imgView
{
    self = [super init];
    if (self)
    {
        if (imgView.image)
            self.image = imgView.image;
    }
    return self;
}

- (instancetype)initFromUIImage:(UIImage*) img
{
    self = [super init];
    if (self)
    {
        if (img)
            self.image = img;
    }
    return self;
}

@end
