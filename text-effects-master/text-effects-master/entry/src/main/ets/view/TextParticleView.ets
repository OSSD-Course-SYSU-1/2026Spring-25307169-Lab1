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
export default struct TextParticleView {
  @State message: ResourceStr = '';
  @State particleScale: number = 1.0;
  @State particleOpacity: number = 1.0;
  @State explosionProgress: number = 0;
  @State colorPhase: number = 0;
  
  // 粒子颜色数组
  private particleColors: string[] = [
    '#FF6B6B', // 红色
    '#4ECDC4', // 青色
    '#45B7D1', // 蓝色
    '#FFA07A', // 橙色
    '#98D8C8', // 薄荷绿
    '#F7DC6F', // 金色
    '#BB8FCE', // 紫色
    '#85C1E9'  // 天蓝
  ];
  
  // 获取粒子颜色
  private getParticleColor(index: number): string {
    const colorIndex = (index + Math.floor(this.colorPhase)) % this.particleColors.length;
    return this.particleColors[colorIndex];
  }
  
  // 计算粒子X偏移
  private calculateParticleOffsetX(index: number, total: number): number {
    const angle = (index / total) * Math.PI * 2 + this.explosionProgress;
    const radius = Math.sin(this.explosionProgress * 2) * 15;
    return Math.cos(angle) * radius;
  }
  
  // 计算粒子Y偏移
  private calculateParticleOffsetY(index: number, total: number): number {
    const angle = (index / total) * Math.PI * 2 + this.explosionProgress;
    const radius = Math.sin(this.explosionProgress * 2) * 15;
    return Math.sin(angle) * radius;
  }
  
  // 计算旋转角度
  private calculateRotation(index: number): number {
    return Math.sin(this.explosionProgress + index) * 10;
  }

  build() {
    Row() {
      Stack() {
        // 使用ForEach创建粒子效果的每个字符
        ForEach(this.message.toString().split(''), (char: string, index: number) => {
          Text(char)
            .fontSize($r('app.float.content_font_size'))
            .fontColor(this.getParticleColor(index))
            .fontWeight(FontWeight.Bold)
            .opacity(this.particleOpacity * 0.8)
            .scale({
              x: this.particleScale,
              y: this.particleScale
            })
            .translate({
              x: this.calculateParticleOffsetX(index, this.message.toString().length),
              y: this.calculateParticleOffsetY(index, this.message.toString().length)
            })
            .rotate({
              angle: this.calculateRotation(index)
            })
            .shadow({
              radius: 5,
              color: this.getParticleColor(index),
              offsetX: 0,
              offsetY: 0
            })
        }, (char: string, index: number) => index.toString())
      }
      .width(Constants.FULL_PERCENT)
      .height($r('app.float.text_wave_height'))
    }
    .width(Constants.FULL_PERCENT)
    .height($r('app.float.text_wave_height'))
    .justifyContent(FlexAlign.Center)
    .linearGradient({
      angle: 135,
      colors: [
        ['#1a1a2e', 0.0],
        ['#16213e', 0.5],
        ['#0f3460', 1.0]
      ]
    })
    .borderRadius($r('app.float.row_border_radius'))
  }

  aboutToAppear(): void {
    // 延迟初始化，等待UI上下文准备好
    setTimeout(() => {
      this.startParticleAnimation();
    }, 100);
  }

  private startParticleAnimation(): void {
    // 粒子缩放动画 - 呼吸效果
    animateTo({
      duration: 1200,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.EaseInOut,
      iterations: -1,
      onFinish: () => {
        this.particleScale = 1.0;
      }
    }, () => {
      this.particleScale = 1.15;
    });
    
    // 透明度脉动动画
    animateTo({
      duration: 800,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.EaseInOut,
      iterations: -1,
      delay: 200,
      onFinish: () => {
        this.particleOpacity = 1.0;
      }
    }, () => {
      this.particleOpacity = 0.7;
    });
    
    // 爆炸进度动画
    animateTo({
      duration: 2000,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.explosionProgress = 0;
      }
    }, () => {
      this.explosionProgress = Math.PI * 2;
    });
    
    // 颜色相位动画 - 颜色流动
    animateTo({
      duration: 3000,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: -1,
      onFinish: () => {
        this.colorPhase = 0;
      }
    }, () => {
      this.colorPhase = this.particleColors.length;
    });
  }
}
