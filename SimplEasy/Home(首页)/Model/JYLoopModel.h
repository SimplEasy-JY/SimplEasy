//
//  JYLoopModel.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class JYLoopImage;
@interface JYLoopModel : JYBaseModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<JYLoopImage *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface JYLoopImage : JYBaseModel

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger del;

@property (nonatomic, copy) NSString *src;

@property (nonatomic, copy) NSString *link;


@end

