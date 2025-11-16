// DeepSeek API配置和调用工具
const config = require('./config.js');

const DEEPSEEK_API_URL = 'https://api.deepseek.com/v1/chat/completions';
const DEEPSEEK_API_KEY = config.DEEPSEEK_API_KEY;

/**
 * 调用DeepSeek API获取AI回复
 * @param {Array} messages - 对话消息历史 [{role: 'user'|'assistant'|'system', content: string}]
 * @param {Object} options - 可选参数
 * @returns {Promise} 返回API响应
 */
function callDeepSeekAPI(messages, options = {}) {
  return new Promise((resolve, reject) => {
    // 调试信息：检查API密钥是否加载
    console.log('API密钥检查:', DEEPSEEK_API_KEY ? `已配置(${DEEPSEEK_API_KEY.substring(0, 10)}...)` : '未配置');
    
    // 如果API_KEY未配置
    if (!DEEPSEEK_API_KEY || DEEPSEEK_API_KEY.trim() === '') {
      console.warn('DeepSeek API Key未配置，请在utils/config.js中设置API密钥');
      reject(new Error('API密钥未配置，请在utils/config.js中设置您的DeepSeek API密钥'));
      return;
    }

    wx.request({
      url: DEEPSEEK_API_URL,
      method: 'POST',
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${DEEPSEEK_API_KEY}`
      },
      data: {
        model: options.model || 'deepseek-chat',
        messages: messages,
        temperature: options.temperature || 0.7,
        max_tokens: options.max_tokens || 2000,
        stream: false
      },
      success: (res) => {
        if (res.statusCode === 200 && res.data && res.data.choices && res.data.choices.length > 0) {
          const content = res.data.choices[0].message.content;
          resolve(content);
        } else {
          console.error('DeepSeek API响应错误:', res);
          reject(new Error(res.data?.error?.message || 'API响应格式错误'));
        }
      },
      fail: (err) => {
        console.error('DeepSeek API请求失败:', err);
        reject(err);
      }
    });
  });
}

/**
 * 格式化消息历史为DeepSeek API格式
 * @param {Array} messages - 消息列表 [{type: 'user'|'ai', content: string}]
 * @param {String} taskName - 任务名称
 * @param {String} taskDesc - 任务描述
 * @returns {Array} 格式化后的消息数组
 */
function formatMessagesForAPI(messages, taskName = '', taskDesc = '') {
  const formattedMessages = [];
  
  // 添加系统提示词
  const systemPrompt = `你是一个AI学习助手，专门帮助学生完成学习任务。当前讨论的任务是"${taskName}"，任务描述：${taskDesc}。请针对用户的问题提供有帮助的、专业的回答。`;
  formattedMessages.push({
    role: 'system',
    content: systemPrompt
  });

  // 转换消息格式
  messages.forEach(msg => {
    if (msg.type === 'user') {
      formattedMessages.push({
        role: 'user',
        content: msg.content
      });
    } else if (msg.type === 'ai') {
      formattedMessages.push({
        role: 'assistant',
        content: msg.content
      });
    }
  });

  return formattedMessages;
}

module.exports = {
  callDeepSeekAPI,
  formatMessagesForAPI,
  DEEPSEEK_API_KEY
}

