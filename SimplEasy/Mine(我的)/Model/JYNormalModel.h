//
//  JYNormalModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYNormalModel : JYBaseModel

/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 数据 */
@property (nonatomic, copy) NSString *data;
/** 代码 */
@property (nonatomic, copy) NSString *code;


@end
