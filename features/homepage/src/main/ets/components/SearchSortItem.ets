import { SortField, SortMethod } from "basic";

@ComponentV2
export struct SearchSortItem {
  @Param field: SortField = 'publishTime' // 排序字段
  @Param label: string = '' // 标签
  @Param sortField: SortField = 'publishTime' // 父组件排序字段
  @Param sortMethod: SortMethod = 'desc' // 父组件排序方法
  @Event onSortChange: (field: SortField, method: SortMethod) => void = () => {} // 改变排序字段和排序回调

  build() {
    Row() {
      Text(this.label)
        .fontWeight(500)
        .fontSize(14)
        .fontColor(this.sortField == this.field ? $r('[basic].color.black') : $r('[basic].color.gray'))
      Column() {
        Image($r('[basic].media.ic_public_up'))
          .width(15)
          .height(6)
          .fillColor(this.sortField == this.field && this.sortMethod == 'asc' ? $r('[basic].color.black') : $r('[basic].color.gray'))
        Image($r('[basic].media.ic_public_down'))
          .width(15)
          .height(6)
          .fillColor(this.sortField == this.field && this.sortMethod == 'desc' ? $r('[basic].color.black') : $r('[basic].color.gray'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .onClick(() => {})
  }
}