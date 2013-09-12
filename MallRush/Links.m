//
//  Links.m
//  MallRush
//
//  Created by Ivelin Ivanov on 9/12/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "Links.h"

@implementation Links

- (id)initWithNodeA:(Node *)nodeA nodeB:(Node *)nodeB andWeight:(NSUInteger)weight {
    
    if (self = [super init]) {
        self.nodeA = nodeA;
        self.nodeB = nodeB;
        self.weight = weight;
    }
    
    return  self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@ - %@ : %d", self.nodeA, self.nodeB, self.weight];
    
}

@end
