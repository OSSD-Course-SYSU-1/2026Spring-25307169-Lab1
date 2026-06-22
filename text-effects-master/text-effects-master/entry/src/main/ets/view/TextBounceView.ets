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
export default struct TextBounceView {
  @State message: ResourceStr = '';
  @State charOffsets: number[] = [];
  @State charOpacities: number[] = [];
  @State charScales: number[] = [];
  @State currentIndex: number = 0;
  @State isAnimating: boolean = false;
  
  // 弹跳颜色
  private readonly BOUNCE_COLORS: string[] = [
    '#FF6B6B', // 红色
    '#4ECDC4', // 青色
    '#45B7D1', // 蓝色
    '#FFA07A', // 橙色
    '#98D8C8', // 薄荷绿
    '#F7DC6F', // 金色
    '#BB8FCE', // 紫色
    '#85C1E9'  // 天蓝
  ];
  
  private textChars: string[] = [];
  private animationTimer: number = -1;

  aboutToAppear(): void {
    // 延迟初始化，等待UI上下文准备好
    setTimeout(() => {
      this.initAnimation();
    }, 100);
  }

  aboutToDisappear(): void {
    if (this.animationTimer !== -1) {
      clearTimeout(this.animationTimer);
    }
  }

  private initAnimation(): void {
    // 安全获取文本内容
    let text: string = 'Hello';
    try {
      if (typeof this.message === 'string') {
        text = this.message;
      } else if (this.message) {
        // ResourceStr 类型，使用默认文本
        text = 'Hello';
      }
    } catch (e) {
      text = 'Hello';
    }
    if (!text || text.length === 0) {
      text = 'Hello';
    }
    this.textChars = text.split('');
    const length = this.textChars.length;
    
    // 初始化所有字符的状态
    this.charOffsets = new Array(length).fill(-50);
    this.charOpacities = new Array(length).fill(0);
    this.charScales = new Array(length).fill(0.5);
    
    this.currentIndex = 0;
    this.isAnimating = true;
    
    // 开始弹跳动画
    this.bounceNextChar();
  }

  private bounceNextChar(): void {
    if (this.currentIndex >= this.textChars.length) {
      // 所有字符弹跳完成，等待后重新开始
      this.animationTimer = setTimeout(() => {
        this.resetAnimation();
      }, 2000);
      return;
    }
    
    const index = this.currentIndex;
    
    // 弹跳进入动画
    animateTo({
      duration: 600,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.EaseOut,
      onFinish: () => {
        // 弹跳回弹动画
        animateTo({
          duration: 300,
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: Curve.EaseInOut,
          onFinish: () => {
            // 最终稳定
            animateTo({
              duration: 200,
              finishCallbackType: FinishCallbackType.LOGICALLY,
              curve: Curve.EaseOut
            }, () => {
              this.charOffsets[index] = 0;
              this.charScales[index] = 1.0;
            });
            
            // 继续下一个字符
            this.currentIndex++;
            this.animationTimer = setTimeout(() => {
              this.bounceNextChar();
            }, 100);
          }
        }, () => {
          this.charOffsets[index] = 5;
          this.charScales[index] = 1.1;
        });
      }
    }, () => {
      this.charOffsets[index] = 0;
      this.charOpacities[index] = 1;
      this.charScales[index] = 1.0;
    });
    
    // 如果不是第一个字符，提前开始下一个
    if (this.currentIndex > 0) {
      this.animationTimer = setTimeout(() => {
        this.bounceNextChar();
      }, 150);
    } else {
      this.animationTimer = setTimeout(() => {
        this.bounceNextChar();
      }, 150);
    }
  }

  private resetAnimation(): void {
    const length = this.textChars.length;
    this.charOffsets = new Array(length).fill(-50);
    this.charOpacities = new Array(length).fill(0);
    this.charScales = new Array(length).fill(0.5);
    this.currentIndex = 0;
    
    this.animationTimer = setTimeout(() => {
      this.bounceNextChar();
    }, 200);
  }

  build() {
    Row() {
      ForEach(this.textChars, (char: string, index: number) => {
        Text(char)
          .fontSize($r('app.float.content_font_size'))
          .fontColor(this.BOUNCE_COLORS[index % this.BOUNCE_COLORS.length])
          .fontWeight(FontWeight.Bold)
          .opacity(this.charOpacities[index])
          .scale({
            x: this.charScales[index],
            y: this.charScales[index]
          })
          .translate({ y: this.charOffsets[index] })
          .margin({ left: index === 0 ? 0 : 2 })
      }, (char: string, index: number) => index.toString())
    }
    .width(Constants.FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
    .height(60)
  }
}
