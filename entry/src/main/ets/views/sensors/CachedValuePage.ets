import { SensorViewModel } from '../../viewmodels/SensorViewModel';

@ComponentV2
export struct CachedValuePage {
  @Param @Require vm: SensorViewModel = new SensorViewModel();

  build() {
    Column({ space: 14 }) {
      Text('Last Cached')
        .fontSize(11)
        .fontColor('#888888')
        .letterSpacing(1)

      Text(this.vm.cachedSnapshot !== '' ? this.vm.cachedSnapshot : 'No data yet')
        .fontSize(12)
        .fontColor('#CCCCCC')
        .textAlign(TextAlign.Center)
        .width('80%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}