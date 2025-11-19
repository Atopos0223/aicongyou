Page({
  data: {
    courseId: null,
    courseTitle: '',
    courseTerm: '',
    courseDescription: '',
    coverColor: '#1989fa',
    tasks: [],
    loading: false,
    completedCount: 0,
    completionRate: 0
  },

  onLoad(options) {
    const { courseId, courseTitle, courseTerm, courseDescription, coverColor } = options;
    console.log('课程任务页面参数:', options);
    
    this.setData({
      courseId: courseId,
      courseTitle: courseTitle || '未知课程',
      courseTerm: courseTerm || '',
      courseDescription: courseDescription || '',
      coverColor: coverColor || '#1989fa'
    });
    this.loadCourseTasks();
  },

  onShow() {
    this.loadCourseTasks();
  },

  // 加载课程任务
  loadCourseTasks() {
    this.setData({ loading: true });
    
    wx.request({
      url: 'http://localhost:8080/api/task/list',
      method: 'GET',
      data: {
        courseId: this.data.courseId,
        userId: 1
      },
      success: (res) => {
        if (res.data.code === 200) {
          const tasks = res.data.data || [];
          this.processTasksData(tasks);
        } else {
          wx.showToast({
            title: '加载任务失败',
            icon: 'none'
          });
        }
        this.setData({ loading: false });
      },
      fail: (err) => {
        console.error('请求失败:', err);
        wx.showToast({
          title: '网络错误',
          icon: 'none'
        });
        this.setData({ loading: false });
      }
    });
  },

  // 处理任务数据
  processTasksData(tasks) {
    const processedTasks = tasks.map(task => ({
      ...task,
      deadlineText: this.formatDeadline(task.deadline),
      statusText: task.isCompleted ? '已完成' : '未完成',
      statusClass: task.isCompleted ? 'completed' : 'pending'
    }));

    

    // 计算完成统计
    const completedCount = processedTasks.filter(task => task.isCompleted).length;
    const completionRate = tasks.length > 0 ? Math.round((completedCount / tasks.length) * 100) : 0;

    this.setData({
      tasks: processedTasks,
      completedCount: completedCount,
      completionRate: completionRate
    });
  },

// 格式化截止日期
formatDeadline(deadline) {
  if (!deadline) return '无截止日期';
  
  const deadlineDate = new Date(deadline);
  
  // 直接返回格式化的日期字符串
  return deadlineDate.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
},

  // 切换任务状态
  toggleTaskStatus(e) {
    const taskId = e.currentTarget.dataset.id;
    const task = this.data.tasks.find(t => t.id == taskId);
    
    if (!task) return;
    
    const newStatus = task.isCompleted ? 'pending' : 'completed';
    const score = newStatus === 'completed' ? (task.score || 85) : null;
    
    wx.request({
      url: 'http://localhost:8080/api/task/update-status',
      method: 'POST',
      header: {
        'content-type': 'application/json'
      },
      data: {
        taskId: taskId,
        userId: 1,
        status: newStatus,
        score: score
      },
      success: (res) => {
        if (res.data.code === 200) {
          wx.showToast({
            title: newStatus === 'completed' ? '任务完成!' : '任务重置',
            icon: 'success'
          });
          this.loadCourseTasks();
        } else {
          wx.showToast({
            title: '操作失败',
            icon: 'none'
          });
        }
      },
      fail: (err) => {
        console.error('更新失败:', err);
        wx.showToast({
          title: '网络错误',
          icon: 'none'
        });
      }
    });
  },
// 查看优秀作业
onViewExcellentWork(e) {
  const taskId = e.currentTarget.dataset.id;
  const task = this.data.tasks.find(t => t.id == taskId);
  console.log('查看优秀作业', taskId, task);
  
  // 跳转到优秀作业页面
  wx.navigateTo({
    url: `/pages/excellent-work/excellent-work?taskId=${taskId}&taskTitle=${task.title}`,
    success: () => {
      console.log('跳转到优秀作业页面成功');
    },
    fail: (err) => {
      console.error('跳转失败:', err);
      wx.showToast({
        title: '页面跳转失败',
        icon: 'none'
      });
    }
  });
},

// AI互动讨论
onAiDiscussion(e) {
  const taskId = e.currentTarget.dataset.id;
  const task = this.data.tasks.find(t => t.id == taskId);
  console.log('AI互动讨论', taskId, task);
  
  // 跳转到AI讨论页面
  wx.navigateTo({
    url: `/pages/ai-discussion/ai-discussion?taskId=${taskId}&taskTitle=${task.title}`,
    success: () => {
      console.log('跳转到AI讨论页面成功');
    },
    fail: (err) => {
      console.error('跳转失败:', err);
      wx.showToast({
        title: '页面跳转失败',
        icon: 'none'
      });
    }
  });
},
  // 分享功能
  onShareAppMessage() {
    return {
      title: `${this.data.courseTitle} - 任务列表`,
      path: `/pages/course-tasks/course-tasks?courseId=${this.data.courseId}`
    };
  },

  // 下拉刷新
  onPullDownRefresh() {
    this.loadCourseTasks();
    setTimeout(() => {
      wx.stopPullDownRefresh();
    }, 1000);
  }
});