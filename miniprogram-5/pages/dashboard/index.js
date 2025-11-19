Page({
  data: {
    studentInfo: {
      name: '张三',
      studentId: '202401001',
      avatar: '/images/avatar.png',
      className: '物联网工程1班'
    },
    dashboardData: {
      completedTasks: 0,
      totalTasks: 0,
      averageScore: 0,
      completionRate: 0,
      totalScore: 0,
      ranking: 15,
      totalStudents: 120
    },
    recentActivities: [],
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
    
    // 从后端获取数据
    wx.request({
      url: 'http://localhost:8080/api/course/list',
      method: 'GET',
      data: { userId: 1 },
      success: (res) => {
        if (res.data.code === 200) {
          const courses = res.data.data || [];
          this.calculateDashboardData(courses);
        }
        this.setData({ loading: false });
      },
      fail: (err) => {
        console.error('获取数据失败:', err);
        this.setData({ loading: false });
      }
    });
  },

  calculateDashboardData(courses) {
    let completedTasks = 0;
    let totalTasks = 0;
    let totalScore = 0;
    let scoreCount = 0;

    courses.forEach(course => {
      completedTasks += course.completedTasks || 0;
      totalTasks += course.totalTasks || 0;
    });

    const completionRate = totalTasks > 0 ? Math.round((completedTasks / totalTasks) * 100) : 0;

    const dashboardData = {
      completedTasks: completedTasks,
      totalTasks: totalTasks,
      averageScore: 85.5, // 可以从数据库计算
      completionRate: completionRate,
      totalScore: 1630, // 可以从数据库计算
      ranking: 15,
      totalStudents: 120
    };

    this.setData({ 
      dashboardData: dashboardData 
    });
    
    wx.setStorageSync('dashboardData', dashboardData);
  },

  refreshData() {
    const cachedData = wx.getStorageSync('dashboardData')
    if (cachedData) {
      this.setData({ dashboardData: cachedData })
    }
  },

  // 删除 navigateToPersonalTasks 和 navigateToTaskList 方法
  navigateToMain() {
    wx.navigateBack()
  },

  // 其他方法保持不变...
  onShareAppMessage() {
    return {
      title: '我的学习数据看板 - 爱从游',
      path: '/pages/dashboard/index'
    }
  },

  onShareTimeline() {
    return {
      title: '我的学习数据看板 - 爱从游'
    }
  },

  onPullDownRefresh() {
    this.loadDashboardData()
    setTimeout(() => {
      wx.stopPullDownRefresh()
    }, 1000)
  }
})