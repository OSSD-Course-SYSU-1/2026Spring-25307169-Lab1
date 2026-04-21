# 基于Text组件及通用属性实现文字特效

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-5.0.5+-blue.svg)](https://developer.harmonyos.com/cn/develop)
[![ArkTS](https://img.shields.io/badge/ArkTS-5.0.5+-green.svg)](https://developer.harmonyos.com/cn/develop/arkts)
[![License](https://img.shields.io/badge/License-Apache%202.0-orange.svg)](LICENSE)

## 项目简介

本项目是一个基于HarmonyOS ArkTS开发的文字特效示例应用，展示了如何通过Text组件及通用属性实现多种炫酷的文字效果。项目旨在帮助开发者在HarmonyOS应用开发中快速掌握文字特效的实现方法，提升UI设计的视觉效果和用户体验。

### 主要特性

- **文字渐变效果**：使用blendMode混合属性和linearGradient线性渐变实现平滑的文字色彩过渡
- **歌词滚动效果**：结合blendMode、linearGradient和显式动画实现流畅的文字滚动动画
- **文字倒影效果**：通过rotate旋转属性和linearGradient实现逼真的文字倒影
- **跑马灯渐变效果**：利用Text组件的textOverflow属性和linearGradient实现自动滚动的跑马灯效果

### 技术亮点

- 纯ArkTS实现，无需第三方依赖
- 基于HarmonyOS原生组件和API
- 代码结构清晰，易于理解和扩展
- 性能优化，动画流畅自然

## 项目结构

```
text-effects-master/
├── AppScope/                           # 应用全局配置
├── entry/                              # 应用主模块
│   ├── src/main/
│   │   ├── ets/                        # ArkTS源代码目录
│   │   │   ├── constants/
│   │   │   │   └── Constants.ets       # 公共常量类
│   │   │   ├── entryability/
│   │   │   │   └── EntryAbility.ets    # 程序入口类
│   │   │   ├── pages/
│   │   │   │   └── Index.ets           # 首页
│   │   │   └── view/                   # 视图组件目录
│   │   │       ├── TextGradientView.ets      # 文字渐变效果
│   │   │       ├── TextMarqueeView.ets       # 跑马灯渐变效果
│   │   │       ├── TextReflectionView.ets    # 文字倒影效果
│   │   │       └── TextScrollingView.ets     # 歌词滚动效果
│   │   └── resources/                  # 应用静态资源目录
│   │       ├── base/                   # 基础资源
│   │       │   ├── element/            # 元素资源
│   │       │   ├── media/              # 媒体资源
│   │       │   └── profile/            # 配置文件
│   │       └── rawfile/                # 原始文件
│   └── build-profile.json5             # 模块构建配置
├── hvigor/                             # 构建工具
├── hvigorfile.ts                       # 构建脚本
├── build-profile.json5                 # 应用构建配置
├── oh-package.json5                    # 依赖配置
├── LICENSE                             # 许可证文件
├── README.md                           # 项目说明文档
└── README.en.md                        # 英文说明文档
```

## 技术实现

### 1. 文字渐变效果

**实现原理**：使用blendMode混合属性和linearGradient线性渐变属性实现文字的色彩渐变效果。

**技术要点**：
- `BlendMode.DST_IN`：将渐变图层与文字图层混合
- `BlendMode.SRC_OVER`：将混合后的图层覆盖到背景上
- `linearGradient`：定义从左到右的线性渐变色

**代码示例**：
```arkts
@Component
export default struct TextGradientView {
  @State message: ResourceStr = '';

  build() {
    Row() {
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontWeight(FontWeight.Bold)
        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
    }
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [[$r('app.color.gradient_start_color'), 0.0],
               [$r('app.color.gradient_end_color'), 1]]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }
}
```

### 2. 歌词滚动效果

**实现原理**：使用blendMode混合属性、linearGradient线性渐变属性和显式动画实现文字的滚动高亮效果。

**技术要点**：
- 使用`animateTo`创建无限循环的显式动画
- 通过状态变量`value`控制渐变色的位置变化
- `iterations: -1`实现无限循环播放
- `curve: Curve.Linear`确保匀速滚动效果

**代码示例**：
```arkts
@Component
export default struct TextScrollingView {
  @State message: ResourceStr = '';
  @State value: number = 0;

  build() {
    Row() {
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
    }
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [[Color.Red, 0.0], [Color.Red, this.value],
               [Color.Black, this.value], [Color.Black, 1.0]]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
    .onAppear(() => {
      this.getUIContext().animateTo({
        duration: Constants.TEXT_SCROLL_DURATION,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.Linear,
        iterations: -1,
        onFinish: () => {
          this.value = 0
        }
      }, () => {
        this.value = 1
      });
    })
  }
}
```

### 3. 文字倒影效果

**实现原理**：使用rotate旋转属性和linearGradient线性渐变属性实现文字的倒影效果。

**技术要点**：
- 使用`Stack`布局叠加原文字和倒影文字
- `rotate`属性实现文字的180度翻转
- 渐变色从透明过渡到红色，模拟真实的倒影效果
- 通过`alignContent`控制文字和倒影的对齐方式

**代码示例**：
```arkts
@Component
export default struct TextRefectionView {
  @State message: ResourceStr = '';

  build() {
    Stack() {
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(Color.Red)
        .fontWeight(FontWeight.Bold)
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(Color.Red)
        .fontWeight(FontWeight.Bold)
        .rotate({
          x: 1,
          y: 0,
          z: 0,
          angle: Constants.ANGLE_DEGREE,
          centerX: Constants.FIFTY_PERCENT,
          centerY: Constants.FULL_PERCENT
        })
        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
    }
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[Color.Transparent, 0], [Color.Transparent, 0.50],
               [Color.Red, 0.50], [$r('app.color.text_reflection_color'), 1]]
    })
    .height($r('app.float.text_refection_height'))
    .alignContent(Alignment.Top)
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }
}
```

### 4. 跑马灯渐变效果

**实现原理**：使用Text组件的textOverflow属性和linearGradient线性渐变属性实现自动滚动的跑马灯效果。

**技术要点**：
- `textOverflow: TextOverflow.MARQUEE`实现文字自动滚动
- 渐变色从透明过渡到黑色再回到透明，实现边缘淡入淡出效果
- 使用`BlendMode.SRC_IN`将文字与渐变背景混合
- 限制文字宽度以触发跑马灯效果

**代码示例**：
```arkts
@Component
export default struct TextGradientView {
  @State message: ResourceStr = '';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .width($r('app.string.ninety_percent'))
          .fontColor(Color.Black)
          .fontSize($r('app.float.content_font_size'))
          .fontWeight(FontWeight.Bold)
          .textOverflow({ overflow: TextOverflow.MARQUEE })
      }
      .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
      .backgroundColor(Color.Transparent)
      .width(Constants.FULL_PERCENT)
    }
    .width(Constants.FULL_PERCENT)
    .linearGradient({
      angle: Constants.ANGLE_DEGREE_HORIZONTAL,
      colors: [[Color.Transparent, 0], [Color.Black, 0.2],
               [Color.Black, 0.8], [Color.Transparent, 1]]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }
}
```

## 环境要求

### 开发环境

- **操作系统**：Windows 10/11 或 macOS 10.15+
- **DevEco Studio**：5.0.5 Release 或更高版本
- **Node.js**：14.x 或更高版本（DevEco Studio内置）

### 运行环境

- **HarmonyOS系统**：5.0.5 Release 或更高版本
- **HarmonyOS SDK**：5.0.5 Release SDK 或更高版本
- **支持设备**：华为手机（标准系统）

### SDK配置

```json5
{
  "app": {
    "products": [
      {
        "name": "default",
        "compatibleSdkVersion": "5.0.5(17)",
        "targetSdkVersion": "5.0.5(17)",
        "runtimeOS": "HarmonyOS"
      }
    ]
  }
}
```

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/OSSD-Course-SYSU-1/2026Spring-25307169-Lab1.git
cd 2026Spring-25307169-Lab1
```

### 2. 打开项目

1. 启动DevEco Studio
2. 选择"打开"或"Open"
3. 选择项目根目录中的`text-effects-master`文件夹
4. 等待项目同步完成（首次打开需要下载依赖）

### 3. 配置签名

1. 点击菜单栏"文件" > "项目结构"
2. 选择"Project" > "Signing Configs"
3. 配置应用签名信息（调试阶段可使用自动签名）

### 4. 运行项目

**使用模拟器运行**：
1. 点击工具栏的设备选择器
2. 选择可用的HarmonyOS模拟器
3. 点击运行按钮（绿色三角形）

**使用真机运行**：
1. 连接华为手机到电脑
2. 在手机上开启开发者选项和USB调试
3. 在DevEco Studio中选择已连接的设备
4. 点击运行按钮

### 5. 预览效果

启动应用后，你将看到四种文字特效的展示：

1. **文字渐变**：文字颜色从左到右平滑过渡
2. **歌词滚动**：文字高亮部分从左到右无限循环滚动
3. **文字倒影**：文字下方显示渐变透明的倒影效果
4. **跑马灯**：长文本自动滚动，边缘淡入淡出

## 使用说明

### 基本使用

1. **查看效果**：启动应用后，四种文字特效会依次展示在屏幕上
2. **交互体验**：每种特效都是独立展示，可以单独观察其效果
3. **代码参考**：查看`entry/src/main/ets/view/`目录下的源码文件

### 自定义修改

**修改文字内容**：
编辑`entry/src/main/resources/base/element/string.json`文件：

```json
{
  "name": "text_content",
  "value": "你的自定义文字"
}
```

**调整颜色配置**：
编辑`entry/src/main/resources/base/element/color.json`文件：

```json
{
  "name": "gradient_start_color",
  "value": "#FF0000"
}
```

**修改动画速度**：
编辑`entry/src/main/ets/constants/Constants.ets`文件：

```typescript
export class Constants {
  static readonly TEXT_SCROLL_DURATION: number = 3000; // 调整滚动时长
}
```

### 扩展开发

**添加新的文字特效**：
1. 在`entry/src/main/ets/view/`目录下创建新的`.ets`文件
2. 实现自定义的文字特效组件
3. 在`entry/src/main/ets/pages/Index.ets`中引入并使用新组件

**参考现有组件**：
- `TextGradientView.ets` - 文字渐变效果
- `TextScrollingView.ets` - 歌词滚动效果
- `TextReflectionView.ets` - 文字倒影效果
- `TextMarqueeView.ets` - 跑马灯效果

## 贡献指南

我们欢迎任何形式的贡献！如果你有任何改进建议或发现了bug，请通过以下方式参与：

### 贡献流程

1. **Fork项目**：点击GitHub页面右上角的Fork按钮
2. **创建分支**：从feature分支创建你的功能分支

```bash
git checkout -b feature/your-feature-name
```

3. **提交更改**：完成修改后提交到你的分支

```bash
git add .
git commit -m "feat: 添加你的功能描述"
```

4. **推送分支**：将你的分支推送到GitHub

```bash
git push origin feature/your-feature-name
```

5. **创建Pull Request**：在GitHub上创建Pull Request

### 代码规范

- 遵循ArkTS编码规范
- 使用有意义的变量和函数命名
- 添加必要的注释说明复杂逻辑
- 确保代码格式统一（使用DevEco Studio的格式化功能）

### 提交信息规范

使用语义化的提交信息格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type类型**：
- `feat`：新功能
- `fix`：修复bug
- `docs`：文档更新
- `style`：代码格式调整
- `refactor`：代码重构
- `test`：测试相关
- `chore`：构建过程或辅助工具的变动

### 问题反馈

如果你发现了bug或有功能建议，请在GitHub Issues中提交：

1. 提供详细的问题描述
2. 复现步骤
3. 预期行为和实际行为
4. 环境信息（HarmonyOS版本、设备型号等）
5. 相关日志或截图

## 许可证

本项目采用Apache License 2.0许可证。详见[LICENSE](LICENSE)文件。

```
Copyright (c) 2024 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## 联系方式

- **项目地址**：https://github.com/OSSD-Course-SYSU-1/2026Spring-25307169-Lab1
- **问题反馈**：[GitHub Issues](https://github.com/OSSD-Course-SYSU-1/2026Spring-25307169-Lab1/issues)
- **HarmonyOS开发者文档**：https://developer.harmonyos.com/cn/docs

## 致谢

- 感谢HarmonyOS团队提供的优秀开发框架和工具
- 感谢开源社区的贡献和支持
- 感谢所有参与项目测试和反馈的用户

---

**注意**：本示例项目仅支持在标准系统的华为手机上运行，确保你的设备满足系统版本要求。
