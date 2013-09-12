//
//  Node.h
//  MallRush
//
//  Created by Ivelin Ivanov on 9/12/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (copy, nonatomic) NSMutableArray *links;
@property (weak, nonatomic) UIImageView *shopView;

@end
