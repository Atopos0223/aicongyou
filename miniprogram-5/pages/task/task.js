Page({
  data: {
    totalScore: 1630,
    tasks: [
      { 
        id: 1, 
        name: '数据处理与分析', 
        desc: '对采集的数据进行处理和分析',
        type: '个人任务',
        deadline: '2024-12-22',
        submitted: 12,
        total: 24,
        submitRate: 50,
        popularity: 78
      },
      { 
        id: 2, 
        name: '系统设计与实现', 
        desc: '完成系统的整体设计和核心功能实现',
        type: '个人任务',
        deadline: '2024-12-25',
        submitted: 18,
        total: 24,
        submitRate: 75,
        popularity: 92
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
        popularity: 65
      }
    ]
  },
  onLoad() {
    // 可以在这里加载任务数据
  },
  goBack() {
    wx.navigateBack();
  },
  viewExcellentWork(e) {
    const taskId = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: `/pages/excellent-work/excellent-work?taskId=${taskId}`
    });
  },
  aiDiscussion(e) {
    const taskId = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: `/pages/ai-discussion/ai-discussion?taskId=${taskId}`
    });
  }
})

