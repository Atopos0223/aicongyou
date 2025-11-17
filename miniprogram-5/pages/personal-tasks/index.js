const app = getApp()

Page({
  data: {
    tasks: [],
    filteredTasks: [], // 新增：存储筛选后的任务
    loading: true,
    tabs: ['全部', '进行中', '已完成', '已逾期'],
    activeTab: 0,
    filterStatus: 'all',
    searchValue: '',
    showFilter: false
  },

  onLoad() {
    this.loadPersonalTasks()
  },

  onShow() {
    this.refreshTasks()
  },

  loadPersonalTasks() {
    this.setData({ loading: true })
    
    // 模拟API调用
    setTimeout(() => {
      const mockTasks = [
        { 
          id: 1, 
          name: '数据处理与分析', 
          desc: '对采集的数据进行处理和分析，完成数据可视化',
          type: '个人任务',
          deadline: '2024-12-22',
          submitted: 12,
          total: 24,
          submitRate: 50,
          popularity: 78,
          studentStatus: 1, // 1-进行中 2-已完成 0-未开始
          score: 90,
          status: 'active',
          isOverdue: false,
          progress: 65
        },
        { 
          id: 2, 
          name: '系统设计与实现', 
          desc: '完成系统的整体设计和核心功能实现',
          type: '小组任务',
          deadline: '2024-12-25',
          submitted: 18,
          total: 24,
          submitRate: 75,
          popularity: 92,
          studentStatus: 1,
          score: null,
          status: 'active',
          isOverdue: false,
          progress: 30
        },
        { 
          id: 3, 
          name: '项目文档编写', 
          desc: '编写完整的项目开发文档和使用说明',
          type: '个人任务',
          deadline: '2024-12-20',
          submitted: 20,
          total: 24,
          submitRate: 83,
          popularity: 65,
          studentStatus: 2, // 已完成
          score: 88,
          status: 'completed',
          isOverdue: false,
          progress: 100
        },
        { 
          id: 4, 
          name: '期末项目答辩', 
          desc: '准备项目答辩材料和演示',
          type: '个人任务',
          deadline: '2024-12-18',
          submitted: 15,
          total: 24,
          submitRate: 63,
          popularity: 85,
          studentStatus: 0, // 未开始
          score: null,
          status: 'pending',
          isOverdue: true,
          progress: 0
        }
      ]
      
      // 处理任务数据，添加计算属性
      const processedTasks = this.processTasks(mockTasks)
      
      this.setData({
        tasks: processedTasks,
        filteredTasks: this.getFilteredTasks(processedTasks),
        loading: false
      })
      
      wx.setStorageSync('personalTasks', processedTasks)
    }, 1500)
  },

  // 处理任务数据，添加计算属性
  processTasks(tasks) {
    return tasks.map(task => {
      return {
        ...task,
        statusText: this.getStatusText(task.studentStatus),
        tagColor: this.getStatusColor(task.studentStatus, task.isOverdue),
        typeColor: this.getTypeColor(task.type)
      }
    })
  },

  refreshTasks() {
    const cachedTasks = wx.getStorageSync('personalTasks')
    if (cachedTasks) {
      this.setData({ 
        tasks: cachedTasks,
        filteredTasks: this.getFilteredTasks(cachedTasks)
      })
    }
  },

  onTabChange(e) {
    const index = e.detail.index
    this.setData({ 
      activeTab: index,
      filterStatus: ['all', 'active', 'completed', 'overdue'][index]
    }, () => {
      // 标签切换后重新筛选任务
      this.updateFilteredTasks()
    })
  },

  onSearch(e) {
    this.setData({
      searchValue: e.detail
    }, () => {
      // 搜索后重新筛选任务
      this.updateFilteredTasks()
    })
  },

  onClearSearch() {
    this.setData({
      searchValue: ''
    }, () => {
      this.updateFilteredTasks()
    })
  },

  // 更新筛选后的任务列表
  updateFilteredTasks() {
    const filteredTasks = this.getFilteredTasks(this.data.tasks)
    this.setData({ filteredTasks })
  },

  getFilteredTasks(tasks) {
    let filtered = tasks
    
    // 按状态筛选
    if (this.data.filterStatus === 'active') {
      filtered = filtered.filter(task => task.studentStatus === 1)
    } else if (this.data.filterStatus === 'completed') {
      filtered = filtered.filter(task => task.studentStatus === 2)
    } else if (this.data.filterStatus === 'overdue') {
      filtered = filtered.filter(task => task.isOverdue)
    }
    
    // 按搜索词筛选
    if (this.data.searchValue) {
      const keyword = this.data.searchValue.toLowerCase()
      filtered = filtered.filter(task => 
        task.name.toLowerCase().includes(keyword) || 
        task.desc.toLowerCase().includes(keyword)
      )
    }
    
    return filtered
  },

  getStatusText(status) {
    const statusMap = {
      0: '未开始',
      1: '进行中',
      2: '已完成'
    }
    return statusMap[status] || '未知'
  },

  getStatusColor(status, isOverdue) {
    if (isOverdue) return '#ff4444'
    
    const colorMap = {
      0: '#999999',
      1: '#1989fa',
      2: '#07c160'
    }
    return colorMap[status] || '#999999'
  },

  getTypeColor(type) {
    return type === '个人任务' ? '#7232dd' : '#00b96b'
  },

  viewTaskDetail(e) {
    const taskId = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/task-detail/index?taskId=${taskId}`
    })
  },

  submitTask(e) {
    const taskId = e.currentTarget.dataset.id
    wx.showActionSheet({
      itemList: ['上传文件', '提交链接', '填写文本'],
      success: (res) => {
        const methods = ['upload', 'link', 'text']
        const method = methods[res.tapIndex]
        this.handleSubmitMethod(taskId, method)
      }
    })
  },

  handleSubmitMethod(taskId, method) {
    wx.showToast({
      title: `使用${method}方式提交`,
      icon: 'none'
    })
  },

  goBack() {
    wx.navigateBack()
  },

  onPullDownRefresh() {
    this.loadPersonalTasks()
    setTimeout(() => {
      wx.stopPullDownRefresh()
    }, 1000)
  },

  onReachBottom() {
    wx.showToast({
      title: '加载更多',
      icon: 'none'
    })
  }
})