//
//  CollectionViewCell.h
//  NewPipe
//
//  Created by Somiya on 2018/12/11.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface CollectionViewCell : BaseCollectionViewCell
- (void)configCellData:(id)data title:(NSString *)title;
@end
