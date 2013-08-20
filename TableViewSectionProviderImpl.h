//
//  TableViewSectionProviderImpl.h
//  Cue
//
//  Created by Aaron Sarazan on 4/21/12.
//  Copyright (c) 2012 Cue, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewSectionProvider.h"

@interface TableViewSectionProviderImpl : NSObject <TableViewSectionProvider>

@property NSInteger section;
@property BOOL useDividerForFooter;
@property (readonly) NSMutableDictionary * footerAttributes;

- (void)update;

@end
