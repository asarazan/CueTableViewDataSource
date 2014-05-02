//
//  SectionProviderTableViewDelegate.m
//  Cue
//
//  Created by Aaron Sarazan on 10/28/11.
//  Copyright (c) 2011 Cue, Inc. All rights reserved.
//

#import "SectionProviderTableViewDelegate.h"

const CGFloat kCueTableViewHeaderHeight = 36.0f;
const CGFloat kCueTableViewFooterHeight = 36.0f;

@implementation UITableView (Cue)

- (CGFloat)cueHeightForHeaderInSection:(NSInteger)section;
{
    id<UITableViewDelegate> delegate = self.delegate;
    id<UITableViewDataSource> dataSource = self.dataSource;
    
    BOOL show = NO;
    
    if ([dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        show |= !![dataSource tableView:self titleForHeaderInSection:section];
    }
    
    if (!show && [delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        show |= !![delegate tableView:self viewForHeaderInSection:section];
    }
    
    return show ? kCueTableViewHeaderHeight : 0.0f;
}

- (CGFloat)cueHeightForFooterInSection:(NSInteger)section;
{
    id<UITableViewDelegate> delegate = self.delegate;
    id<UITableViewDataSource> dataSource = self.dataSource;
    
    BOOL show = NO;
    
    if ([dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        show |= !![dataSource tableView:self titleForFooterInSection:section];
    }
    
    if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        show |= !![delegate tableView:self viewForFooterInSection:section];
    }
    
    return show ? kCueTableViewFooterHeight : 0.0f;
}

@end

@implementation SectionProviderTableViewDelegate

+ (id)delegateWithProviders:(NSArray *)providers;
{
    return [[self alloc] initWithProviders:providers];
}

- (id)initWithProviders:(NSArray *)providers;
{
    self = [super init];
    if (self) {
        self.providers = providers;
        _scrollsToTop = YES;

        // Set the section index for all of our providers
        int i = 0;
        for (id<TableViewSectionProvider> provider in self.providers) {
            [provider setSection:i++];
        }
    }
    return self;
}

- (id<TableViewSectionProvider>)providerForSection:(NSInteger)section;
{
    return [self.providers objectAtIndex:section];
}

- (void)update;
{
    for (id provider in self.providers) {
        [provider update];
    }
}

#pragma mark - Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)targetContentOffset;
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [self.providers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self.providers objectAtIndex:section] numberOfRowsInTableView:tableView];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    id<TableViewSectionProvider> provider = [self.providers objectAtIndex:section];
    if ([provider respondsToSelector:@selector(tableView:updateCell:row:)]) {
        NSString * identifier = @"Cell";
        if ([provider respondsToSelector:@selector(reuseIdentifierForCellAtRow:)]) {
            identifier = [provider reuseIdentifierForCellAtRow:row];
        }

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            if ([provider respondsToSelector:@selector(tableView:initializeCellAtRow:)]) {
                cell = [provider tableView:tableView initializeCellAtRow:row];
            } else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
        }

        cell = [provider tableView:tableView updateCell:cell row:row];
        return cell;
    }

    return [provider tableView:tableView cellForRow:row];
}

#pragma clang diagnostic pop

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if ([[self.providers objectAtIndex:section] respondsToSelector:@selector(titleForHeaderInTableView:)]) {
        return [[self.providers objectAtIndex:section] titleForHeaderInTableView:tableView];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
    if ([[self.providers objectAtIndex:section] respondsToSelector:@selector(titleForFooterInTableView:)]) {
        return [[self.providers objectAtIndex:section] titleForFooterInTableView:tableView];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
{
    id first = self.providers.count > 0 ? self.providers[0] : nil;
    if (![first respondsToSelector:@selector(sectionIndexTitleForTableView:)]) {
        return nil;
    }

    if (!_showSectionIndex) {
        return nil;
    }

    NSMutableArray * retval = [NSMutableArray array];

    if (self.showMagnifierSectionIndex) {
        [retval addObject:UITableViewIndexSearch];
    }

    if (self.showFavoritesSectionIndex) {
        [retval addObject:@"\u2605"];
    }

    for (id<TableViewSectionProvider> provider in self.providers) {
        [retval addObject:[provider sectionIndexTitleForTableView:tableView]];
    }

    return retval;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    if (self.showMagnifierSectionIndex) {
        index--;
    }

    if (self.showFavoritesSectionIndex) {
        index--;
    }

    if (index < 0) {
        CGRect frame;

        if (index == -2 || (index == -1 && !self.showFavoritesSectionIndex)) { // magnifier
            frame = self.searchBar.frame;
        } else if (index == -1) { // favorites
            frame = self.searchBar.frame;
            frame.origin.y += frame.size.height;
            frame.size.height = tableView.frame.size.height;
        }

        [tableView scrollRectToVisible:frame animated:NO];
    }

    return index;
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([[self.providers objectAtIndex:indexPath.section] respondsToSelector:@selector(tableView:editingStyleForRow:)]) {
        return [[self.providers objectAtIndex:indexPath.section] tableView:tableView editingStyleForRow:indexPath.row];
    }
    return UITableViewCellEditingStyleNone;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[self.providers objectAtIndex:section] respondsToSelector:@selector(heightForHeaderInTableView:)]) {
        return [[self.providers objectAtIndex:section] heightForHeaderInTableView:tableView];
    }
    return [tableView cueHeightForHeaderInSection:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[self.providers objectAtIndex:section] respondsToSelector:@selector(viewForHeaderInTableView:)]) {
        return [[self.providers objectAtIndex:section] viewForHeaderInTableView:tableView];
    }
    return [tableView headerViewForSection:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([[self.providers objectAtIndex:section] respondsToSelector:@selector(heightForFooterInTableView:)]) {
        return [[self.providers objectAtIndex:section] heightForFooterInTableView:tableView];
    }
    return [tableView cueHeightForFooterInSection:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([[self.providers objectAtIndex:section] respondsToSelector:@selector(viewForFooterInTableView:)]) {
        return [[self.providers objectAtIndex:section] viewForFooterInTableView:tableView];
    }
    return [tableView footerViewForSection:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self.providers objectAtIndex:indexPath.section] respondsToSelector:@selector(tableView:didSelectCellAtRow:)]) {
        @try {
            [[self.providers objectAtIndex:indexPath.section] tableView:tableView didSelectCellAtRow:indexPath.row];
        } @catch (NSException * e) {
            NSLog(@"%@", e);
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    if ([[self.providers objectAtIndex:indexPath.section] respondsToSelector:@selector(tableView:accessoryButtonTappedForRow:)]) {
        [[self.providers objectAtIndex:indexPath.section] tableView:tableView accessoryButtonTappedForRow:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([[self.providers objectAtIndex:indexPath.section] respondsToSelector:@selector(tableView:heightForRow:)]) {
        return [[self.providers objectAtIndex:indexPath.section] tableView:tableView heightForRow:indexPath.row];
    }
    return 44.0f;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
{
    return !scrollView.hidden;
}

@end
