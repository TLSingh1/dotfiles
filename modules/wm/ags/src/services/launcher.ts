import { Variable } from "astal";

export class LauncherService {
  private static instance: LauncherService;

  readonly isOpen = Variable(false);
  readonly searchQuery = Variable("");
  readonly selectedIndex = Variable(0);

  static get() {
    if (!this.instance) {
      this.instance = new LauncherService();
    }
    return this.instance;
  }

  constructor() {
    // Initialize launcher service
  }

  toggle() {
    this.isOpen.set(!this.isOpen.get());
  }

  open() {
    this.isOpen.set(true);
  }

  close() {
    this.isOpen.set(false);
    this.searchQuery.set("");
    this.selectedIndex.set(0);
  }
}
