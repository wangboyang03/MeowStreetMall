export class LazyForEachDataSource<T> implements IDataSource{
  private originArray: T[] = [] // 原始数据
  private listeners: DataChangeListener[] = [] // 存储监听数据变化

  /**
   * 获取数据源总数
   * @returns 返回当前数据源总长度
   */
  totalCount(): number {
    return this.originArray.length
  }

  /**
   * 获取数据源
   * @param index 数据索引
   * @returns 数据源泛型 T 越界时为 undefined
   */
  getData(index: number):T | undefined {
    return this.originArray[index]
  }

  /**
   * 注册数据源变化监听
   * @param listener 数据变化监听对象
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) == -1) {
      this.listeners.push(listener)
    }
  }

  /**
   * 取消数据源变化监听
   * @param listener 需要被移除的监听器
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const index = this.listeners.indexOf(listener)
    if (index > -1) {
      this.listeners.splice(index, 1)
    }
  }

  /**
   * 加载数据 给数据源赋值 自己用的
   * @param data 传入的数据源
   */
  loadDataSource(data: T[]) {
    this.originArray = data
    this.listeners.forEach(listener => listener.onDataReloaded())
  }
}