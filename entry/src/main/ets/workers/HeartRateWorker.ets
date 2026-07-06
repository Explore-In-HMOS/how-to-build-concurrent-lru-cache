import worker, { MessageEvents } from '@ohos.worker';
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@ohos.base';

const workerPort = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  if (e.data === 'stopHeartRate') {
    try {
      sensor.off(sensor.SensorId.GYROSCOPE);
    } catch (error) {
      const e: BusinessError = error as BusinessError;
      console.error(`Failed to stop HeartRate worker. Code: ${e.code}, message: ${e.message}`);
    }

    return;
  }

  if (e.data !== 'startHeartRate') { return; }

  const INTERVAL = 100000000;
  try {
    sensor.on(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
      workerPort.postMessage({ heartRate: data.heartRate });
    }, { interval: INTERVAL });
  } catch (error) {
    const e: BusinessError = error as BusinessError;
    console.error(`HeartRate worker error. Code: ${e.code}, message: ${e.message}`);
  }
}