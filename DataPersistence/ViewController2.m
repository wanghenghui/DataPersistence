//
//  ViewController2.m
//  DataPersistence
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "ViewController2.h"
#import "SqliteManager.h"
@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UITextField *id_tf;
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (nonatomic, strong)SqliteManager *manager;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [SqliteManager sharedManager];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)insert:(id)sender {
    Person *model = [[Person alloc] init];
    model.ID = _id_tf.text;
    model.name = _name_tf.text;
    [_manager create:model];
}



- (IBAction)findAll:(id)sender {
    NSArray *arr = [_manager findAll];
    for (Person *model in arr) {
        NSLog(@"id:%@, name:%@", model.ID, model.name);
    }
}
 
- (IBAction)search:(id)sender {
    Person *person = [_manager findByID:_id_tf.text];
    NSLog(@"id:%@, name:%@", person.ID, person.name);
}

- (IBAction)delete:(id)sender {
    Person *model = [[Person alloc] init];
    model.ID = _id_tf.text;
    model.name = _name_tf.text;
    [_manager remove:model];
}

- (IBAction)change:(id)sender {
    Person *model = [[Person alloc] init];
    model.ID = _id_tf.text;
    model.name = _name_tf.text;
    [_manager modify:model];
}










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
