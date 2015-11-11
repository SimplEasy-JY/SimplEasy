//
//  JYClassifyModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/10.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYClassifyModel : JYBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *selectedIcon;
@property (nonatomic, strong) NSArray *subClass;
@property (nonatomic, getter=isSelected) BOOL selected;
@end
