const API_BASE_URL = 'http://localhost:8080';

Page({
  data: {
    totalScore: 1630,
    activeTab: 'team',
    courseId: null,
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
    ],
    teamSummary: {},
    teamTasks: [],
    teamLoading: true,
    teamError: ''
  },
  onLoad(options) {
    const courseId = options && options.courseId ? Number(options.courseId) : null;
    this.setData({ courseId });
    this.fetchTeamBoard(courseId);
  },
  goBack() {
    wx.navigateBack();
  },
  switchTab(e) {
    const tab = e.currentTarget.dataset.tab;
    if (tab && tab !== this.data.activeTab) {
      this.setData({ activeTab: tab });
      if (tab === 'team' && !this.data.teamTasks.length && !this.data.teamError) {
        this.fetchTeamBoard(this.data.courseId);
      }
    }
  },
  fetchTeamBoard(courseId) {
    this.setData({ teamLoading: true, teamError: '' });
    wx.request({
      url: `${API_BASE_URL}/api/team-board`,
      method: 'GET',
      data: courseId ? { courseId } : {},
      success: (res) => {
        if (res.statusCode === 200 && res.data) {
          const { summary = {}, tasks = [] } = res.data;
          const normalizedTasks = tasks.map((task) => {
            const submittedMembers = task.submittedMembers !== undefined && task.submittedMembers !== null ? task.submittedMembers : 0;
            const totalMembers = task.totalMembers !== undefined && task.totalMembers !== null ? task.totalMembers : 0;
            return {
              ...task,
              deadline: task.deadline || '待定',
              teamName: task.teamName || '未命名团队',
              submittedMembers,
              totalMembers,
              submitRate: this.formatNumber(task.submitRate),
              teamScore: this.formatNumber(task.teamScore),
              individualContribution: this.formatNumber(task.individualContribution)
            };
          });

          this.setData({
            teamSummary: {
              totalTeamScore: this.formatNumber(summary.totalTeamScore),
              averageContribution: this.formatNumber(summary.averageContribution),
              totalTasks: summary.totalTasks !== undefined && summary.totalTasks !== null ? summary.totalTasks : normalizedTasks.length,
              topTeamName: summary.topTeamName || ((normalizedTasks[0] && normalizedTasks[0].teamName) || '未命名团队'),
              updatedAt: summary.updatedAt || ''
            },
            teamTasks: normalizedTasks,
            teamLoading: false
          });
        } else {
          this.handleTeamError('团队任务数据获取失败');
        }
      },
      fail: () => this.handleTeamError('网络异常，请稍后重试')
    });
  },
  formatNumber(value) {
    if (value === null || value === undefined || value === '') {
      return 0;
    }
    const num = Number(value);
    if (Number.isNaN(num)) {
      return 0;
    }
    return Math.round(num * 100) / 100;
  },
  handleTeamError(message) {
    this.setData({ teamError: message, teamLoading: false });
  },
  retryTeamBoard() {
    this.fetchTeamBoard(this.data.courseId);
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
  },
  goToSubmission(e) {
    const { taskId, teamName, taskName, courseId, taskType } = e.currentTarget.dataset;
    const query = [];
    if (taskId !== undefined) {
      query.push(`taskId=${taskId}`);
    }
    if (taskType) {
      query.push(`taskType=${taskType}`);
    }
    if (taskName) {
      query.push(`taskName=${encodeURIComponent(taskName)}`);
    }
    if (teamName) {
      query.push(`teamName=${encodeURIComponent(teamName)}`);
    }
    if (courseId !== undefined) {
      query.push(`courseId=${courseId}`);
    }
    const queryString = query.join('&');
    wx.navigateTo({
      url: queryString ? `/pages/submisson/submisson?${queryString}` : '/pages/submisson/submisson'
    });
  }
})

