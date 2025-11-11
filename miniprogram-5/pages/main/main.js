Page({
  data: {
    content: '',
    loading: false
  },
  onLoad() {
    this.fetchContent();
  },
  onRefresh() {
    this.fetchContent();
  },
  fetchContent() {
    if (this.data.loading) return;
    this.setData({ loading: true });
    wx.request({
      url: 'http://localhost:8080/test',
      method: 'GET',
      success: (res) => {
        const text = typeof res.data === 'string' ? res.data : JSON.stringify(res.data);
        this.setData({ content: text });
      },
      fail: () => {
        wx.showToast({
          title: '获取失败',
          icon: 'none'
        });
      },
      complete: () => {
        this.setData({ loading: false });
      }
    });
  }
})

