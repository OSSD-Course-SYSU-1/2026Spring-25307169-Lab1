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
export default struct TextWaveView {
  @State message: ResourceStr = '';
  @State waveOffset: number = 0;
  @State waveAmplitude: number = 10;
  @State waveColorIndex: number = 0;
  
  // 波浪颜色数组
  private waveColors: Color[] = [
    Color.Blue,
    Color.Green,
    Color.Yellow,
    Color.Red,
    Color.Pink
  ];

  // 计算波浪偏移的Y值
  private calculateWaveY(x: number, offset: number): number {
    return Math.sin(x * 0.3 + offset) * this.waveAmplitude;
  }

  build() {
    // 使用ForEach创建波浪效果的每个字符
    ForEach(this.message.toString().split(''), (char: string, index: number) => {
      Text(char)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.waveColors[this.waveColorIndex % this.waveColors.length])
        .fontWeight(FontWeight.Bold)
        .offset({
          y: this.calculateWaveY(index, this.waveOffset)
        })
        .opacity(0.7 + Math.abs(Math.sin(index * 0.3 + this.waveOffset)) * 0.3)
    }, (char: string, index: number) => index.toString())
  }

  aboutToAppear(): void {
    // 延迟初始化，等待UI上下文准备好
    setTimeout(() => {
      this.startWaveAnimation();
    }, 100);
  }

  private startWaveAnimation(): void {
    // 创建波浪动画
    animateTo({
      duration: Constants.WAVE_ANIMATION_DURATION,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.waveOffset = 0;
        this.waveColorIndex = 0;
      }
    }, () => {
      this.waveOffset = Math.PI * 2; // 完成一个完整的波浪周期
      this.waveColorIndex = this.waveColors.length;
    });

    // 创建振幅变化动画
    animateTo({
      duration: Constants.WAVE_AMPLITUDE_DURATION,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.EaseInOut,
      iterations: -1,
      delay: 500,
      onFinish: () => {
        this.waveAmplitude = 8;
      }
    }, () => {
      this.waveAmplitude = 15;
    });
  }
}