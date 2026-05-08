import { SingleGoodsItem } from "."

// 排序字段类型
export type SortField = 'publishTime' | 'orderNum' | 'price'
// 排序方法
export type SortMethod = 'desc' | 'asc'

// 请求参数
@ObservedV2
export class SearchParams {
  @Trace keyword: string = "" // 关键字
  @Trace sortField: SortField = "publishTime" // 排序字段
  @Trace sortMethod: SortMethod = "desc" // 排序方法
  page: number = 1 // 页码
  pageSize: number = 10 // 每页项目数
}

// 定义搜索结果类型
export interface SearchResult {
  // conditions:
  pageData: SingleGoodsItem
}

// 排序相关组件参数
export interface SortComponentOptions {
  field: SortField
  label: string
}

export interface SearchRouterParam {
  keyword: string
}

