//
//  ViewController3.m
//  DataPersistence
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "ViewController3.h"
#import "CoreDataManager.h"
#import "Car+CoreDataClass.h"

@interface ViewController3 ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIAlertView *insertAlert;
@property (nonatomic, strong)UIAlertView *updateAlert;


@end

@implementation ViewController3



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", [[CoreDataManager sharedManager] applicationDocumentDirectory]);
    _context = [CoreDataManager sharedManager].managedObjectContext;
    _dataSource = [NSMutableArray array];
    [self findAll];
}

- (void)findAll {
    NSLog(@"查找全部");
    NSFetchRequest *request = [Car fetchRequest];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    //    request.sortDescriptors = @[sort];
    
    NSError *error = nil;
    NSArray *arr = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查找全部失败%@", error.description);
        return;
    }
    _dataSource = [NSMutableArray arrayWithArray:arr];
    
    
}


- (Car *)createPersonWithName:(NSString *)name {
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Car" inManagedObjectContext:_context];
    Car *car = [[Car alloc] initWithEntity:description insertIntoManagedObjectContext:_context];
    car.name = name;
    int price = arc4random() % 20 + 10;
    car.price = (float)price;

    return car;
}


//开始插入
- (IBAction)addModel:(id)sender {
    [self.view endEditing:YES];
    _searchBar.text = @"";
    _insertAlert = [[UIAlertView alloc] initWithTitle:@"增加一条记录" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _insertAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_insertAlert show];
}

//alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == _insertAlert) {
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            [self insertNewRecordWithName:tf.text];
        }
    }else {
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            [self insertNewRecordWithName:tf.text];
        }
    }
    
}
//执行插入
- (void)insertNewRecordWithName:(NSString *)name {
    
    if (name.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //先创建实体,使managerContext发生变化,才可以在save时保存这个实体
    Car *model = [self createPersonWithName:name];
    NSError *error = nil;
    [_context save:&error];
    NSLog(@"%@", _context);
    if (error) {
        NSLog(@"插入失败");
        return;
    }
    [_dataSource addObject:model];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Car *model = _dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"-------------%@--%f", model.name, model.price];
    
    return cell;
}

//开始修改
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    Car *model = _dataSource[indexPath.row];
    model.price = 10.5;
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"修改失败");
        return;
    }
    [_tableView reloadData];
    
}




//可以删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//执行删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        Car *model = _dataSource[indexPath.row];
        [_context deleteObject:model];
        NSError *error = nil;
        [_context save:&error];
        if (error) {
            NSLog(@"删除失败");
            return;
        }
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}


//查询
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self findAll];
        [_tableView reloadData];
        
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", searchText];
        NSFetchRequest *request = [Car fetchRequest];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *array = [_context executeFetchRequest:request error:&error];
        _dataSource.array = array;
        [_tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
