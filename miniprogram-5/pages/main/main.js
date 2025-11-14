Page({
  data: {
    courseInfo: {
      title: '物联网设计基础',
      term: '2024年秋季',
      desc: '通过动手实践学习物联网核心技术',
      progress: 65,
      totalTasks: 12,
      completedTasks: 8,
      completionRate: 67
    }
  },
  onLoad() {
    // 页面加载
  },
  enterCourse() {
    wx.navigateTo({
      url: '/pages/task/task'
    });
  }
})

