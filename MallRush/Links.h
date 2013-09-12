//
//  Links.h
//  MallRush
//
//  Created by Ivelin Ivanov on 9/12/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface Links : NSObject

@property (strong, nonatomic) Node *nodeA;
@property (strong, nonatomic) Node *nodeB;
@property (assign, nonatomic) NSInteger weight;
@property (weak, nonatomic) UIImageView *pathImageView;

- (id)initWithNodeA:(Node *)nodeA nodeB:(Node *)nodeB andWeight:(NSUInteger)weight;

@end
