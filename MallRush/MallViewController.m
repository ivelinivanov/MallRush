//
//  ViewController.m
//  MallRush
//
//  Created by Ivelin Ivanov on 9/12/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "MallViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Node.h"
#import "Links.h"

@interface MallViewController () {
    NSMutableArray *nodes;
    NSMutableArray *links;
    
    Node *selectedNode;
}

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shopsImageViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *pathImageViews;


@end

@implementation MallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    nodes = [[NSMutableArray alloc] initWithCapacity:8];
    links = [[NSMutableArray alloc] initWithCapacity:13];
    
    
    for (UIImageView *shopImageView in self.shopsImageViews) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopTapped:)];
        [shopImageView addGestureRecognizer:tapRecognizer];
    }
    
    [self buildGraph];
    
}

#pragma mark - Tap Handling

- (void)shopTapped:(UIGestureRecognizer *)recognizer {
    
    UIImageView *shopImageView = (UIImageView *)recognizer.view;
    
    for (UIImageView *shopView in self.shopsImageViews) {
        shopView.layer.borderWidth = 0;
        shopView.layer.borderColor = [UIColor clearColor].CGColor;
        shopView.userInteractionEnabled = NO;
    }
    
    shopImageView.layer.borderColor = [UIColor redColor].CGColor;
    shopImageView.layer.borderWidth = 3;
    
    selectedNode = nodes[shopImageView.tag - 1];
    
    NSLog(@"Selected node: %@", selectedNode);
    
    [self traceGraph];
    
}

#pragma mark - Graph Building

- (void)buildGraph {
    
    for (UIImageView *shopView in self.shopsImageViews) {
        Node *node = [[Node alloc] init];
        [nodes addObject:node];
        node.shopView = shopView;
    }
    
    Links *link12 = [[Links alloc] initWithNodeA:nodes[0] nodeB:nodes[1] andWeight:1];
    Links *link23 = [[Links alloc] initWithNodeA:nodes[1] nodeB:nodes[2] andWeight:2];
    Links *link34 = [[Links alloc] initWithNodeA:nodes[2] nodeB:nodes[3] andWeight:5];
    Links *link45 = [[Links alloc] initWithNodeA:nodes[3] nodeB:nodes[4] andWeight:7];
    Links *link56 = [[Links alloc] initWithNodeA:nodes[4] nodeB:nodes[5] andWeight:8];
    Links *link67 = [[Links alloc] initWithNodeA:nodes[5] nodeB:nodes[6] andWeight:1];
    Links *link78 = [[Links alloc] initWithNodeA:nodes[6] nodeB:nodes[7] andWeight:8];
    Links *link81 = [[Links alloc] initWithNodeA:nodes[7] nodeB:nodes[0] andWeight:3];
    Links *link28 = [[Links alloc] initWithNodeA:nodes[1] nodeB:nodes[7] andWeight:4];
    Links *link27 = [[Links alloc] initWithNodeA:nodes[1] nodeB:nodes[6] andWeight:5];
    Links *link37 = [[Links alloc] initWithNodeA:nodes[2] nodeB:nodes[6] andWeight:9];
    Links *link47 = [[Links alloc] initWithNodeA:nodes[3] nodeB:nodes[6] andWeight:7];
    Links *link46 = [[Links alloc] initWithNodeA:nodes[3] nodeB:nodes[5] andWeight:6];
    
    [links addObjectsFromArray:@[link12, link23, link34, link45, link56, link67, link78, link81, link28, link27, link37, link47, link46]];
    
    for (Node *node in nodes) {
        
        NSMutableArray *nodeLinks = [[NSMutableArray alloc] init];
        
        for (Links *link in links) {
            if ([node isEqual:link.nodeA] || [node isEqual:link.nodeB]) {
                [nodeLinks addObject:link];
            }
        }
        
        node.links = nodeLinks;
    }
    
    for (NSInteger i = 0; i < self.pathImageViews.count; i++) {
        UIImageView *pathImageView = self.pathImageViews[i];
        Links *link = links[i];
        
        link.pathImageView = pathImageView;
        
    }
    
    NSLog(@"Nodes: %@", nodes);
    NSLog(@"Links: %@", links);
    
}

#pragma mark - Graph Tracing

- (void)traceGraph {
    [UIView animateWithDuration:0.5 animations:^{
        for (Links *link in links) {
            link.pathImageView.alpha = 0.1;
        }
    } completion:^(BOOL finished) {
        NSMutableArray *possibleLinks = [selectedNode.links mutableCopy];
        NSMutableSet *searchedNodes = [[NSMutableSet alloc] init];
        
        CGFloat timeInterval = 0.0f;
        
        [searchedNodes addObject:selectedNode];
        
 
        while ([searchedNodes count] < [nodes count]) {
            Links *minLink = [self findMinimalLink:possibleLinks];
            
            [possibleLinks removeObject:minLink];
            
            if ([self addNode:minLink.nodeA toPossibleLinks:possibleLinks andSearchedNodes:searchedNodes] ||
                [self addNode:minLink.nodeB toPossibleLinks:possibleLinks andSearchedNodes:searchedNodes]) {
                
                timeInterval += 1.0f;
                
                
                [self performSelector:@selector(performBlock:) withObject:^{
                    minLink.pathImageView.alpha = 1.0;
                } afterDelay:timeInterval];
                
                NSLog(@"%@", minLink);

            }
        }
        
        [self performSelector:@selector(performBlock:) withObject:^{
            for (UIImageView *shopView in self.shopsImageViews) {
                shopView.userInteractionEnabled = YES;
            };
        } afterDelay:timeInterval];

    }];
}

- (BOOL)addNode:(Node *)node toPossibleLinks:(NSMutableArray *)possibleLinks andSearchedNodes:(NSMutableSet *)searchedNodes {
    if (![searchedNodes containsObject:node]) {
        [searchedNodes addObject:node];
        [possibleLinks addObjectsFromArray:node.links];
        
        return YES;
    }
    
    return NO;
}

- (Links *)findMinimalLink:(NSMutableArray *)possibleLinks {
    Links *minLink = possibleLinks[0];
    
    for (NSInteger i = 1; i < possibleLinks.count; i++) {
        Links *possibleLink = possibleLinks[i];
        
        if (minLink.weight > possibleLink.weight) {
            minLink = possibleLink;
        }
    }
    
    return minLink;
}

- (void)performBlock:(void (^)())block {
    block();
}

@end
