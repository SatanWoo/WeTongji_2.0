//
//  EditInfoCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-12.
//
//

#import "EditInfoCell.h"

@implementation EditInfoCell
@synthesize name;
@synthesize field;
@synthesize type=_type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setIsEditEnable:(BOOL)isEditEnable
{
    if (( isEditEnable ) &&
        ( self.type == EditInfoCellTypePhone ||
          self.type == EditInfoCellTypeQQ ||
          self.type == EditInfoCellTypeEmail ||
          self.type == EditInfoCellTypeWeibo))
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.field setEnabled:YES];
    }
    else
    {
        [self setBackgroundColor:[UIColor yellowColor]];
        [self.field setEnabled:NO];
    }
}

-(void) setType:(EditInfoCellType)type
{
    switch (type) {
        case EditInfoCellTypeStudentNumber:
            self.name.text = @"学号";
            break;
        case EditInfoCellTypeDepartment:
            self.name.text = @"学院";
            break;
        case EditInfoCellTypeMajor:
            self.name.text = @"专业";
            break;
        case EditInfoCellTypeYear:
            self.name.text = @"入学年份";
            break;
        case EditInfoCellTypePhone:
            self.name.text = @"手机";
            break;
        case EditInfoCellTypeQQ:
            self.name.text = @"QQ";
            break;
        case EditInfoCellTypeEmail:
            self.name.text = @"电子邮箱";
            break;
        case EditInfoCellTypeWeibo:
            self.name.text = @"新浪微博";
            break;
        default:
            break;
    }
    _type = type;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
