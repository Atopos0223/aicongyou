// DeepSeek API配置和调用工具
const config = require('./config.js');

const API_BASE_URL = config.API_BASE_URL || 'http://localhost:8080';
const BACKEND_AI_ENDPOINT = `${API_BASE_URL}/api/ai/chat`;

/**
 * 调用DeepSeek API获取AI回复
 * @param {Array} messages - 对话消息历史 [{role: 'user'|'assistant'|'system', content: string}]
 * @param {Object} options - 可选参数
 * @returns {Promise} 返回API响应
 */
function callDeepSeekAPI(messages, options = {}) {
  return new Promise((resolve, reject) => {
    if (!API_BASE_URL) {
      console.warn('后端服务地址未配置，请在utils/config.js中设置API_BASE_URL');
      reject(new Error('后端服务地址未配置'));
      return;
    }

    wx.request({
      url: BACKEND_AI_ENDPOINT,
      method: 'POST',
      header: {
        'Content-Type': 'application/json'
      },
      data: {
        model: options.model || 'deepseek-chat',
        messages: messages,
        temperature: options.temperature !== undefined ? options.temperature : 0.7,
        max_tokens: options.max_tokens !== undefined ? options.max_tokens : 2000
      },
      success: (res) => {
        if (res.statusCode === 200 && res.data && res.data.content) {
          resolve(res.data.content);
        } else {
          console.error('后端AI接口响应错误:', res);
          reject(new Error(res.data?.message || 'AI接口响应异常'));
        }
      },
      fail: (err) => {
        console.error('后端AI接口请求失败:', err);
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
  formatMessagesForAPI
}

