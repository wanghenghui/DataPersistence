//
//  ViewController1.m
//  DataPersistence
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "ViewController1.h"
#import "PersonDAO.h"
@interface ViewController1 ()
@property (weak, nonatomic) IBOutlet UITextField *id_tf;
@property (weak, nonatomic) IBOutlet UITextField *name_tf;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSArray *arr = @[@"插入", @"删除", @"修改", @"查询", @"主键"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200 + 30 * i, 80, 20)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
    }
    
}

- (void)action:(UIButton *)btn {
    PersonDAO *personDAO = [PersonDAO sharedManager];
    switch (btn.tag - 10) {
        case 0://插入
        {
            Person *model = [[Person alloc] init];
            model.ID = _id_tf.text;
            model.name = _name_tf.text;
            [personDAO create:model];
            
        }
            break;
        case 1://删除
        {
            [personDAO remove:_id_tf.text];
        }
            break;
        case 2://修改
        {
            Person *model = [[Person alloc] init];
            model.ID = _id_tf.text;
            model.name = _name_tf.text;
            [personDAO modify:model];
        }
            break;
        case 3://查询
        {
            NSArray *arr = [personDAO findAll];
            for (Person *person in arr) {
                NSLog(@"%@--%@", person.ID, person.name);
            }
        }
            break;
        case 4://主键
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
