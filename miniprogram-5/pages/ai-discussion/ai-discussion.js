Page({
  data: {},
  onLoad(options) {
    // 可以在这里接收任务ID等参数
    if (options.taskId) {
      console.log('任务ID:', options.taskId);
    }
  },
  goBack() {
    wx.navigateBack();
  }
})

