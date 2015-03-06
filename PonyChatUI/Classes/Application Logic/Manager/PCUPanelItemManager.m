//
//  PCUPanelItemManager.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelItemManager.h"
#import "PCUPanelItem.h"
#import <PonyRouter/PGRApplication.h>

@implementation PCUPanelItemManager

+ (void)load {
    [self configureStandardItems];
}

/**
 *  基础对话组件的响应设置
 *  只是一个示例，你可以参照以下代码自己定义想要的事件
 */
+ (void)configureStandardItems {
    {
        PGRNode *node = [[PGRNode alloc] initWithIdentifier:@"photo.pcu" executingBlock:^(NSURL *sourceURL, NSDictionary *params, id sourceObject) {
            if ([sourceObject isKindOfClass:[UIViewController class]]) {
                if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
                    photoPicker.delegate = sourceObject;
                    photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    photoPicker.allowsEditing = YES;
                    [sourceObject presentViewController:photoPicker animated:YES completion:nil];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"相册功能已被禁用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            }
        }];
        [[PGRApplication sharedInstance] addNode:node];
    }
    {
        PGRNode *node = [[PGRNode alloc] initWithIdentifier:@"camera.pcu" executingBlock:^(NSURL *sourceURL, NSDictionary *params, id sourceObject) {
            if ([sourceObject isKindOfClass:[UIViewController class]]) {
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                    cameraPicker.delegate = sourceObject;
                    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [sourceObject presentViewController:cameraPicker animated:YES completion:nil];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"相机功能已被禁用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            }
        }];
        [[PGRApplication sharedInstance] addNode:node];
    }
}

/**
 *  一些基础对话组件
 *
 *  @return NSArray
 */
- (NSArray *)standardItems {
    return [NSArray arrayWithObjects:
            [self album],
            [self camera],
            nil];
}

#pragma mark - Item Defines

- (PCUPanelItem *)album {
    PCUPanelItem *item = [[PCUPanelItem alloc] init];
    item.title = @"照片";
    item.iconURLString = @"sharemore_pic";
    item.actionURLString = @"ponymessager://photo.pcu/";
    return item;
}

- (PCUPanelItem *)camera {
    PCUPanelItem *item = [[PCUPanelItem alloc] init];
    item.title = @"拍摄";
    item.iconURLString = @"sharemore_video";
    item.actionURLString = @"ponymessager://camera.pcu/";
    return item;
}

@end
