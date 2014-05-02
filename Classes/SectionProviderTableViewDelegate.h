//
//  SectionProviderTableViewDelegate.h
//  Cue
//
//  Created by Aaron Sarazan on 10/28/11.
//  Copyright (c) 2011 Cue, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewSectionProvider.h"

@interface UITableView (Cue)

- (CGFloat)cueHeightForFooterInSection:(NSInteger)section;
- (CGFloat)cueHeightForHeaderInSection:(NSInteger)section;

@end

@interface SectionProviderTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (assign) UIView *searchBar;
@property (copy) NSArray *providers;
@property BOOL showSectionIndex;
@property BOOL showMagnifierSectionIndex;
@property BOOL showFavoritesSectionIndex;
@property BOOL scrollsToTop;

- (id)initWithProviders:(NSArray *)providers;
- (id<TableViewSectionProvider>)providerForSection:(NSInteger)section;
- (void)update;

+ (id)delegateWithProviders:(NSArray *)providers;

@end
