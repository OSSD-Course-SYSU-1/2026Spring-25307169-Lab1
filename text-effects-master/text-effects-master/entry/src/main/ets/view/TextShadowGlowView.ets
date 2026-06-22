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
export default struct TextShadowGlowView {
  @State message: ResourceStr = '';
  @State glowIntensity: number = 0.5;
  @State shadowOffsetX: number = 5;
  @State shadowOffsetY: number = 5;
  @State glowColor: Color = Color.Yellow;
  @State shadowColor: Color = Color.Gray;

  build() {
    Stack() {
      // 阴影层
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(this.shadowColor)
        .fontWeight(FontWeight.Bold)
        .offset({
          x: this.shadowOffsetX,
          y: this.shadowOffsetY
        })
        .opacity(0.6)

      // 发光层
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .shadow({
          radius: 10 + (this.glowIntensity * 20),
          color: this.glowColor,
          offsetX: 0,
          offsetY: 0
        })

      // 主文字层
      Text(this.message)
        .fontSize($r('app.float.content_font_size'))
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
    }
    .width(Constants.FULL_PERCENT)
    .height($r('app.float.text_shadow_height'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onAppear(() => {
      // 添加动画效果 - 发光强度变化
      animateTo({
        duration: 2000,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.EaseInOut,
        iterations: -1,
        onFinish: () => {
          this.glowIntensity = 0.5;
        }
      }, () => {
        this.glowIntensity = 1.0;
      });

      // 添加动画效果 - 阴影位置变化
      animateTo({
        duration: 3000,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: Curve.EaseInOut,
        iterations: -1,
        delay: 1000,
        onFinish: () => {
          this.shadowOffsetX = 5;
          this.shadowOffsetY = 5;
        }
      }, () => {
        this.shadowOffsetX = 8;
        this.shadowOffsetY = 8;
      });
    })
  }
}