//
//  MDPinCollectionView.m
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPinCollectionView.h"
#import "MDPinCollectionCell.h"

@implementation MDPinCollectionView{
    UICollectionViewFlowLayout *vFlowLayout;
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        vFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        vFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        vFlowLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        vFlowLayout.minimumInteritemSpacing = 0;
        vFlowLayout.minimumLineSpacing = 0;
        vFlowLayout.headerReferenceSize = CGSizeMake(0.0f, 30.0f);
        vFlowLayout.footerReferenceSize = CGSizeMake(0.0f, 30.0f);
        vFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:vFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setPagingEnabled:YES];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [self.collectionView setCollectionViewLayout:vFlowLayout animated:YES];
        
        [self.collectionView registerClass:[MDPinCollectionCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        [self addSubview:self.collectionView];
    }
    return self;
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _packageList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDPinCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell"
                                                                              forIndexPath:indexPath];
    [cell setCellData:[_packageList objectAtIndex:indexPath.section]];
    cell.delegate = self;
    return cell;
}

-(void) contentPushed:(MDPin *)pin{
    if([self.cellDelegate respondsToSelector:@selector(cellContentPushed:)]){
        [self.cellDelegate cellContentPushed:pin];
    }
}


@end
