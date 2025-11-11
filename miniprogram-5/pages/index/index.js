// 简单登录：账号 A，密码 123456
Page({
  data: {
    account: '',
    password: ''
  },
  onAccountChange(e) {
    this.setData({ account: e.detail });
  },
  onPasswordChange(e) {
    this.setData({ password: e.detail });
  },
  onLoginTap() {
    const { account, password } = this.data;
    if (account === 'A' && password === '123456') {
      wx.navigateTo({
        url: '/pages/main/main'
      });
    } else {
      wx.showModal({
        title: '登录失败',
        content: '账号或密码错误',
        showCancel: false
      });
    }
  }
})
