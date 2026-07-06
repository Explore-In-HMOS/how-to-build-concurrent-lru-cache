import { ArkTSUtils } from '@kit.ArkTS';

@Sendable
export class SensorData {
  gyroX: number = 0;
  gyroY: number = 0;
  gyroZ: number = 0;
  accelX: number = 0;
  accelY: number = 0;
  accelZ: number = 0;
  heartRate: number = 0;
}

export class SensorModel {
  private lruCache = new ArkTSUtils.SendableLruCache<string, SensorData>();
  private cacheLock = new ArkTSUtils.locks.AsyncLock();

  updateSensorData(userId: string, newData: Partial<SensorData>): void {
    this.cacheLock.lockAsync(() => {
      const raw = this.lruCache.get(userId);
      const current: SensorData = raw ?? new SensorData();

      if (newData.accelX !== undefined && newData.accelX !== 0) { current.accelX = newData.accelX; }
      if (newData.accelY !== undefined && newData.accelY !== 0) { current.accelY = newData.accelY; }
      if (newData.accelZ !== undefined && newData.accelZ !== 0) { current.accelZ = newData.accelZ; }
      if (newData.gyroX !== undefined && newData.gyroX !== 0) { current.gyroX = newData.gyroX; }
      if (newData.gyroY !== undefined && newData.gyroY !== 0) { current.gyroY = newData.gyroY; }
      if (newData.gyroZ !== undefined && newData.gyroZ !== 0) { current.gyroZ = newData.gyroZ; }
      if (newData.heartRate !== undefined && newData.heartRate !== 0) { current.heartRate = newData.heartRate; }

      this.lruCache.put(userId, current);
    }).catch((err: Error) => {
      console.error(`Cache update failed: ${err.message}`);
    });
  }

  getCachedData(userId: string): SensorData | undefined {
    return this.lruCache.get(userId);
  }

  getAllCachedEntries(): Object[][] {
    return Array.from(this.lruCache.entries());
  }
}

export interface AxisData {
  label: string;
  value: number;
  unit: string;
}

export interface SensorStatusItem {
  label: string;
  active: boolean;
}
