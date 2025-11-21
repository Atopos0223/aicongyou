const API_BASE_URL = 'http://localhost:8080';

Page({
  data: {
    courseId: null,
    initialTaskId: null,
    initialTaskType: 'team',
    initialSelectionApplied: false,
    taskCategoryOptions: [
      { label: '个人任务', value: 'personal' },
      { label: '团队任务', value: 'team' }
    ],
    selectedCategoryIndex: 1,
    selectedCategoryValue: 'team',
    selectedTaskCategory: '',
    personalTasks: [],
    teamTasks: [],
    loadingPersonal: true,
    loadingTeam: true,
    errorPersonal: '',
    errorTeam: '',
    currentTasks: [],
    currentLoading: true,
    currentError: '',
    selectedTaskIndex: 0,
    selectedTaskId: null,
    selectedTaskName: '',
    selectedTeamName: '',
    selectedTaskDeadline: '',
    formDescription: '',
    fileList: [],
    submitting: false,
    canSubmit: false
  },
  onLoad(options) {
    const courseId = options && options.courseId ? Number(options.courseId) : null;
    const initialTaskId = options && options.taskId ? Number(options.taskId) : null;
    const presetTaskName = options && options.taskName ? decodeURIComponent(options.taskName) : '';
    const presetTeamName = options && options.teamName ? decodeURIComponent(options.teamName) : '';
    const incomingTaskType = options && options.taskType ? options.taskType : 'team';
    const defaultCategoryValue = incomingTaskType === 'personal' ? 'personal' : 'team';
    const defaultIndex = this.data.taskCategoryOptions.findIndex((item) => item.value === defaultCategoryValue);
    const safeIndex = defaultIndex >= 0 ? defaultIndex : 0;
    this.setData({
      courseId,
      initialTaskId,
      initialTaskType: defaultCategoryValue,
      selectedCategoryIndex: safeIndex,
      selectedCategoryValue: this.data.taskCategoryOptions[safeIndex].value,
      selectedTaskName: presetTaskName,
      selectedTeamName: presetTeamName,
      selectedTaskCategory: '',
      initialSelectionApplied: false
    }, () => {
      this.updateCurrentCategoryState();
      this.fetchPersonalTasks();
      this.fetchTeamTasks(courseId);
    });
  },
  goBack() {
    wx.navigateBack();
  },
  fetchPersonalTasks() {
    this.setData({ loadingPersonal: true, errorPersonal: '' }, () => this.updateCurrentCategoryState());
    const params = { taskType: 'personal' };
    if (this.data.courseId !== null && this.data.courseId !== undefined) {
      params.courseId = this.data.courseId;
    }
    wx.request({
      url: `${API_BASE_URL}/api/tasks`,
      method: 'GET',
      data: params,
      success: (res) => {
        if (res.statusCode === 200 && Array.isArray(res.data)) {
          const normalized = res.data.map((task) => ({
            ...task,
            deadline: task.deadline || '待定',
            teamName: ''
          }));
          this.setData({
            personalTasks: normalized,
            loadingPersonal: false,
            errorPersonal: ''
          }, () => this.updateCurrentCategoryState());
        } else {
          this.handleTaskError('personal', '个人任务获取失败');
        }
      },
      fail: () => this.handleTaskError('personal', '个人任务获取失败')
    });
  },
  fetchTeamTasks(courseId) {
    this.setData({ loadingTeam: true, errorTeam: '' }, () => this.updateCurrentCategoryState());
    wx.request({
      url: `${API_BASE_URL}/api/team-board`,
      method: 'GET',
      data: courseId ? { courseId } : {},
      success: (res) => {
        if (res.statusCode === 200 && res.data) {
          const { tasks = [] } = res.data;
          const normalizedTasks = tasks.map((task) => ({
            ...task,
            deadline: task.deadline || '待定',
            teamName: task.teamName || '未命名团队',
            submitRate: this.formatNumber(task.submitRate)
          }));
          this.setData({
            teamTasks: normalizedTasks,
            loadingTeam: false,
            errorTeam: ''
          }, () => this.updateCurrentCategoryState());
        } else {
          this.handleTaskError('team', '团队任务获取失败');
        }
      },
      fail: () => this.handleTaskError('team', '网络异常，请稍后重试')
    });
  },
  updateCurrentCategoryState() {
    const category = this.data.selectedCategoryValue;
    const tasks = category === 'team' ? this.data.teamTasks : this.data.personalTasks;
    const loading = category === 'team' ? this.data.loadingTeam : this.data.loadingPersonal;
    const error = category === 'team' ? this.data.errorTeam : this.data.errorPersonal;
    this.setData({
      currentTasks: tasks,
      currentLoading: loading,
      currentError: error
    }, () => {
      if (!loading) {
        this.ensureTaskSelection();
      } else {
        this.setData({
          selectedTaskId: null,
          selectedTaskName: this.data.selectedTaskName,
          selectedTaskDeadline: '',
          selectedTeamName: this.data.selectedTeamName
        }, () => this.updateCanSubmit());
      }
    });
  },
  ensureTaskSelection() {
    const { currentTasks, selectedCategoryValue, selectedTaskId, selectedTaskCategory, initialSelectionApplied, initialTaskId, initialTaskType } = this.data;
    if (!currentTasks || !currentTasks.length) {
      this.setData({
        selectedTaskIndex: 0,
        selectedTaskId: null,
        selectedTaskName: '',
        selectedTeamName: '',
        selectedTaskDeadline: ''
      }, () => this.updateCanSubmit());
      return;
    }
    let preferredTaskId = null;
    if (!initialSelectionApplied && initialTaskId !== null && initialTaskId !== undefined && initialTaskType === selectedCategoryValue) {
      preferredTaskId = initialTaskId;
    } else if (selectedTaskCategory === selectedCategoryValue && selectedTaskId) {
      preferredTaskId = selectedTaskId;
    }
    let targetIndex = 0;
    if (preferredTaskId !== null && preferredTaskId !== undefined) {
      const foundIndex = currentTasks.findIndex((task) => String(task.taskId) === String(preferredTaskId));
      if (foundIndex >= 0) {
        targetIndex = foundIndex;
      }
    }
    const safeIndex = Math.max(0, Math.min(targetIndex, currentTasks.length - 1));
    const task = currentTasks[safeIndex];
    this.setData({
      selectedTaskIndex: safeIndex,
      selectedTaskId: task ? task.taskId || null : null,
      selectedTaskName: task ? task.taskName || '' : '',
      selectedTeamName: selectedCategoryValue === 'team' ? (task && task.teamName ? task.teamName : '') : '',
      selectedTaskDeadline: task ? (task.deadline || '待定') : '',
      selectedTaskCategory: selectedCategoryValue,
      initialSelectionApplied: initialSelectionApplied || (initialTaskType === selectedCategoryValue)
    }, () => this.updateCanSubmit());
  },
  handleCategoryChange(e) {
    const index = Number(e.detail.value);
    if (Number.isNaN(index)) {
      return;
    }
    const option = this.data.taskCategoryOptions[index];
    if (!option) {
      return;
    }
    this.setData({
      selectedCategoryIndex: index,
      selectedCategoryValue: option.value
    }, () => this.updateCurrentCategoryState());
  },
  handleTaskChange(e) {
    const index = Number(e.detail.value);
    if (Number.isNaN(index)) {
      return;
    }
    const tasks = this.data.currentTasks || [];
    if (!tasks.length) {
      return;
    }
    const safeIndex = Math.max(0, Math.min(index, tasks.length - 1));
    const task = tasks[safeIndex];
    this.setData({
      selectedTaskIndex: safeIndex,
      selectedTaskId: task ? task.taskId || null : null,
      selectedTaskName: task ? task.taskName || '' : '',
      selectedTeamName: this.data.selectedCategoryValue === 'team' ? (task && task.teamName ? task.teamName : '') : '',
      selectedTaskDeadline: task ? (task.deadline || '待定') : '',
      selectedTaskCategory: this.data.selectedCategoryValue
    }, () => this.updateCanSubmit());
  },
  handleDescriptionInput(e) {
    this.setData({ formDescription: e.detail.value || '' }, () => this.updateCanSubmit());
  },
  handleFileAfterRead(event) {
    const rawFile = event.detail && (event.detail.file || event.detail.files || event.detail.fileList);
    const files = Array.isArray(rawFile) ? rawFile : [rawFile];
    const file = files[0];
    if (!file) {
      return;
    }
    const fileUrl = file.url || file.path || file.tempFilePath;
    if (!fileUrl) {
      wx.showToast({ title: '未获取到文件路径', icon: 'none' });
      return;
    }
    const normalized = {
      url: fileUrl,
      name: file.name || file.fileName || '附件',
      size: file.size || 0
    };
    this.setData({ fileList: [normalized] }, () => this.updateCanSubmit());
  },
  handleFileDelete() {
    this.setData({ fileList: [] }, () => this.updateCanSubmit());
  },
  updateCanSubmit() {
    const { selectedTaskId, formDescription, fileList } = this.data;
    const canSubmit = Boolean(
      selectedTaskId &&
      formDescription &&
      formDescription.trim().length &&
      Array.isArray(fileList) &&
      fileList.length
    );
    this.setData({ canSubmit });
  },
  submitTask() {
    const {
      canSubmit,
      submitting,
      fileList,
      selectedTaskId,
      selectedTaskIndex,
      selectedCategoryValue,
      selectedTeamName,
      formDescription,
      currentTasks
    } = this.data;
    if (!canSubmit || submitting) {
      return;
    }
    const currentTask = currentTasks[selectedTaskIndex];
    if (!currentTask) {
      wx.showToast({ title: '请选择有效的任务', icon: 'none' });
      return;
    }
    const file = fileList[0];
    if (!file || !file.url) {
      wx.showToast({ title: '请上传附件', icon: 'none' });
      return;
    }
    this.setData({ submitting: true });
    wx.uploadFile({
      url: `${API_BASE_URL}/api/team-board/submit`,
      filePath: file.url,
      name: 'file',
      formData: {
        taskId: selectedTaskId,
        taskType: selectedCategoryValue,
        teamName: selectedCategoryValue === 'team' ? (selectedTeamName || currentTask.teamName || '') : '',
        description: formDescription.trim(),
        submitterName: '团队成员'
      },
      success: (res) => {
        let payload = {};
        try {
          payload = JSON.parse(res.data);
        } catch (err) {
          payload = {};
        }
        if (res.statusCode === 200 && (payload.success === undefined || payload.success)) {
          wx.showToast({ title: payload.message || '提交成功', icon: 'success' });
          this.setData({ formDescription: '', fileList: [] }, () => this.updateCanSubmit());
        } else {
          wx.showToast({ title: (payload && payload.message) || '提交失败，请重试', icon: 'none' });
        }
      },
      fail: () => {
        wx.showToast({ title: '提交失败，请检查网络', icon: 'none' });
      },
      complete: () => {
        this.setData({ submitting: false });
      }
    });
  },
  retryTasks() {
    this.fetchPersonalTasks();
    this.fetchTeamTasks(this.data.courseId);
  },
  handleTaskError(category, message) {
    if (category === 'team') {
      this.setData({ errorTeam: message, loadingTeam: false }, () => this.updateCurrentCategoryState());
    } else {
      this.setData({ errorPersonal: message, loadingPersonal: false }, () => this.updateCurrentCategoryState());
    }
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
  }
});

