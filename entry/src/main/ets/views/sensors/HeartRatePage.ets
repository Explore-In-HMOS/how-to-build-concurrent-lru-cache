import { SensorViewModel } from '../../viewmodels/SensorViewModel';
import { StatusBadge } from '../components/StatusBadge';

@ComponentV2
export struct HeartRatePage {
  @Param @Require vm: SensorViewModel = new SensorViewModel();

  private toggleHeartRate(): void {
    if (this.vm.isHeartRateActive) {
      this.vm.stopHeartRate();
      return;
    }

    this.vm.startHeartRate();
  }

  build() {
    Column({ space: 0 }) {
      Text('Heart Rate')
        .fontSize(11)
        .fontColor('#888888')
        .letterSpacing(1)
        .margin({ bottom: 4 })

      StatusBadge({ isActive: this.vm.isHeartRateActive })
        .margin({ bottom: 10 })

      Text(this.vm.isHeartRateActive ? `${this.vm.heartRate}` : '—')
        .fontSize(52)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F87171')
        .margin({ bottom: 2 })

      Text('BPM')
        .fontSize(12)
        .fontColor('#7A3A3A')
        .margin({ bottom: 14 })

      Button(this.vm.isHeartRateActive ? 'Stop' : 'Start')
        .fontSize(11)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.vm.isHeartRateActive ? '#F87171' : '#4ADE80')
        .backgroundColor(this.vm.isHeartRateActive ? '#3A1A1A' : '#1A3A1A')
        .borderRadius(20)
        .padding({ left: 20, right: 20, top: 8, bottom: 8 })
        .onClick(() => {
          this.toggleHeartRate();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}