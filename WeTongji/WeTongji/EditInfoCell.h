//
//  EditInfoCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-12.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    EditInfoCellTypeStudentNumber = 0,
    EditInfoCellTypeDepartment,
    EditInfoCellTypeMajor,
    EditInfoCellTypeYear,
    EditInfoCellTypePhone,
    EditInfoCellTypeQQ,
    EditInfoCellTypeEmail
} EditInfoCellType;

@interface EditInfoCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *name;
@property (nonatomic ,weak) IBOutlet UITextField *field;
@property (nonatomic) EditInfoCellType type;

@end
