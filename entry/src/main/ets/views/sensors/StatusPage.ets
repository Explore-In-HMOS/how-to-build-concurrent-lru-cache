import { SensorViewModel } from '../../viewmodels/SensorViewModel';
import { SensorStatusItem } from '../../models/SensorModel';

@ComponentV2
export struct StatusPage {
  @Param @Require vm: SensorViewModel = new SensorViewModel();

  private getStatusItems(): SensorStatusItem[] {
    return [
      {
        label: 'Accelerometer',
        active: this.vm.isAccelerometerActive
      },
      {
        label: 'Gyroscope',
        active: this.vm.isGyroscopeActive
      },
      {
        label: 'Heart Rate',
        active: this.vm.isHeartRateActive
      }
    ];
  }

  build() {
    Column({ space: 10 }) {
      Text('Sensors')
        .fontSize(11)
        .fontColor('#888888')
        .letterSpacing(1)

      Column({ space: 10 }) {
        ForEach(this.getStatusItems(), (item: SensorStatusItem) => {
          Row() {
            Text(item.label)
              .fontSize(13)
              .fontColor('#AAAAAA')

            Blank()

            Circle()
              .width(8)
              .height(8)
              .fill(item.active ? '#4ADE80' : '#333333')
          }
          .width('72%')
        }, (item: SensorStatusItem) => item.label)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}