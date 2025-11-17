const app = getApp()

Page({
  data: {
    studentInfo: {
      name: '张三',
      studentId: '202401001',
      avatar: '/images/avatar.png',
      className: '物联网工程1班'
    },
    dashboardData: {
      completedTasks: 8,
      totalTasks: 12,
      averageScore: 85.5,
      completionRate: 67,
      totalScore: 1630,
      ranking: 15,
      totalStudents: 120
    },
    recentActivities: [
      { id: 1, title: '完成了任务：数据处理与分析', time: '2024-01-15 14:30', score: 90 },
      { id: 2, title: '提交了作业：系统设计文档', time: '2024-01-14 10:20', score: 88 },
      { id: 3, title: '参与了AI讨论', time: '2024-01-13 16:45', score: null }
    ],
    loading: false
  },

  onLoad() {
    this.loadDashboardData()
  },

  onShow() {
    this.refreshData()
  },

  loadDashboardData() {
    this.setData({ loading: true })
    
    // 模拟API调用 - 实际项目中替换为真实接口
    setTimeout(() => {
      const mockData = {
        completedTasks: 8,
        totalTasks: 12,
        averageScore: 85.5,
        completionRate: 67,
        totalScore: 1630,
        ranking: 15,
        totalStudents: 120
      }
      
      this.setData({
        dashboardData: mockData,
        loading: false
      })
      
      // 更新缓存
      wx.setStorageSync('dashboardData', mockData)
    }, 1000)
  },

  refreshData() {
    const cachedData = wx.getStorageSync('dashboardData')
    if (cachedData) {
      this.setData({ dashboardData: cachedData })
    }
  },

  navigateToPersonalTasks() {
    wx.navigateTo({
      url: '/pages/personal-tasks/index'
    })
  },

  navigateToTaskList() {
    wx.navigateTo({
      url: '/pages/task/task'
    })
  },

  navigateToMain() {
    wx.navigateBack()
  },

  // 分享功能
  onShareAppMessage() {
    return {
      title: '我的学习数据看板 - 爱从游',
      path: '/pages/dashboard/index'
    }
  },

  // 分享到朋友圈
  onShareTimeline() {
    return {
      title: '我的学习数据看板 - 爱从游'
    }
  },

  // 下拉刷新
  onPullDownRefresh() {
    this.loadDashboardData()
    setTimeout(() => {
      wx.stopPullDownRefresh()
    }, 1000)
  }
})