//
//  TableViewSectionProvider.h
//  Cue
//
//  Created by Aaron Sarazan on 10/17/11.
//  Copyright (c) 2011 Cue, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SectionAttributeHeaderTitle;
extern NSString * const SectionAttributeHeaderColor;
extern NSString * const SectionAttributeHeaderHeight;
extern NSString * const SectionAttributeHeaderLines;
extern NSString * const SectionAttributeHeaderFont;
extern NSString * const SectionAttributeHeaderAlign;

extern const CGFloat kCueTableViewHeaderHeight;
extern const CGFloat kCueTableViewFooterHeight;

@protocol TableViewSectionProvider <NSObject>

@required
- (NSInteger)numberOfRowsInTableView:(UITableView *)tableView;
- (void)setSection:(NSInteger)section;
- (void)update;

@optional
// These three didn't work out at all. Stop using them.
- (NSString *)reuseIdentifierForCellAtRow:(NSUInteger)row __attribute__((deprecated));
- (UITableViewCell*)tableView:(UITableView *)tableView initializeCellAtRow:(NSUInteger)row __attribute__((deprecated));
- (UITableViewCell*)tableView:(UITableView *)tableView updateCell:(UITableViewCell*)cell row:(NSUInteger)row __attribute__((deprecated));

// Stick with this one.
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRow:(NSUInteger)row;

- (UIView*)viewForHeaderInTableView:(UITableView *)tableView;
- (UIView*)viewForFooterInTableView:(UITableView *)tableView;

- (NSString *)titleForHeaderInTableView:(UITableView *)tableView;
- (NSString *)titleForFooterInTableView:(UITableView *)tableView;

- (CGFloat)heightForHeaderInTableView:(UITableView *)tableView;
- (CGFloat)heightForFooterInTableView:(UITableView *)tableView;

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSUInteger)row;
- (void)tableView:(UITableView *)tableView didSelectCellAtRow:(NSUInteger)row;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRow:(NSUInteger)row;

- (NSString *)sectionIndexTitleForTableView:(UITableView *)tableView;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRow:(NSInteger)row;

- (NSArray *)items;

@end
