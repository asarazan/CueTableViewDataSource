//
//  TableViewSectionProviderImpl.m
//  Cue
//
//  Created by Aaron Sarazan on 4/21/12.
//  Copyright (c) 2012 Cue, Inc. All rights reserved.
//

#import "TableViewSectionProviderImpl.h"
#import "SectionProviderTableViewDelegate.h"

NSString * const SectionAttributeHeaderTitle    =@"SectionAttributeHeaderTitle";
NSString * const SectionAttributeHeaderColor    =@"SectionAttributeHeaderColor";
NSString * const SectionAttributeHeaderHeight   =@"SectionAttributeHeaderHeight";
NSString * const SectionAttributeHeaderLines    =@"SectionAttributeHeaderLines";
NSString * const SectionAttributeHeaderFont     =@"SectionAttributeHeaderFont";
NSString * const SectionAttributeHeaderAlign    =@"SectionAttributeHeaderAlign";

@implementation TableViewSectionProviderImpl

- (id)init;
{
    self = [super init];
    if (self) {

        _footerAttributes = [[NSMutableDictionary alloc] init];
        //[_footerAttributes setObject:[NSNumber numberWithFloat:48] forKey:SectionAttributeHeaderHeight];
        [_footerAttributes setObject:[UIColor grayColor] forKey:SectionAttributeHeaderColor];
        //[_footerAttributes setObject:[NSNumber numberWithInt:UITextAlignmentCenter] forKey:SectionAttributeHeaderAlign];
        //[_footerAttributes setObject:[NSNumber numberWithInt:2] forKey:SectionAttributeHeaderLines];
        //[_footerAttributes setObject:[UIFont footerFont] forKey:SectionAttributeHeaderFont];

        [self update];
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(UITableView *)tableView;
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRow:(NSUInteger)row;
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSUInteger)row;
{
    return 44.0f;
}

- (CGFloat)heightForHeaderInTableView:(UITableView *)tableView;
{
    return [self titleForHeaderInTableView:tableView] ? kCueTableViewHeaderHeight : 0.0f;
}

- (NSString *)titleForHeaderInTableView:(UITableView *)tableView;
{
    return nil;
}

- (NSString *)titleForFooterInTableView:(UITableView *)tableView;
{
    return [self.footerAttributes objectForKey:SectionAttributeHeaderTitle];
}

- (void)tableView:(UITableView *)tableView didSelectCellAtRow:(NSUInteger)row;
{
    // Nothing
}

- (void)update;
{

}

- (CGFloat)heightForFooterInTableView:(UITableView *)tableView;
{
    if (self.useDividerForFooter) {
        return 32;
    }

    NSString * title = [self.footerAttributes objectForKey:SectionAttributeHeaderTitle];
    if (!title) {
        return 0.0f;
    }

    NSNumber * height = [self.footerAttributes objectForKey:SectionAttributeHeaderHeight];
    if (height) {
        return [height floatValue];
    }

    if ([title length]) {
        UIFont * font = [self.footerAttributes objectForKey:SectionAttributeHeaderFont];
        CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(300, MAXFLOAT)];
        return size.height + 10;
    }

    return [tableView cueHeightForFooterInSection:_section];
}

@end
