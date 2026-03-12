# 松鼠账本 - 编译说明

## 方式一：GitHub Actions (推荐)

### 步骤

1. **Fork 项目到你的 GitHub 账号**

2. **启用 GitHub Actions**
   - 进入你的仓库
   - 点击 Actions 标签
   - 点击 "I understand my workflows, go ahead and enable them"

3. **触发构建**
   - 方式 A: 推送标签
     ```bash
     git tag v1.0.0
     git push origin v1.0.0
     ```
   
   - 方式 B: 手动触发
     - 进入 Actions → Build Android APK → Run workflow

4. **下载 APK**
   - 构建完成后，在 Actions 页面下载 artifact
   - 或在 Releases 页面下载 (如果打了 tag)

### 构建产物

- `app-release.apk` -  Release 版本 (约 20-30MB)
- 位置：GitHub Actions Artifacts 或 Releases

---

## 方式二：本地编译

### 环境要求

| 组件 | 版本 | 下载链接 |
|------|------|----------|
| **Flutter SDK** | 3.19.0+ | https://flutter.dev |
| **Java JDK** | 17+ | https://adoptium.net |
| **Android SDK** | API 33+ | Android Studio |
| **Android Studio** | 2023.1+ | https://developer.android.com |

### 安装步骤

#### 1. 安装 Flutter

```bash
# Linux/macOS
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 验证
flutter doctor
```

#### 2. 安装 Android Studio

1. 下载并安装 Android Studio
2. 打开 Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK
3. 安装以下组件：
   - Android SDK Platform 33
   - Android SDK Build-Tools 33.0.0
   - Android SDK Command-line Tools

4. 接受许可证：
   ```bash
   flutter doctor --android-licenses
   ```

#### 3. 配置环境变量

```bash
# ~/.bashrc 或 ~/.zshrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/33.0.0
```

### 编译命令

```bash
# 进入项目目录
cd squirrel_go_app

# 获取依赖
flutter pub get

# 编译 Debug 版本 (用于测试)
flutter build apk --debug

# 编译 Release 版本 (用于发布)
flutter build apk --release

# 编译拆分 APK (按 CPU 架构，减小体积)
flutter build apk --split-per-abi

# 编译 App Bundle (用于 Google Play)
flutter build appbundle
```

### 输出位置

```
build/app/outputs/flutter-apk/
├── app-release.apk          # Release 版本 (所有架构)
├── app-debug.apk            # Debug 版本
├── app-armeabi-v7a-release.apk  # 32 位 ARM
├── app-arm64-v8a-release.apk    # 64 位 ARM (现代手机)
└── app-x86_64-release.apk       # x86_64 (模拟器)
```

---

## 方式三：使用 Docker 编译

```bash
# 拉取 Flutter 镜像
docker pull ghcr.io/cirruslabs/flutter:3.19.0

# 编译
docker run --rm -v $(pwd):/app ghcr.io/cirruslabs/flutter:3.19.0 flutter build apk --release
```

---

## 安装到手机

### 方法 1: 直接安装 APK

1. 将 APK 文件传输到手机
2. 在手机文件管理器中点击 APK
3. 允许"未知来源应用"
4. 安装完成

### 方法 2: ADB 安装

```bash
# 手机开启 USB 调试
# 连接电脑

adb install build/app/outputs/flutter-apk/app-release.apk
```

### 方法 3: 无线调试

```bash
# 配对设备
adb pair 192.168.1.100:5555

# 连接
adb connect 192.168.1.100:5555

# 安装
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 常见问题

### 1. 编译失败：Gradle 错误

```bash
# 清理
flutter clean
rm -rf android/.gradle

# 重新获取依赖
flutter pub get

# 重新编译
flutter build apk --release
```

### 2. 内存不足

```bash
# 增加 Gradle 内存
# android/gradle.properties
org.gradle.jvmargs=-Xmx4096m
```

### 3. 语音识别不可用

检查权限配置：
- Android: `android/app/src/main/AndroidManifest.xml`
- 需要 `RECORD_AUDIO` 权限

### 4. 网络请求失败

检查后端 API 地址：
- `lib/services/api_service.dart`
- 确保地址可访问

---

## 版本发布

### 更新版本号

编辑 `pubspec.yaml`:
```yaml
version: 1.0.1+2  # 1.0.1 是版本号，2 是构建号
```

### 创建 Release

```bash
git tag v1.0.1
git push origin v1.0.1
```

GitHub Actions 会自动构建并上传到 Releases。

---

## 技术支持

- Flutter 文档：https://flutter.dev/docs
- Android 开发：https://developer.android.com
- 项目 Issues: https://github.com/your-repo/issues
