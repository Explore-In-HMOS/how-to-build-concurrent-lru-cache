import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS';
import { sensor } from '@kit.SensorServiceKit';
import { SensorModel } from '../models/SensorModel';

const USER_ID = 'userId';
const CACHE_INTERVAL_MS = 1000;

@ObservedV2
export class SensorViewModel {
  private model: SensorModel = new SensorModel();

  private accelWorker: worker.ThreadWorker | null = null;
  private gyroWorker: worker.ThreadWorker | null = null;
  private heartRateWorker: worker.ThreadWorker | null = null;

  private accelIntervalId: number = -1;
  private gyroIntervalId: number = -1;
  private heartRateIntervalId: number = -1;

  @Trace isAccelerometerActive: boolean = false;
  @Trace isGyroscopeActive: boolean = false;
  @Trace isHeartRateActive: boolean = false;

  @Trace accelX: number = 0;
  @Trace accelY: number = 0;
  @Trace accelZ: number = 0;

  @Trace gyroX: number = 0;
  @Trace gyroY: number = 0;
  @Trace gyroZ: number = 0;

  @Trace heartRate: number = 0;

  @Trace cachedSnapshot: string = '';

  // ACCELEROMETER ------------------------

  startAccelerometer(): void {
    if (this.isAccelerometerActive) { return; }
    this.isAccelerometerActive = true;

    this.accelWorker = new worker.ThreadWorker('entry/ets/workers/AccelerometerWorker.ets');

    this.accelWorker.onmessage = (e: MessageEvents) => {
      const data: sensor.AccelerometerResponse = e.data;
      this.accelX = data.x;
      this.accelY = data.y;
      this.accelZ = data.z;
      console.info(`Accel → x: ${data.x}, y: ${data.y}, z: ${data.z}`);
    };

    this.accelWorker.onerror = (err: ErrorEvent) => {
      console.error(`Accelerometer worker error: ${err.message}`);
    };

    try {
      this.accelWorker.postMessage('startAccel');
    } catch (error) {
      console.error(`Failed to start accelerometer worker: ${(error as Error).message}`);
    }

    this.accelIntervalId = setInterval(() => {
      this.model.updateSensorData(USER_ID, {
        accelX: this.accelX,
        accelY: this.accelY,
        accelZ: this.accelZ
      });
      this.logAllCachedData();
    }, CACHE_INTERVAL_MS);
  }

  stopAccelerometer(): void {
    if (!this.isAccelerometerActive) { return; }
    this.isAccelerometerActive = false;

    clearInterval(this.accelIntervalId);
    this.accelIntervalId = -1;

    try {
      this.accelWorker?.postMessage('stopAccel');
      this.accelWorker?.terminate();
    } catch (error) {
      console.error(`Failed to stop accelerometer worker: ${(error as Error).message}`);
    }

    this.accelWorker = null;
  }

  // GYROSCOPE ----------------------------

  startGyroscope(): void {
    if (this.isGyroscopeActive) { return; }
    this.isGyroscopeActive = true;

    this.gyroWorker = new worker.ThreadWorker('entry/ets/workers/GyroscopeWorker.ets');

    this.gyroWorker.onmessage = (e: MessageEvents) => {
      const data: sensor.GyroscopeResponse = e.data;
      this.gyroX = data.x;
      this.gyroY = data.y;
      this.gyroZ = data.z;
      console.info(`Gyro → x: ${data.x}, y: ${data.y}, z: ${data.z}`);
    };

    this.gyroWorker.onerror = (err: ErrorEvent) => {
      console.error(`Gyroscope worker error: ${err.message}`);
    };

    try {
      this.gyroWorker.postMessage('startGyro');
    } catch (error) {
      console.error(`Failed to start gyroscope worker: ${(error as Error).message}`);
    }

    this.gyroIntervalId = setInterval(() => {
      this.model.updateSensorData(USER_ID, {
        gyroX: this.gyroX,
        gyroY: this.gyroY,
        gyroZ: this.gyroZ
      });
      this.logAllCachedData();
    }, CACHE_INTERVAL_MS);
  }

  stopGyroscope(): void {
    if (!this.isGyroscopeActive) { return; }
    this.isGyroscopeActive = false;

    clearInterval(this.gyroIntervalId);
    this.gyroIntervalId = -1;

    try {
      this.gyroWorker?.postMessage('stopGyro');
      this.gyroWorker?.terminate();
    } catch (error) {
      console.error(`Failed to stop gyroscope worker: ${(error as Error).message}`);
    }

    this.gyroWorker = null;
  }

  // HEART RATE ---------------------------

  startHeartRate(): void {
    if (this.isHeartRateActive) { return; }
    this.isHeartRateActive = true;

    this.heartRateWorker = new worker.ThreadWorker('entry/ets/workers/HeartRateWorker.ets');

    this.heartRateWorker.onmessage = (e: MessageEvents) => {
      const data: sensor.HeartRateResponse = e.data;
      this.heartRate = data.heartRate;
      console.info(`Heart Rate → ${data.heartRate}`);
    };

    this.heartRateWorker.onerror = (err: ErrorEvent) => {
      console.error(`Heart rate worker error: ${err.message}`);
    };

    try {
      this.heartRateWorker.postMessage('startHeartRate');
    } catch (error) {
      console.error(`Failed to start heart rate worker: ${(error as Error).message}`);
    }

    this.heartRateIntervalId = setInterval(() => {
      this.model.updateSensorData(USER_ID, {
        heartRate: this.heartRate
      });
      this.logAllCachedData();
    }, CACHE_INTERVAL_MS);
  }

  stopHeartRate(): void {
    if (!this.isHeartRateActive) { return; }
    this.isHeartRateActive = false;

    clearInterval(this.heartRateIntervalId);
    this.heartRateIntervalId = -1;

    try {
      this.heartRateWorker?.postMessage('stopHeartRate');
      this.heartRateWorker?.terminate();
    } catch (error) {
      console.error(`Failed to stop heart rate worker: ${(error as Error).message}`);
    }

    this.heartRateWorker = null;
  }

  // HELPERS ------------------------------

  stopAllSensors(): void {
    this.stopAccelerometer();
    this.stopGyroscope();
    this.stopHeartRate();
  }

  logAllCachedData(): void {
    const entries = this.model.getAllCachedEntries();
    this.cachedSnapshot = Array.from(entries)
      .map(value => `${value[0]}: ${JSON.stringify(value[1])}`)
      .join('\n');
  }
}
