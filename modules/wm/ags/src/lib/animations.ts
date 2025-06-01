import { Variable } from "astal";
import { timeout } from "astal/time";

export type EasingFunction = (t: number) => number;

export const Easing = {
  linear: (t: number) => t,
  easeInQuad: (t: number) => t * t,
  easeOutQuad: (t: number) => t * (2 - t),
  easeInOutQuad: (t: number) => (t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t),
  easeInCubic: (t: number) => t * t * t,
  easeOutCubic: (t: number) => --t * t * t + 1,
  easeInOutCubic: (t: number) =>
    t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1,
};

export class Animation {
  readonly progress = Variable(0);
  private running = false;

  constructor(
    private duration: number = 300,
    private easing: EasingFunction = Easing.easeOutQuad
  ) {}

  async animate(from: number, to: number) {
    if (this.running) return;

    this.running = true;
    const startTime = Date.now();
    const range = to - from;

    while (this.running) {
      const elapsed = Date.now() - startTime;
      const progress = Math.min(elapsed / this.duration, 1);
      const easedProgress = this.easing(progress);
      const value = from + range * easedProgress;

      this.progress.set(value);

      if (progress >= 1) {
        this.running = false;
        break;
      }

      await timeout(16); // ~60fps
    }
  }

  stop() {
    this.running = false;
  }
}
