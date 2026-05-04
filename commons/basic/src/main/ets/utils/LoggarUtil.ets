import { Log } from '@abner/log'

/**
 * 封装Log日志记录工具
 */
Log.init({
  tag: 'miaoStreet_', // 模块标识
  domain: 0x0000, // 模块域
  close: false, // 是否关闭日志
  isHilog: true, // 是否使用HiLog
  showLogLocation: true, // 是否显示日志位置
  logSize: 800 // 日志缓存大小
})

export { Log as Loggar }
