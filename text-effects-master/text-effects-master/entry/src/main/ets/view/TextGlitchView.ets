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
export default struct TextGlitchView {
  @State message: ResourceStr = '';
  @State glitchOffset: number = 0;
  @State colorShift: number = 0;
  @State scanLineOffset: number = 0;
  @State intensity: number = 1.0;
  
  // 故障颜色
  private readonly GLITCH_RED: string = '#FF0040';
  private readonly GLITCH_CYAN: string = '#00FFFF';
  private readonly GLITCH_WHITE: string = '#FFFFFF';

  build() {
    Stack() {
      // 主文字层
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.GLITCH_WHITE)
        .fontWeight(FontWeight.Bold)
        .zIndex(2)
      
      // 红色偏移层（向左偏移）
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.GLITCH_RED)
        .fontWeight(FontWeight.Bold)
        .opacity(0.8)
        .translate({
          x: -this.glitchOffset * 2,
          y: Math.sin(this.colorShift) * 2
        })
        .zIndex(1)
      
      // 青色偏移层（向右偏移）
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.GLITCH_CYAN)
        .fontWeight(FontWeight.Bold)
        .opacity(0.8)
        .translate({
          x: this.glitchOffset * 2,
          y: -Math.sin(this.colorShift) * 2
        })
        .zIndex(1)
      
      // 扫描线效果
      Column() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8], (item: number) => {
          Row()
            .width(Constants.FULL_PERCENT)
            .height(2)
            .backgroundColor(Color.Black)
            .opacity(0.3)
        }, (item: number) => item.toString())
      }
      .width(Constants.FULL_PERCENT)
      .height($r('app.float.content_font_size'))
      .justifyContent(FlexAlign.SpaceBetween)
      .translate({ y: Math.sin(this.scanLineOffset) * 5 })
      .zIndex(3)
      .opacity(0.15)
    }
    .width(Constants.FULL_PERCENT)
    .alignContent(Alignment.Center)
  }

  aboutToAppear(): void {
    // 延迟初始化，等待UI上下文准备好
    setTimeout(() => {
      this.startGlitchAnimation();
    }, 100);
  }

  private startGlitchAnimation(): void {
    // 主故障动画 - 抖动效果
    animateTo({
      duration: 100,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.glitchOffset = 0;
      }
    }, () => {
      // 随机抖动幅度
      this.glitchOffset = Math.random() * 3 * this.intensity;
    });
    
    // 颜色偏移动画
    animateTo({
      duration: 200,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.colorShift = 0;
      }
    }, () => {
      this.colorShift = Math.PI * 2;
    });
    
    // 扫描线动画
    animateTo({
      duration: 1500,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.scanLineOffset = 0;
      }
    }, () => {
      this.scanLineOffset = Math.PI * 2;
    });
    
    // 强度变化动画 - 模拟故障强度变化
    animateTo({
      duration: 800,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.EaseInOut,
      iterations: -1,
      delay: 300,
      onFinish: () => {
        this.intensity = 0.5;
      }
    }, () => {
      this.intensity = 1.5;
    });
  }
}
