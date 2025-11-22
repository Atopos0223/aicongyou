const API_BASE_URL = 'http://localhost:8080';

Page({
  data: {
    taskId: null,
    courseId: null,
    taskName: '',
    courseTitle: '',
    works: [],
    loading: true,
    error: ''
  },
  onLoad(options) {
    const taskId = options && options.taskId ? Number(options.taskId) : null;
    const courseId = options && options.courseId ? Number(options.courseId) : null;
    const taskName = options && options.taskName ? decodeURIComponent(options.taskName) : '';
    const courseTitle = options && options.courseTitle ? decodeURIComponent(options.courseTitle) : '';
    this.setData({
      taskId,
      courseId,
      taskName,
      courseTitle
    }, () => {
      this.fetchExcellentWorks();
    });
  },
  goBack() {
    wx.navigateBack();
  },
  fetchExcellentWorks() {
    this.setData({ loading: true, error: '' });
    const params = {};
    if (this.data.taskId !== null && this.data.taskId !== undefined) {
      params.taskId = this.data.taskId;
    }
    if (this.data.courseId !== null && this.data.courseId !== undefined) {
      params.courseId = this.data.courseId;
    }
    wx.request({
      url: `${API_BASE_URL}/api/excellent-work`,
      method: 'GET',
      data: params,
      success: (res) => {
        if (res.statusCode === 200 && Array.isArray(res.data)) {
          const normalized = res.data.map((item) => ({
            ...item,
            displayOwner: item.teamName || item.studentName || '优秀团队',
            createdAt: item.createdAt ? item.createdAt.replace('T', ' ') : '',
            liked: false,
            favorited: false
          }));
          const firstItem = normalized[0] || {};
          const derivedTaskName = this.data.taskName || firstItem.taskName || '';
          const derivedCourseTitle = this.data.courseTitle || firstItem.courseTitle || '';
          this.setData({
            works: normalized,
            loading: false,
            taskName: derivedTaskName,
            courseTitle: derivedCourseTitle
          });
        } else {
          this.handleError('优秀作业数据获取失败');
        }
      },
      fail: () => this.handleError('网络异常，请稍后再试')
    });
  },
  handleError(message) {
    this.setData({ error: message, loading: false });
  },
  reload() {
    this.fetchExcellentWorks();
  },
  toggleLike(event) {
    const { id } = event.currentTarget.dataset;
    this.updateWorkState(id, { liked: (item) => !item.liked });
  },
  toggleFavorite(event) {
    const { id } = event.currentTarget.dataset;
    this.updateWorkState(id, { favorited: (item) => !item.favorited });
  },
  updateWorkState(targetId, mutations) {
    const updated = this.data.works.map((item) => {
      if (item.id === targetId) {
        const nextItem = { ...item };
        Object.keys(mutations).forEach((key) => {
          const value = mutations[key];
          nextItem[key] = typeof value === 'function' ? value(item) : value;
        });
        return nextItem;
      }
      return item;
    });
    this.setData({ works: updated });
  },
  previewImage(event) {
    const { url } = event.currentTarget.dataset;
    if (!url) {
      wx.showToast({ title: '暂无预览图片', icon: 'none' });
      return;
    }
    wx.previewImage({
      urls: [url]
    });
  },
  openAttachment(event) {
    const { url } = event.currentTarget.dataset;
    if (!url) {
      wx.showToast({ title: '暂无附件链接', icon: 'none' });
      return;
    }
    const fullUrl = this.buildAttachmentUrl(url);
    console.log('[excellent-work] fullUrl ->', fullUrl);
    
    wx.showActionSheet({
      itemList: ['预览附件', '下载附件'],
      success: (res) => {
        if (res.tapIndex === 0) {
          this.previewAttachment(fullUrl);
        } else if (res.tapIndex === 1) {
          this.downloadAttachment(fullUrl);
        }
      }
    });
  },
  previewAttachment(url) {
    wx.showLoading({ title: '准备预览...' });
    wx.downloadFile({
      url,
      success: (res) => {
        if (res.statusCode === 200) {
          wx.openDocument({
            filePath: res.tempFilePath,
            showMenu: true,
            success: () => {
              wx.showToast({ title: '预览已打开', icon: 'success' });
            },
            fail: () => {
              wx.showToast({ title: '无法打开附件', icon: 'none' });
            }
          });
        } else {
          wx.showToast({ title: '附件下载失败', icon: 'none' });
        }
      },
      fail: () => {
        wx.showToast({ title: '附件下载失败', icon: 'none' });
      },
      complete: () => {
        wx.hideLoading();
      }
    });
  },
  downloadAttachment(url) {
    wx.showLoading({ title: '下载中...' });
    wx.downloadFile({
      url,
      success: (res) => {
        if (res.statusCode === 200) {
          wx.saveFile({
            tempFilePath: res.tempFilePath,
            success: (saveRes) => {
              wx.showToast({ title: '已保存到本地', icon: 'success' });
            },
            fail: () => {
              wx.setClipboardData({
                data: url,
                success: () => {
                  wx.showToast({ title: '保存失败，链接已复制', icon: 'none' });
                }
              });
            }
          });
        } else {
          wx.showToast({ title: '下载失败', icon: 'none' });
        }
      },
      fail: () => {
        wx.showToast({ title: '下载失败', icon: 'none' });
      },
      complete: () => {
        wx.hideLoading();
      }
    });
  },
  buildAttachmentUrl(url) {
    if (!url) {
      return '';
    }
    if (/^https?:\/\//i.test(url)) {
      return url;
    }
    if (url.startsWith('/')) {
      return `${API_BASE_URL}${url}`;
    }
    return `${API_BASE_URL}/${url}`;
  }
});

