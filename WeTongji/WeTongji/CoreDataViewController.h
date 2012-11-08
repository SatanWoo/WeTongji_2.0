//
//  CoreDataViewController.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-8.
//
//

#import <UIKit/UIKit.h>

@interface CoreDataViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


- (void)saveContext;

@end
