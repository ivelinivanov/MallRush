//
//  Node.m
//  MallRush
//
//  Created by Ivelin Ivanov on 9/12/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "Node.h"

@implementation Node

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Node Links: %d", self.links.count];
}

@end
