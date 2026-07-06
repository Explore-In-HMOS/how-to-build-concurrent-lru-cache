import worker, { MessageEvents } from '@ohos.worker';
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@ohos.base';

const workerPort = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  if (e.data === 'stopAccel') {
    try {
      sensor.off(sensor.SensorId.ACCELEROMETER);
    } catch (error) {
      const e: BusinessError = error as BusinessError;
      console.error(`Failed to stop accelerometer. Code: ${e.code}, message: ${e.message}`);
    }

    return;
  }

  if (e.data !== 'startAccel') { return; }

  const INTERVAL = 100000000;
  try {
    sensor.on(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
      workerPort.postMessage({ x: data.x, y: data.y, z: data.z });
    }, { interval: INTERVAL });
  } catch (error) {
    const e: BusinessError = error as BusinessError;
    console.error(`Failed to start accelerometer. Code: ${e.code}, message: ${e.message}`);
  }
}