<h1 align="center"> Meet Together</h1>
<h3 align="center"> 快速與他人建立連繫</h3>
<p align="center"><img src="https://github.com/Kaih1825/Meet-Together/blob/main/images/loho.png?raw=true" width="100" height="100"></p> 

## GitBook筆記
https://kai181.gitbook.io/flutter-meet-together/

## 功能特色
#### &emsp;外觀
##### &emsp;&emsp;1.支援 深色／淺色 模式
##### &emsp;&emsp;2.支援 Material You &emsp;(Material 3)
##### &emsp;&emsp;3.支援 動態顏色系統&emsp;(Android 12 以上)
#### &emsp;功能
##### &emsp;&emsp;1.支援 Google 登入及自訂頭貼、名稱登入
##### &emsp;&emsp;2.支援 儲存會議代碼，供快速加入

## 系統架構
#### &emsp;&emsp; 開發框架：Flutter
#### &emsp;&emsp; 開發語言：Dart
#### &emsp;&emsp; 支援系統：Android 6.0以上 (最佳系統為Android 12)
#### &emsp;&emsp; 開發系統：Windows 11、Manjaro 21.3.0 
#### &emsp;&emsp; 開發工具：Visual Studio Code
#### &emsp;&emsp; 會議提供者：[Jitsi Meet](https://meet.jit.si/)
</br>
<h2><a href="https://youtu.be/LlDx5_K7wwc">使用影片(Youtube連結)</a></h2></br>

## 使用程式碼前需要做的事 (Google 登入需要，若為[在此](https://github.com/Kaih1825/Meet-Together/releases)安裝的apk則不需要)
### 1.必須先安裝 [Firebase CLI](https://firebase.google.com/docs/cli#setup_update_cli) 及 [Java](https://www.java.com/zh-TW/) 
### 2.使用以下指令登入Firebase
`firebase login`
### 3.設定 Firebase
`flutterfire configure`
### 4.到 JDK 底下的 Bin 資料夾，輸入以下指令生成金鑰
Mac/Linux </br>
`keytool -list -v \-alias androiddebugkey -keystore ~/.android/debug.keystore`

Windows </br>
`keytool -list -v \-alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore`
(如果沒有成功的話，可以參考[這裡](https://stackoverflow.com/a/27639043))
### 5.將金鑰輸入至Firebase專案裡
### 6.在Firebase的專案裡開啟Google登入及匿名登入
### 7.下載google-services.json 並覆蓋至 專案位置/android/app

(若沒有執行，將只能使用自訂名稱/頭貼登入) </br>
### 常見問題 </br>
#### 1.若顯示 &emsp;Keystore file does not exist
先cp到`C:\Users\your_user_name\.android`</br>
輸入</br>
`keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000`</br>
回答問題後，再回到步驟4就可以了</br>
#### 2.無法使用Google登入(出現以下畫面)
![Google Login Error](https://github.com/Kaih1825/Meet-Together/blob/main/Screenshot/google-error.png?raw=true)</br>
先刪掉`C:\Users\your_user_name\.android\debug.keystore`</br>
再使用常見問題1的方式即可
### 資料來源 </br>
[將 Firebase 添加到您的 Flutter 應用](https://firebase.google.com/docs/flutter/setup?platform=ios)</br>
[Authenticating Your Client](https://developers.google.com/android/guides/client-auth)


## 螢幕截圖(Android 12)

##### 介面介紹
<p align="center"><img src="https://github.com/Kaih1825/Meet-Together/blob/main/Screenshot/how-to-use.png?raw=true" height="500"></p>

##### 登入介面
<p align="center"><img src="https://github.com/Kaih1825/Meet-Together/blob/main/Screenshot/login.png?raw=true" height="500"></p> 

##### 設定個人資訊
<p align="center"><img src="https://github.com/Kaih1825/Meet-Together/blob/main/Screenshot/set_info.png?raw=true" height="500"></p> 

##### 主畫面&emsp;(深色模式)
<p align="center"><img src="https://github.com/Kaih1825/Meet-Together/blob/main/Screenshot/home_dark.png?raw=true" height="500"></p> 

##### 會議畫面
<p align="center"><img src="https://github.com/Kaih1825/Meet-Together/blob/main/Screenshot/metting_screen.png?raw=true" height="500"></p> 




## 使用的套件
#### &emsp;&emsp; [Cupertino Icons 1.0.5](https://pub.dev/packages/cupertino_icons)
#### &emsp;&emsp; [Firebase Auth 3.4.2](https://pub.dev/packages/firebase_auth)
#### &emsp;&emsp; [google_sign_in 5.4.0](https://pub.dev/packages/google_sign_in)
#### &emsp;&emsp; [Cloud Firestore 3.3.0](https://pub.dev/packages/cloud_firestore)
#### &emsp;&emsp; [Shared preferences plugin 2.0.15](https://pub.dev/packages/shared_preferences)
#### &emsp;&emsp; [material_color_utilities 0.1.4](https://pub.dev/packages/material_color_utilities)
#### &emsp;&emsp; [page_animation_transition 0.0.9](https://pub.dev/packages/page_animation_transition)
#### &emsp;&emsp; [flutter_bounce 1.1.0](https://pub.dev/packages/flutter_bounce)
#### &emsp;&emsp; [url_launcher 6.1.5](https://pub.dev/packages/url_launcher)
#### &emsp;&emsp; [jitsi_meet_wrapper_platform_interface 0.0.3](https://pub.dev/packages/jitsi_meet_wrapper_platform_interface)
#### &emsp;&emsp; [jitsi_meet_wrapper 0.0.5](https://pub.dev/packages/jitsi_meet_wrapper)
#### &emsp;&emsp; [Share plugin 4.0.10](https://pub.dev/packages/share_plus)
#### &emsp;&emsp; [flutter_slidable 2.0.0](https://pub.dev/packages/flutter_slidable)
#### &emsp;&emsp; [Camera Plugin 0.10.0](https://pub.dev/packages/camera)
#### &emsp;&emsp; [connectivity_plus 2.3.6](https://pub.dev/packages/connectivity_plus)
#### &emsp;&emsp; [flutter_svg 1.1.2](https://pub.dev/packages/flutter_svg)
#### &emsp;&emsp; [Flutter Launcher Icons 0.9.3](https://pub.dev/packages/flutter_launcher_icons)
