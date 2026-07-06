import worker, { MessageEvents } from '@ohos.worker';
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@ohos.base';

const workerPort = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  if (e.data === 'stopGyro') {
    try {
      sensor.off(sensor.SensorId.GYROSCOPE);
    } catch (error) {
      const e: BusinessError = error as BusinessError;
      console.error(`Failed to stop Gyroscope worker. Code: ${e.code}, message: ${e.message}`);
    }

    return;
  }

  if (e.data !== 'startGyro') { return; }

  const INTERVAL = 100000000;
  try {
    sensor.on(sensor.SensorId.GYROSCOPE, (data: sensor.GyroscopeResponse) => {
      workerPort.postMessage({ x: data.x, y: data.y, z: data.z });
    }, { interval: INTERVAL });
  } catch (error) {
    const e: BusinessError = error as BusinessError;
    console.error(`Gyroscope worker error. Code: ${e.code}, message: ${e.message}`);
  }
}