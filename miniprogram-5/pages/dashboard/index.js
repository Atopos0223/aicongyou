const app = getApp()

Page({
  data: {
    dashboardData: {
      totalCourseScore: 0, // 课程总得分（汇总所有任务得分）
      ranking: 0, // 总排名
      totalStudents: 0 // 总人数
    },
    abilityDimensions: [
      {
        id: 1,
        name: '问题分析能力',
        achievementRate: 0,
        color: '#1989fa',
        description: '能够识别和定义复杂工程问题'
      },
      {
        id: 2,
        name: '设计开发能力',
        achievementRate: 0,
        color: '#7232dd',
        description: '能够设计满足特定需求的系统或组件'
      },
      {
        id: 3,
        name: '研究能力',
        achievementRate: 0,
        color: '#07c160',
        description: '能够运用研究方法进行工程问题研究'
      },
      {
        id: 4,
        name: '使用现代工具能力',
        achievementRate: 0,
        color: '#ff976a',
        description: '能够选择和使用现代工程工具'
      },
      {
        id: 5,
        name: '工程与社会',
        achievementRate: 0,
        color: '#ffb300',
        description: '能够理解工程对社会的影响'
      },
      {
        id: 6,
        name: '环境和可持续发展',
        achievementRate: 0,
        color: '#667eea',
        description: '能够理解工程对环境的影响'
      }
    ],
    completedTasks: [],
    pendingTasks: [],
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
      // 模拟课程总得分（汇总所有任务得分）
      const totalCourseScore = 1630
      
      // 模拟总排名数据
      const ranking = 15
      const totalStudents = 120
      
      // 模拟能力维度达成度
      const abilityDimensions = [
        {
          id: 1,
          name: '问题分析能力',
          achievementRate: 85,
          color: '#1989fa',
          description: '能够识别和定义复杂工程问题'
        },
        {
          id: 2,
          name: '设计开发能力',
          achievementRate: 78,
          color: '#7232dd',
          description: '能够设计满足特定需求的系统或组件'
        },
        {
          id: 3,
          name: '研究能力',
          achievementRate: 82,
          color: '#07c160',
          description: '能够运用研究方法进行工程问题研究'
        },
        {
          id: 4,
          name: '使用现代工具能力',
          achievementRate: 90,
          color: '#ff976a',
          description: '能够选择和使用现代工程工具'
        },
        {
          id: 5,
          name: '工程与社会',
          achievementRate: 75,
          color: '#ffb300',
          description: '能够理解工程对社会的影响'
        },
        {
          id: 6,
          name: '环境和可持续发展',
          achievementRate: 80,
          color: '#667eea',
          description: '能够理解工程对环境的影响'
        }
      ]
      
      // 模拟已完成任务列表
      const completedTasks = [
        { id: 1, name: '数据处理与分析', score: 90, completedDate: '2024-01-15' },
        { id: 2, name: '系统设计文档', score: 88, completedDate: '2024-01-14' },
        { id: 3, name: '项目需求分析', score: 92, completedDate: '2024-01-12' },
        { id: 4, name: '数据库设计', score: 85, completedDate: '2024-01-10' }
      ]
      
      // 模拟待完成任务列表
      const pendingTasks = [
        { id: 5, name: '系统测试报告', deadline: '2024-01-20', isUrgent: true },
        { id: 6, name: '项目总结报告', deadline: '2024-01-25', isUrgent: false },
        { id: 7, name: '代码审查', deadline: '2024-01-18', isUrgent: true }
      ]
      
      this.setData({
        dashboardData: {
          totalCourseScore,
          ranking,
          totalStudents
        },
        abilityDimensions,
        completedTasks,
        pendingTasks,
        loading: false
      })
      
      // 更新缓存
      wx.setStorageSync('dashboardData', {
        totalCourseScore,
        ranking,
        totalStudents
      })
      wx.setStorageSync('abilityDimensions', abilityDimensions)
      wx.setStorageSync('completedTasks', completedTasks)
      wx.setStorageSync('pendingTasks', pendingTasks)
    }, 1000)
  },

  refreshData() {
    const cachedDashboardData = wx.getStorageSync('dashboardData')
    const cachedAbilityDimensions = wx.getStorageSync('abilityDimensions')
    const cachedCompletedTasks = wx.getStorageSync('completedTasks')
    const cachedPendingTasks = wx.getStorageSync('pendingTasks')
    
    if (cachedDashboardData) {
      this.setData({ dashboardData: cachedDashboardData })
    }
    if (cachedAbilityDimensions) {
      this.setData({ abilityDimensions: cachedAbilityDimensions })
    }
    if (cachedCompletedTasks) {
      this.setData({ completedTasks: cachedCompletedTasks })
    }
    if (cachedPendingTasks) {
      this.setData({ pendingTasks: cachedPendingTasks })
    }
  },

  goBack() {
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