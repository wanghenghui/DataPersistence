//
//  ViewController.m
//  数据持久化
//
//  Created by ma c on 2016/11/1.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "ViewController.h"
#import "NoteDAO.h"
@interface ViewController ()
@property (nonatomic, strong)UIDatePicker *picker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _picker = [[UIDatePicker alloc] init];
    //位置大小
    _picker.frame = CGRectMake(10, 20, 300, 100);
    //语言设置-中文
    _picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    
    [self.view addSubview:_picker];
    
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
    NoteDAO *noteDAO = [NoteDAO sharedManager];
    switch (btn.tag - 10) {
        case 0://插入
        {
            [noteDAO create:[self createNoteModel]];
        }
            break;
        case 1://删除
        {
            [noteDAO remove:[self createNoteModel]];
        }
            break;
        case 2://修改
        {
            [noteDAO modify:[self createNoteModel]];
        }
            break;
        case 3://查询
        {
            NSMutableArray *arr = [noteDAO findAll];
            for (Note *model in arr) {
                NSLog(@"查询结果:%@", model.content);
            }
            
        }
            break;
        case 4://主键
        {
            
            Note *model = [noteDAO findById:[_picker date]];
            NSLog(@"%@", model.content);
        }
            break;
        default:
            break;
    }
}


- (Note *)createNoteModel {
    Note *model = [[Note alloc] init];
    model.date = [_picker date];
    
    //时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    model.content = [NSString stringWithFormat:@"时间--%@", [dateFormatter stringFromDate:[_picker date]]];
    
    
    return model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
