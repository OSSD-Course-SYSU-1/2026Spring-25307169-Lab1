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
export default struct TextNeonView {
  @State message: ResourceStr = '';
  @State glowIntensity: number = 1.0;
  @State colorIndex: number = 0;
  @State flickerOpacity: number = 1.0;
  
  // 霓虹灯颜色数组
  private neonColors: string[] = [
    '#FF00FF', // 洋红
    '#00FFFF', // 青色
    '#FF0080', // 玫红
    '#00FF00', // 绿色
    '#FF8000', // 橙色
    '#8000FF'  // 紫色
  ];
  
  // 获取当前颜色
  private getCurrentColor(): string {
    return this.neonColors[this.colorIndex % this.neonColors.length];
  }
  
  // 获取发光颜色（稍微透明一些）
  private getGlowColor(): string {
    const baseColor = this.getCurrentColor();
    return baseColor;
  }

  build() {
    Row() {
      Stack() {
        // 最外层发光效果
        Text(this.message)
          .fontSize($r('app.float.content_font_size'))
          .fontColor(this.getGlowColor())
          .fontWeight(FontWeight.Bold)
          .opacity(this.flickerOpacity * 0.3)
          .blur(20 * this.glowIntensity)
        
        // 中层发光效果
        Text(this.message)
          .fontSize($r('app.float.content_font_size'))
          .fontColor(this.getGlowColor())
          .fontWeight(FontWeight.Bold)
          .opacity(this.flickerOpacity * 0.5)
          .blur(10 * this.glowIntensity)
        
        // 内层发光效果
        Text(this.message)
          .fontSize($r('app.float.content_font_size'))
          .fontColor(this.getGlowColor())
          .fontWeight(FontWeight.Bold)
          .opacity(this.flickerOpacity * 0.7)
          .blur(5 * this.glowIntensity)
        
        // 核心文字层
        Text(this.message)
          .fontSize($r('app.float.content_font_size'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .opacity(this.flickerOpacity)
      }
      .width(Constants.FULL_PERCENT)
      .height($r('app.float.text_wave_height'))
    }
    .width(Constants.FULL_PERCENT)
    .height($r('app.float.text_wave_height'))
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#1a1a1a') // 深色背景突出霓虹效果
    .borderRadius($r('app.float.row_border_radius'))
    .onAppear(() => {
      // 颜色循环动画
      animateTo({
        duration: 3000,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.Linear,
        iterations: -1,
        onFinish: () => {
          this.colorIndex = 0;
        }
      }, () => {
        this.colorIndex = this.neonColors.length;
      });
      
      // 发光强度脉动动画
      animateTo({
        duration: 1500,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.EaseInOut,
        iterations: -1,
        onFinish: () => {
          this.glowIntensity = 1.0;
        }
      }, () => {
        this.glowIntensity = 1.5;
      });
      
      // 闪烁效果动画
      animateTo({
        duration: 100,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.Linear,
        iterations: -1,
        delay: 2000
      }, () => {
        this.flickerOpacity = 0.85;
      });
      
      // 恢复闪烁
      animateTo({
        duration: 100,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.Linear,
        iterations: -1,
        delay: 2100
      }, () => {
        this.flickerOpacity = 1.0;
      });
    })
  }
}
