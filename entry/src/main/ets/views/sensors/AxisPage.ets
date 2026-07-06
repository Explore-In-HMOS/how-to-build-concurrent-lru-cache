import { AxisData } from '../../models/SensorModel';
import { StatusBadge } from '../components/StatusBadge';

@ComponentV2
export struct AxisPage {
  @Param @Require title: string = '';
  @Param @Require isActive: boolean = false;
  @Param @Require axes: AxisData[] = [];
  @Param @Require unit: string = '';
  @Param onToggle: () => void = () => {};

  build() {
    Column({ space: 0 }) {
      Text(this.title)
        .fontSize(11)
        .fontColor('#888888')
        .letterSpacing(1)
        .margin({ bottom: 4 })

      StatusBadge({ isActive: this.isActive })
        .margin({ bottom: 12 })

      Row({ space: 20 }) {
        ForEach(
          this.axes,
          (axis: AxisData) => {
            Column({ space: 4 }) {
              Text(axis.label)
                .fontSize(10)
                .fontColor('#555555')

              Text(this.isActive ? axis.value.toFixed(2) : '—')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.isActive ? '#D4D4D4' : '#333333')
            }
            .alignItems(HorizontalAlign.Center)
          },
          (axis: AxisData) => axis.label
        )
      }

      Divider()
        .strokeWidth(1)
        .color('#1F1F1F')
        .width(60)
        .margin({ top: 10, bottom: 4 })

      Text(this.unit)
        .fontSize(11)
        .fontColor('#555555')
        .margin({ bottom: 12 })

      Button(this.isActive ? 'Stop' : 'Start')
        .fontSize(11)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.isActive ? '#F87171' : '#4ADE80')
        .backgroundColor(this.isActive ? '#3A1A1A' : '#1A3A1A')
        .borderRadius(20)
        .padding({ left: 20, right: 20, top: 8, bottom: 8 })
        .onClick(this.onToggle)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}