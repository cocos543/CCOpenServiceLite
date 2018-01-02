# CC輕量級開放平臺服務

## 更新說明
　　2017年05月09日 **1.新增微信,QQ,微博分享接口;2.新增鏈接分享UI**  
　　2016年10月26日 **1.新增支付接口;**  
　　2016年09月12日 **1.新增獲取authCode接口;**

## 前言
　　提供第三方開放平臺的集成服務,壹句代碼實現壹種功能~喜歡的朋友可以前來點個小星星.(目前主要用於練習)
## 特色
　　目前市面上提供的第三方SDK,相當繁瑣臃腫,還需要去他們的集成平臺上註冊各種key之類的,相當麻煩.**CC輕量級開放平臺服務**提供壹行代碼請求數據服務,底層集成了各平臺SDK,用戶無需關心具體平臺的實現,省事省心.

## 主要功能
1. 集成微信,QQ,微博的開放平臺SDK.
2. 提供統壹的請求入口,壹句代碼即可完成任務,簡單高效.
3. 目前支持開放平臺登錄,支付功能接入,鏈接分享;其他功能(收藏,評論等)後期有時間會更新上.
4. 支持單獨獲取OAuth 2.0中的access_token(微信為code),提升安全性.

## 使用方法
1 直接將整個目錄拖到妳的項目中.(註意用group形式,目錄會顯示成黃色).本庫用到AFNetworking,需要自己集成.

   ![image](images/CCOpenService_Tree.png)
      
2 在AppDelegate.m文件頂部引入頭文件CCOpenService.h,CCOpenConfig.h,並且寫入下面的配置信息(註意,類似WeiXinAppID這樣的,填寫自己的微信appID)

``` objectivec
//AppDelegate.m
// 註意,如果不需要使用到Secret,則Secret直接填寫為@"test"即可
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //微信配置
    [CCOpenConfig setWeiXinAppID:WeiXinAppID];
    [CCOpenConfig setWeiXinAppSecret:WeiXinAppSecret];
    
    //QQ配置
    [CCOpenConfig setQQAppID:QQAppID];
    [CCOpenConfig setQQAppKey:QQAppKey];
    
    //微博配置
    [CCOpenConfig setWeiBoAppKey:WeiBoAppKey];
    [CCOpenConfig setWeiBoAppSecret:WeiBoAppSecret];
    [CCOpenConfig setWeiBoRedirectURI:WeiBoRedirectURI];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //配置微信,QQ,新浪
    CCOpenService *wxService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
    CCOpenService *qqService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameQQ];
    CCOpenService *wbService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiBo];
    return [wxService handleOpenURL:url] || [qqService handleOpenURL:url] || [wbService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //配置微信,QQ,新浪
    CCOpenService *wxService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
    CCOpenService *qqService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameQQ];
    CCOpenService *wbService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiBo];
    return [wxService handleOpenURL:url] || [qqService handleOpenURL:url] || [wbService handleOpenURL:url];
}
```

3 參考各個平臺關於URL scheme的配置指南.例如微信:
![image](images/WeiXin_URL_Scheme.jpg)

4 iOS9 設備需要添加白名單,參考[iOS9白名單](https://github.com/ChenYilong/iOS9AdaptationTips)

## 接口使用說明
　　服務類型目前支持CCOpenServiceNameWeiXin,CCOpenServiceNameQQ,CCOpenServiceNameWeiBo

### 第三方登錄接口

``` objective
//微信登錄
CCOpenService *wxService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
[wxService requestOpenAccount:^(CCOpenRespondEntity *respond) {
    if (respond == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"溫馨提示" message:@"^_^親,您木有安裝微信喲~ " delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSLog(@"Respond data is %@",respond.data);
}];
```

### 獲取第三方AuthCode接口
``` objective
// 如果需求裏對第三方登錄功能有著更為嚴格的安全要求時,可以只獲取到access_token(微信為code),此接口只需要平臺的申請到的帳號id(或者key)而不需要密鑰(或者secret)即可實現,獲取到authcode之後發給服務端,由服務端處理獲取用戶個人openid和其他信息部分的業務邏輯即可~
CCOpenService *wxService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
[wxService requestOpenAuthCode:^(CCOpenRespondEntity *respond) {
    if (respond == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"溫馨提示" message:@"^_^親,您木有安裝微信喲~ " delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSLog(@"Respond data is %@",respond.data);
}];
```

### 支付功能
　　工作項目關系,目前只支持微信支付.  
　　**註意,微信支付務必將全局統壹下單步驟安排到服務端完成,再由服務端返回喚起微信客戶端所需要的相關參數,用以喚起微信客戶端並完成支付**

``` objective
CCOpenWXPayRequestEntity *wxEntity = [[CCOpenWXPayRequestEntity alloc] init];
wxEntity.wxAppID   = <#appid#>;
wxEntity.partnerID = <#partnerid#>;
wxEntity.prepayID  = <#prepayid#>;
wxEntity.nonceStr  = <#noncestr#>;
wxEntity.timestamp = <#timestamp#>;
wxEntity.package   = @"Sign=WXPay";
wxEntity.sign      = <#sign#>;

CCOpenService *wxService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
[wxService requestPay:wxEntity respondHander:^(CCOpenRespondEntity *respond) {
    NSString *payResult = respond.data[@"result"];
    if ([payResult isEqualToString:@"WXSuccess"]) {
            // Query the result of payment from service..
            //Do something
    }else if([payResult isEqualToString:@"WXErrCodeUserCancel"]) {
        //User cancel
    }else {
        //Error~
    }
    NSLog(@"%@",respond.data);
}];
```

### 分享功能
　　目前只支持鏈接分享.  
　　**註意:具體的分享接口已經在CCShareFilterView中實現,CCShareFilterView為默認的UI,可直接使用;建議用戶自行設計UI.**

``` objective
//如果直接使用默認的UI,則只需要引入頭文件CCShareFilterView.h即可,不需要引入CCOpenService.h.
CCShareFilterView *sView = [[[NSBundle mainBundle] loadNibNamed:@"CCShareFilterView" owner:nil options:nil] firstObject];

//設置需要分享的實體
CCOpenURLShareRequestEntity *shareEntity = [[CCOpenURLShareRequestEntity alloc] init];
shareEntity.urlString = @"https://www.baidu.com";
shareEntity.thumbURL = [[NSBundle mainBundle] URLForResource:@"Public_ShareTest" withExtension:@"png"];
shareEntity.title = @"標題";
shareEntity.desc = @"描述";
sView.shareEntity = shareEntity;

[sView showFilterViewWithOptions:0 completeHander:^(NSString *msg) {
    NSLog(@"%@", msg);
}];
```

## 其他說明
　　所有SDK均為當前最新版,WeiXin,QQ,WeiBo目錄下的SDK需要手動導入,另外第三方平臺的SDK可能需要手動導入壹些類庫,具體的先參考具體平臺的官方說明,有空更新上.  
　　本人工作忙,所以很多功能還沒時間寫上.目前已經寫好了整體框架,有興趣的同學可當作自己學習鍛煉機會,參考我的源碼設計模式,將新增的功能Pull Request給我,謝謝.
