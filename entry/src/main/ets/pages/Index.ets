import { AxisData } from '../models/SensorModel';
import { SensorViewModel } from '../viewmodels/SensorViewModel';
import { PageDots } from '../views/components/PageDots';
import { AxisPage } from '../views/sensors/AxisPage';
import { CachedValuePage } from '../views/sensors/CachedValuePage';
import { HeartRatePage } from '../views/sensors/HeartRatePage';
import { StatusPage } from '../views/sensors/StatusPage';

@Entry
@ComponentV2
struct Index {
  private vm: SensorViewModel = new SensorViewModel();

  @Local currentPage: number = 0;

  private readonly pageCount: number = 5;

  aboutToDisappear(): void {
    this.vm.stopAllSensors();
  }

  private getAccelerometerAxes(): AxisData[] {
    return [
      {
        label: 'X',
        value: this.vm.accelX,
        unit: 'm/s²'
      },
      {
        label: 'Y',
        value: this.vm.accelY,
        unit: 'm/s²'
      },
      {
        label: 'Z',
        value: this.vm.accelZ,
        unit: 'm/s²'
      }
    ];
  }

  private getGyroscopeAxes(): AxisData[] {
    return [
      {
        label: 'X',
        value: this.vm.gyroX,
        unit: 'rad/s'
      },
      {
        label: 'Y',
        value: this.vm.gyroY,
        unit: 'rad/s'
      },
      {
        label: 'Z',
        value: this.vm.gyroZ,
        unit: 'rad/s'
      }
    ];
  }

  private toggleAccelerometer(): void {
    if (this.vm.isAccelerometerActive) {
      this.vm.stopAccelerometer();
      return;
    }

    this.vm.startAccelerometer();
  }

  private toggleGyroscope(): void {
    if (this.vm.isGyroscopeActive) {
      this.vm.stopGyroscope();
      return;
    }

    this.vm.startGyroscope();
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Swiper() {
        StatusPage({ vm: this.vm })

        AxisPage({
          title: 'Accelerometer',
          isActive: this.vm.isAccelerometerActive,
          unit: 'm/s²',
          axes: this.getAccelerometerAxes(),
          onToggle: () => {
            this.toggleAccelerometer();
          }
        })

        AxisPage({
          title: 'Gyroscope',
          isActive: this.vm.isGyroscopeActive,
          unit: 'rad/s',
          axes: this.getGyroscopeAxes(),
          onToggle: () => {
            this.toggleGyroscope();
          }
        })

        HeartRatePage({ vm: this.vm })

        CachedValuePage({ vm: this.vm })
      }
      .width('100%')
      .height('100%')
      .index(this.currentPage)
      .onChange((index: number) => {
        this.currentPage = index;
      })
      .indicator(false)
      .loop(false)

      PageDots({
        total: this.pageCount,
        current: this.currentPage
      })
        .margin({ bottom: 18 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0A0A0A')
  }
}