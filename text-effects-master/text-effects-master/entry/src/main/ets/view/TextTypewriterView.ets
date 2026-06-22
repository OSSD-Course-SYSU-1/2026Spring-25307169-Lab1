/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Constants from '../constants/Constants';

@Component
export default struct TextTypewriterView {
  @State message: ResourceStr = '';
  @State displayText: string = '';
  @State cursorVisible: boolean = true;
  @State charIndex: number = 0;
  @State colorIndex: number = 0;
  
  // 打字机颜色数组
  private typewriterColors: string[] = [
    '#2196F3', // 蓝色
    '#4CAF50', // 绿色
    '#FF9800', // 橙色
    '#E91E63', // 粉色
    '#9C27B0'  // 紫色
  ];
  
  // 获取当前颜色
  private getCurrentColor(): string {
    return this.typewriterColors[this.colorIndex % this.typewriterColors.length];
  }

  build() {
    Row() {
      // 显示的文本
      Text(this.displayText)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.getCurrentColor())
        .fontWeight(FontWeight.Bold)
      
      // 闪烁的光标
      Text('|')
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.getCurrentColor())
        .fontWeight(FontWeight.Bold)
        .opacity(this.cursorVisible ? 1.0 : 0.0)
    }
    .width(Constants.FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear(): void {
    // 延迟初始化，等待UI上下文准备好
    setTimeout(() => {
      this.startTypewriterAnimation();
    }, 100);
  }

  private startTypewriterAnimation(): void {
    const fullText = this.message.toString();
    const textLength = fullText.length;
    
    // 打字效果动画 - 逐字显示
    const typeNextChar = () => {
      if (this.charIndex <= textLength) {
        this.displayText = fullText.substring(0, this.charIndex);
        this.charIndex++;
        
        // 延迟后显示下一个字符
        setTimeout(() => {
          typeNextChar();
        }, 100); // 每100ms显示一个字符
      } else {
        // 打字完成后，等待一段时间，然后重新开始
        setTimeout(() => {
          this.charIndex = 0;
          this.displayText = '';
          this.colorIndex++; // 切换颜色
          typeNextChar();
        }, 2000); // 等待2秒后重新开始
      }
    };
    
    // 开始打字效果
    typeNextChar();
    
    // 光标闪烁动画
    animateTo({
      duration: 500,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.cursorVisible = true;
      }
    }, () => {
      this.cursorVisible = false;
    });
  }
}
