//
//  smartLiteSqlBase.m
//  smartUCLite
//
//  Created by 王威 on 15/6/5.
//  Copyright (c) 2015年 Easiio. All rights reserved.
//

#import "smartLiteSqlBase.h"
#import <sqlite3.h>


@interface smartLiteSqlBase()
@property(nonatomic)sqlite3 *my_db;
@property(nonatomic,strong) NSMutableArray *mTables;
@property(nonatomic,strong) NSArray *updates;
@end
@implementation smartLiteSqlBase
- (id)init
{
    if (self = [super init]) {
        if(!_mTables){
            _mTables=[[NSMutableArray alloc] init];
        }
        [self OpenMydabase];
        [self createUpdateTable];
        [self processDatabaseUpdate];
        
    }

    return self;
}
+(id)shareMyDdataBase
{
    static smartLiteSqlBase *mdatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mdatabase = [[smartLiteSqlBase alloc] init];
    });
    return mdatabase;
}


- (void )OpenMydabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBPATH];
    NSLog(@"%@ ericwang databasepath",database_path);
    int resultCode = sqlite3_open([database_path UTF8String], &_my_db);
    if (resultCode != SQLITE_OK) {
        NSLog(@"[SQLITE] Unable to open database!");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_my_db), sqlite3_errcode(_my_db));
        sqlite3_close(_my_db);
    }
    
    
}

#pragma mark 联系人表的操作
- (void)createUpdateTable
{
    NSString *sqlCreateTable=@"CREATE TABLE IF NOT EXISTS `easiio_update` (`id` INTEGER NOT NULL,\
                                                             `name` INTEGER NOT NULL DEFAULT 0,\
                                                                  PRIMARY KEY (`id`))";
    if ([self execSql:sqlCreateTable] == 0) {
        NSLog (@"Create UserCollectTab failed.");
    }
    
}

-(void)processDatabaseUpdate{
    [self getAllTables];
    NSDictionary *dic_have_update=[self get_database_update];
    NSDictionary *dic_need_update=[self get_need_database_update];
    
    NSMutableDictionary *process_update=[NSMutableDictionary dictionary];
    for (NSString *key in dic_need_update) {
        if([dic_have_update objectForKey:key]){
        }else{
            [process_update setObject:[dic_need_update objectForKey:key] forKey:key];
        }
    }
    
    for (NSString *key in process_update) {
        if(key){
        
            if([key isEqualToString:@"1"]){
                [self update_1];
            }
            else if([key isEqualToString:@"2"]){
                [self update_2];
            }
            else if([key isEqualToString:@"3"]){
                [self update_3];
            
            }
            [self insertUpdate:key];
        }
        
    }
    
}


-(void)getAllTables{
    

    NSString *sqlquery = [[NSString alloc]initWithFormat:@"SELECT * FROM sqlite_master where type='table'"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_my_db, [sqlquery UTF8String], -1, &statement, Nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
           
          //  NSString *string1= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
          //  NSString *string2= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            NSString *tableName= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
          //  NSString *string4= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
          //  NSString *string5= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
            [self.mTables addObject:tableName];
            
        }
    } else {
        NSLog(@"DB operation failure! Error message: %s", sqlite3_errmsg(_my_db));

    }
    
    
}
- (int)insertUpdate:(NSString *)number
{
    NSString *sql = [NSString stringWithFormat: @"INSERT INTO 'easiio_update' ('id', 'name') VALUES ('%d','%d')",number.intValue,number.intValue];
    
    NSLog(@"insert easiiosql: %@", sql);
    [self execSql:sql];
    return sqlite3_last_insert_rowid(_my_db);
    
}

-(int)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(_my_db, [sql UTF8String], NULL, NULL, &err) && sqlite3_exec(_my_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        //sqlite3_close(_my_db);
        NSLog(@"DB operation failure! Error message: %s", err);
        return 0;
    } else {
        NSLog(@"DB oparation successful, Affected row: %d.", sqlite3_changes (_my_db));
    }
    return 1;
}

-(NSDictionary *)get_database_update{
    
    NSMutableDictionary *demoDic=[NSMutableDictionary dictionary];
    NSString *sqlquery = [[NSString alloc]initWithFormat:@"SELECT id,name FROM `easiio_update`;"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_my_db, [sqlquery UTF8String], -1, &statement, Nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *tableName= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            [demoDic setValue:tableName forKey:tableName];
        }
        return demoDic;
    } else {
        NSLog(@"DB operation failure! Error message: %s", sqlite3_errmsg(_my_db));
        return nil;
    }

    

}
-(NSDictionary *)get_need_database_update{
    

    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"1"];
    [dic setObject:@"2" forKey:@"2"];
    
    return dic;
   
    
}
//更新函数1
-(void)update_1{
    
    NSLog(@"执行函数1");
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS UserCollectTab(ID INTEGER PRIMARY KEY AUTOINCREMENT,\
    username TEXT,\
    collectUsername TEXT,\
    collectType INTEGER);";
    
    if ([self execSql:sqlCreateTable] == 0) {
        NSLog (@"Create UserCollectTab failed.");
    }
}
-(void)update_2{
    NSLog(@"执行函数2");
}
//更新函数3
-(void)update_3{
    NSLog(@"执行函数2");
}


@end
