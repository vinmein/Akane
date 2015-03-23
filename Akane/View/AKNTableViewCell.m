//
// This file is part of Akkane
//
// Created by JC on 07/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNTableViewCell.h"
#import "AKNViewModel.h"

@implementation AKNTableViewCell

@synthesize itemView = _itemView;

- (void)attachViewModel:(id<AKNViewModel>)viewModel {
    self.itemView.viewModel = viewModel;

    if ([viewModel respondsToSelector:@selector(willMount)]) {
        [viewModel willMount];
    }
}

- (void)setItemView:(UIView<AKNViewConfigurable> *)itemView {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(itemView);

    if (itemView == _itemView) {
        return;
    }

    [_itemView removeFromSuperview];
    _itemView = itemView;
    itemView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:itemView];
    // iOS7 compatibility
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[itemView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
}

@end
