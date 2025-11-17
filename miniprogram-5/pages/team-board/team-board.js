const API_BASE_URL = 'http://localhost:8080';

Page({
  data: {
    loading: true,
    error: '',
    summary: {},
    teamTasks: [],
    courseId: null
  },

  onLoad(options) {
    const courseId = options && options.courseId ? Number(options.courseId) : null;
    this.setData({ courseId });
    this.fetchTeamBoard(courseId);
  },

  fetchTeamBoard(courseId) {
    this.setData({ loading: true, error: '' });
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
            summary: {
              totalTeamScore: this.formatNumber(summary.totalTeamScore),
              averageContribution: this.formatNumber(summary.averageContribution),
              totalTasks: summary.totalTasks !== undefined && summary.totalTasks !== null ? summary.totalTasks : normalizedTasks.length,
              topTeamName: summary.topTeamName || ((normalizedTasks[0] && normalizedTasks[0].teamName) || '未命名团队'),
              updatedAt: summary.updatedAt || ''
            },
            teamTasks: normalizedTasks,
            loading: false
          });
        } else {
          this.handleError('团队看板数据获取失败');
        }
      },
      fail: () => this.handleError('网络异常，请稍后重试')
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

  handleError(message) {
    this.setData({ error: message, loading: false });
  },

  retryFetch() {
    this.fetchTeamBoard(this.data.courseId);
  },

  goBack() {
    wx.navigateBack({ delta: 1 });
  }
});

