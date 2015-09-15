# MobShareSDK

[![CI Status](http://img.shields.io/travis/shingwasix/MobShareSDK.svg?style=flat)](https://travis-ci.org/shingwasix/MobShareSDK)
[![Version](https://img.shields.io/cocoapods/v/MobShareSDK.svg?style=flat)](http://cocoapods.org/pods/MobShareSDK)
[![License](https://img.shields.io/cocoapods/l/MobShareSDK.svg?style=flat)](http://cocoapods.org/pods/MobShareSDK)
[![Platform](https://img.shields.io/cocoapods/p/MobShareSDK.svg?style=flat)](http://cocoapods.org/pods/MobShareSDK)

ShareSDK for iOS 来自 [mob](http://mob.com)

## 简介
此项目为非官方整理，旨在降低开发者集成ShareSDK的成本。项目中所包含的ShareSDK类库均从 [mob](http://mob.com) 官网下载，本人未对其进行过任何修改。

## 版本
2.11.2 [更新时间:2015-08-10]

## 官方更新说明
1. 新增支付宝朋友分享平台。
2. 评论和赞SDK支持本地化。
3. 只集成需要客户端分享的平台，在设备没有安装任何一个平台客户端下，不显示分享菜单栏并产生错误回调。

## 兼容平台
iOS 5.1.1 及以上

## 安装

MobShareSDK 可以通过 [CocoaPods](http://cocoapods.org) 进行安装, 只需在 Podfile 中添加以下代码:

```ruby
# 主模块(必须)
pod 'MobShareSDK'

# UI模块(含所有UI样式,可选)
pod 'MobShareSDK/UI'
# iOS竖版默认分享UI(可选)
pod 'MobShareSDK/UI/Flat'
# iPad版默认分享视图(可选)
pod 'MobShareSDK/UI/iPadDefault'
# iPad版简单分享视图(可选)
pod 'MobShareSDK/UI/iPadSimple'
# iPhone版默认分享视图(可选)
pod 'MobShareSDK/UI/iPhoneDefault'
# iPhone版简单分享视图(可选)
pod 'MobShareSDK/UI/iPhoneSimple'
# iPhone版应用推荐视图(可选)
pod 'MobShareSDK/UI/iPhoneAppRecommend'

# 评论和赞模块(可选)
pod 'MobShareSDK/Comment'

# 分享&登录链接模块(含所有平台,可选)
pod 'MobShareSDK/Connection'
# 短信(可选)
pod 'MobShareSDK/Connection/SMS'
# 邮件(可选)
pod 'MobShareSDK/Connection/Mail'
# 拷贝(可选)
pod 'MobShareSDK/Connection/Copy'
# 打印(可选)
pod 'MobShareSDK/Connection/Print'
# 新浪微博(可选)
pod 'MobShareSDK/Connection/SinaWeibo'
# 微信(可选)
pod 'MobShareSDK/Connection/WeChat'
# 腾讯QQ(可选)
pod 'MobShareSDK/Connection/QQ'
# QQ空间(可选)
pod 'MobShareSDK/Connection/QZone'
# 腾讯微博(可选)
pod 'MobShareSDK/Connection/TencentWeibo'
# Google+(可选)
pod 'MobShareSDK/Connection/GooglePlus'
# 人人网(可选)
pod 'MobShareSDK/Connection/RenRen'
# 易信(可选)
pod 'MobShareSDK/Connection/YiXin'
# Pinterest(可选)
pod 'MobShareSDK/Connection/Pinterest'
# Facebook(可选)
pod 'MobShareSDK/Connection/Facebook'
# Dropbox(可选)
pod 'MobShareSDK/Connection/Dropbox'
# DouBan(可选)
pod 'MobShareSDK/Connection/DouBan'
# 印象笔记(可选)
pod 'MobShareSDK/Connection/EverNote'
# Flickr(可选)
pod 'MobShareSDK/Connection/Flickr'
# Instagram(可选)
pod 'MobShareSDK/Connection/Instagram'
# Instapaper(可选)
pod 'MobShareSDK/Connection/Instapaper'
# 开心网(可选)
pod 'MobShareSDK/Connection/KaiXin'
# 搜狐(可选)
pod 'MobShareSDK/Connection/Sohu'
# Twitter(可选)
pod 'MobShareSDK/Connection/Twitter'
# Tumblr(可选)
pod 'MobShareSDK/Connection/Tumblr'
# WhatsApp(可选)
pod 'MobShareSDK/Connection/WhatsApp'
# VKontakte(可选)
pod 'MobShareSDK/Connection/VKontakte'
# KaKaoStory(可选)
pod 'MobShareSDK/Connection/KaKaoStory'
# KaKaoTalk(可选)
pod 'MobShareSDK/Connection/KaKaoTalk'
# Line(可选)
pod 'MobShareSDK/Connection/Line'
# LinkedIn(可选)
pod 'MobShareSDK/Connection/LinkedIn'
# Pocket(可选)
pod 'MobShareSDK/Connection/Pocket'
# 明道(可选)
pod 'MobShareSDK/Connection/MingDao'
# 有道云笔记(可选)
pod 'MobShareSDK/Connection/YouDaoNote'
# 支付宝(可选)
pod 'MobShareSDK/Connection/AliPaySocial'
```
安装`MobShareSDK/UI`模块可使用所有UI界面，安装`MobShareSDK/Connection`模块可使用所有分享平台。但鉴于安装所有分享平台模块会使得应用变得非常庞大，所以不推荐大家使用这种方式安装。开发者可根据自己的需求安装引入指定的分享模块，这样可使应用体积保持小巧。

例：应用需要包含新浪微博分享和微信分享，并且需要使用简单分享视图，则只需要添加如下代码于 Podfile 中进行安装即可。

```ruby
pod 'MobShareSDK'
pod 'MobShareSDK/UI/iPadSimple'
pod 'MobShareSDK/UI/iPhoneSimple'
pod 'MobShareSDK/Connection/SinaWeibo'
pod 'MobShareSDK/Connection/WeChat'
```

## 官方下载
http://mob.com/#/downloadDetail/ShareSDK/ios

## 官方开发文档
http://wiki.mob.com/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E6%8C%87%E5%8D%97/

## License

Copyright © 2012-2015 mob.
