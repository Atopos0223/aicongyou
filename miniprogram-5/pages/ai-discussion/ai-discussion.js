// 引入AI接口
const api = require('../../utils/api.js');

// 任务数据映射（实际应用中应该从后端获取）
const taskDataMap = {
  '1': { name: '数据处理与分析', desc: '对采集的数据进行处理和分析' },
  '2': { name: '系统设计与实现', desc: '完成系统的整体设计和核心功能实现' },
  '3': { name: '项目文档编写', desc: '编写完整的项目开发文档和使用说明' }
};

Page({
  data: {
    taskId: '',
    taskName: '',
    taskDesc: '',
    messages: [], // 消息列表
    inputValue: '', // 输入框内容
    isLoading: false, // AI是否正在回复
    showTranslate: false, // 是否显示翻译
    scrollIntoView: '' // 滚动到指定消息
  },

  onLoad(options) {
    // 接收任务ID参数
    const taskId = options.taskId || '1';
    const taskData = taskDataMap[taskId] || taskDataMap['1'];
    
    // 初始化欢迎消息
    const welcomeMessage = {
      id: Date.now(),
      type: 'ai', // ai 或 user
      content: `你好!我是AI学习助手。我已准备好针对"${taskData.name}"任务进行讨论。你可以提出任何疑问,我会帮你分析任务要求、提供解决思路。有什么我可以帮助的吗?`,
      timestamp: Date.now()
    };

    this.setData({
      taskId: taskId,
      taskName: taskData.name,
      taskDesc: taskData.desc,
      messages: [welcomeMessage]
    });

    // 设置导航栏标题
    wx.setNavigationBarTitle({
      title: `AI讨论:${taskData.name}`
    });

    // 延迟滚动到底部，确保消息渲染完成
    setTimeout(() => {
      this.scrollToBottom(welcomeMessage.id);
    }, 300);
  },

  // 返回上一页
  goBack() {
    wx.navigateBack();
  },

  // 翻译功能（切换）
  toggleTranslate() {
    this.setData({
      showTranslate: !this.data.showTranslate
    });
  },

  // 输入框内容变化
  onInputChange(e) {
    this.setData({
      inputValue: e.detail.value
    });
  },

  // 发送消息
  sendMessage() {
    const content = this.data.inputValue.trim();
    if (!content || this.data.isLoading) {
      return;
    }

    // 添加用户消息
    const userMessage = {
      id: Date.now(),
      type: 'user',
      content: content,
      timestamp: Date.now()
    };

    const messages = [...this.data.messages, userMessage];
    this.setData({
      messages: messages,
      inputValue: '',
      isLoading: true
    });

    // 滚动到底部
    this.scrollToBottom(userMessage.id);

    // 调用DeepSeek API获取智能回复
    this.getAIResponse(content);
  },

  // 获取AI回复（调用DeepSeek API，带本地Fallback）
  async getAIResponse(userMessage) {
    let aiContent = '';
    try {
      const formattedMessages = api.formatMessagesForAPI(
        this.data.messages,
        this.data.taskName,
        this.data.taskDesc
      );

      aiContent = await api.callDeepSeekAPI(formattedMessages, {
        model: 'deepseek-chat',
        temperature: 0.7,
        max_tokens: 1500
      });
    } catch (error) {
      console.error('获取AI回复失败:', error);
      const errorHint = this.getAIErrorHint(error);
      const fallback = this.generateFallbackReply(userMessage);
      aiContent = errorHint ? `${errorHint}\n\n${fallback}` : fallback;

      wx.showToast({
        title: 'AI服务暂不可用',
        icon: 'none',
        duration: 2000
      });
    }

    // 添加AI回复
    const aiMessage = {
      id: Date.now(),
      type: 'ai',
      content: aiContent,
      timestamp: Date.now()
    };

    const messages = [...this.data.messages, aiMessage];
    this.setData({
      messages: messages,
      isLoading: false
    });

    // 滚动到底部
    this.scrollToBottom(aiMessage.id);
  },

  // AI接口异常提示
  getAIErrorHint(error) {
    if (!error) return '';
    if (error.message && error.message.includes('API密钥')) {
      return 'AI服务尚未配置，请联系管理员完成DeepSeek密钥配置。';
    }
    if (error.errMsg && error.errMsg.includes('request:fail')) {
      return '网络连接异常，我先根据既有经验给你一个参考方案：';
    }
    return '实时AI服务暂不可用，我先根据既有经验给出一些建议：';
  },

  // 本地兜底回复逻辑
  generateFallbackReply(userMessage = '') {
    const lowerMessage = (userMessage || '').toLowerCase();

    if (lowerMessage.includes('要求') || lowerMessage.includes('需要做什么') || lowerMessage.includes('任务内容')) {
      return `根据任务"${this.data.taskName}"的要求：${this.data.taskDesc}。你需要深入理解任务目标，制定详细的执行计划，并按照步骤逐步完成。建议先从任务分析开始，明确每个环节的具体要求和验收标准。`;
    }
    if (lowerMessage.includes('步骤') || lowerMessage.includes('如何') || lowerMessage.includes('怎么')) {
      return `完成任务"${this.data.taskName}"的一般步骤包括：\n1. 明确任务目标和具体要求\n2. 收集和整理相关资料\n3. 制定详细的执行计划\n4. 按计划逐步实施\n5. 进行测试和验证\n6. 完善和优化\n7. 总结和反思\n\n你可以根据具体情况调整这些步骤。`;
    }
    if (lowerMessage.includes('困难') || lowerMessage.includes('问题') || lowerMessage.includes('遇到')) {
      return `遇到困难是很正常的，不要担心！建议你：\n1. 先明确具体遇到了什么问题\n2. 查阅相关文档和资料\n3. 尝试多种解决方案\n4. 如果还是无法解决，可以向老师或同学寻求帮助\n5. 记住每次解决问题的经验\n\n能详细说说你遇到的具体问题吗？我可以帮你分析。`;
    }
    if (lowerMessage.includes('工具') || lowerMessage.includes('软件') || lowerMessage.includes('技术')) {
      return `针对"${this.data.taskName}"这个任务，建议使用以下工具和技术：\n• 根据任务性质选择合适的开发工具\n• 使用版本控制工具管理代码（如Git）\n• 参考官方文档和最佳实践\n• 合理利用AI辅助工具提高效率\n\n你想了解哪个具体工具的使用方法吗？`;
    }

    const defaultReplies = [
      `关于"${this.data.taskName}"任务，你的问题很好。让我帮你分析一下：这个任务的核心是${this.data.taskDesc}。建议你从任务目标出发，系统地思考每个环节，制定清晰的计划后再开始执行。`,
      `理解了你的问题。针对"${this.data.taskName}"，我建议你可以：\n1. 先梳理任务的关键要点\n2. 查找相关案例和参考资料\n3. 列出可能遇到的问题和解决方案\n4. 开始执行并持续优化\n\n有什么具体需要帮助的吗？`,
      `这是一个很好的思考角度。对于"${this.data.taskName}"任务，建议你：\n• 深入理解任务背景和目标\n• 分析任务的关键环节和难点\n• 制定合理的时间安排\n• 保持学习和实践的热情\n\n还有什么其他问题吗？`
    ];
    return defaultReplies[Math.floor(Math.random() * defaultReplies.length)];
  },

  // 滚动到底部
  scrollToBottom(messageId) {
    if (messageId) {
      this.setData({
        scrollIntoView: `msg-${messageId}`
      });
    }
  }
})

