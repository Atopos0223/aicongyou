const API_BASE_URL = 'http://localhost:8080';

Page({
  data: {
    totalScore: 1630,
    activeTab: 'personal',
    courseId: null,
    tasks: [],
    personalLoading: false,
    personalError: '',
    teamSummary: {},
    teamTasks: [],
    teamLoading: true,
    teamError: ''
  },
  onLoad(options) {
    const courseId = options && options.courseId ? Number(options.courseId) : null;
    this.setData({ courseId });
    this.fetchPersonalTasks(courseId);
    this.fetchTeamBoard(courseId);
  },
  goBack() {
    wx.navigateBack();
  },
  switchTab(e) {
    const tab = e.currentTarget.dataset.tab;
    if (tab && tab !== this.data.activeTab) {
      this.setData({ activeTab: tab });
      if (tab === 'personal' && !this.data.tasks.length && !this.data.personalError) {
        this.fetchPersonalTasks(this.data.courseId);
      } else if (tab === 'team' && !this.data.teamTasks.length && !this.data.teamError) {
        this.fetchTeamBoard(this.data.courseId);
      }
    }
  },
  fetchPersonalTasks(courseId) {
    this.setData({ personalLoading: true, personalError: '' });
    wx.request({
      url: `${API_BASE_URL}/api/tasks/personal`,
      method: 'GET',
      data: courseId ? { courseId } : {},
      success: (res) => {
        if (res.statusCode === 200 && res.data) {
          const tasks = res.data.map((item) => {
            // 格式化日期
            let deadline = '待定';
            if (item.deadline) {
              const date = new Date(item.deadline);
              const year = date.getFullYear();
              const month = date.getMonth() + 1;
              const day = date.getDate();
              const monthStr = month < 10 ? '0' + month : month;
              const dayStr = day < 10 ? '0' + day : day;
              deadline = `${year}-${monthStr}-${dayStr}`;
            }
            return {
              id: item.taskId,
              name: item.taskName,
              desc: item.description || '',
              type: item.type || '个人任务',
              deadline: deadline,
              submitted: item.submitted || 0,
              total: item.total || 24,
              submitRate: item.submitRate || 0,
              popularity: item.popularity || 0,
              courseId: item.courseId
            };
          });
          this.setData({
            tasks,
            personalLoading: false
          });
        } else {
          this.handlePersonalError('个人任务数据获取失败');
        }
      },
      fail: () => this.handlePersonalError('网络异常，请稍后重试')
    });
  },
  handlePersonalError(message) {
    this.setData({ personalError: message, personalLoading: false });
  },
  retryPersonalTasks() {
    this.fetchPersonalTasks(this.data.courseId);
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
    const { id, taskName, courseId, courseTitle } = e.currentTarget.dataset;
    const query = [];
    if (id !== undefined) {
      query.push(`taskId=${id}`);
    }
    if (taskName) {
      query.push(`taskName=${encodeURIComponent(taskName)}`);
    }
    if (courseId !== undefined) {
      query.push(`courseId=${courseId}`);
    }
    if (courseTitle) {
      query.push(`courseTitle=${encodeURIComponent(courseTitle)}`);
    }
    const queryString = query.join('&');
    wx.navigateTo({
      url: queryString ? `/pages/excellent-work/excellent-work?${queryString}` : '/pages/excellent-work/excellent-work'
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

