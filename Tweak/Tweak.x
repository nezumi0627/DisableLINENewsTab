#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <mach-o/dyld.h>

// アプリのバンドルIDと表示名を定義
#define LINE_BUNDLE_ID @"jp.naver.line"
#define LINE_NAME @"LINE"

// NLConfigurationManagerをフック
%hook NLConfigurationManager

// アプリ内の特定の設定（Newsタブの使用）を無効化
- (BOOL)useNewsTab {
    return NO;
}

%end

%ctor {
    %init;

    // 1秒後にアラートを表示するためのコード
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // UIAlertControllerの設定
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome"
                                                                       message:@"Hello New Tweak"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        // OKボタンのアクションを定義
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];

        // UIWindowSceneを取得
        NSArray<UIScene *> *scenes = [UIApplication sharedApplication].connectedScenes.allObjects;
        UIWindow *keyWindow = nil;

        // 各シーンをループして最初のウィンドウを取得
        for (UIScene *scene in scenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                keyWindow = [(UIWindowScene *)scene keyWindow];
                if (keyWindow) {
                    break;
                }
            }
        }

        // keyWindowが存在し、rootViewControllerが正しく取得できた場合にアラートを表示
        if (keyWindow && keyWindow.rootViewController) {
            [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
            // rootViewControllerが取得できない場合はログを出力
            NSLog(@"Failed to present alert: No rootViewController found.");
        }
    });
}
