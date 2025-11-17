const SEASON_ORDER = {
  '春季': 1,
  '夏季': 2,
  '秋季': 3,
  '冬季': 4
};

function parseTermInfo(term = '') {
  const match = term.match(/(\d{4})年(春季|夏季|秋季|冬季)/);
  if (!match) {
    return { year: 0, season: 0 };
  }
  return {
    year: Number(match[1]),
    season: SEASON_ORDER[match[2]] || 0
  };
}

function compareTermDesc(termA = '', termB = '') {
  const infoA = parseTermInfo(termA);
  const infoB = parseTermInfo(termB);
  if (infoA.year !== infoB.year) {
    return infoB.year - infoA.year;
  }
  if (infoA.season !== infoB.season) {
    return infoB.season - infoA.season;
  }
  return (termA || '').localeCompare(termB || '');
}

function sortCoursesByTerm(courses = []) {
  return [...courses].sort((a, b) => compareTermDesc(a.term, b.term));
}

function buildTerms(courses = []) {
  const uniqueTerms = [];
  courses.forEach(course => {
    if (course.term && !uniqueTerms.includes(course.term)) {
      uniqueTerms.push(course.term);
    }
  });
  uniqueTerms.sort(compareTermDesc);
  return ['全部课程', ...uniqueTerms];
}

Page({
  data: {
    searchKeyword: '',
    selectedTerm: '全部课程',
    terms: ['全部课程'],
    courses: [],
    activeCourseCount: 0,
    loading: false
  },
  
  onLoad() {
    this.loadCourses();
  },

  onShow() {
    // 页面显示时刷新数据
    this.loadCourses();
  },

  // 加载课程列表
  loadCourses() {
    this.setData({ loading: true });
    const { selectedTerm, searchKeyword } = this.data;
    const term = selectedTerm === '全部课程' ? '' : selectedTerm;
    
    wx.request({
      url: 'http://localhost:8080/api/course/list',
      method: 'GET',
      data: {
        userId: 1,
        term: term,
        keyword: searchKeyword
      },
      success: (res) => {
        if (res.data.code === 200) {
          const rawCourses = res.data.data || [];
          this.updateCourseData(rawCourses);
          this.setData({
            loading: false
          });
        } else {
          wx.showToast({
            title: '加载失败',
            icon: 'none'
          });
          this.setData({ loading: false });
        }
      },
      fail: (err) => {
        console.error('请求失败:', err);
        // 如果请求失败，使用模拟数据
        const mockCourses = this.getMockCourses();
        this.updateCourseData(mockCourses);
        this.setData({ loading: false });
      }
    });
  },

  updateCourseData(courseList = []) {
    const sortedCourses = sortCoursesByTerm(courseList);
    const shouldUpdateTerms = this.data.selectedTerm === '全部课程';
    const newData = {
      courses: sortedCourses,
      activeCourseCount: sortedCourses.length
    };
    if (shouldUpdateTerms) {
      newData.terms = buildTerms(sortedCourses);
    }
    this.setData(newData);
  },

  // 模拟数据（用于开发测试）
  getMockCourses() {
    return [
      {
        id: 1,
        title: '物联网设计基础',
        term: '2024年秋季',
        description: '通过动手实践学习物联网核心技术',
        coverColor: '#1989fa',
        totalTasks: 12,
        completedTasks: 8,
        progress: 65,
        completionRate: 67
      },
      {
        id: 2,
        title: 'AI应用开发',
        term: '2024年秋季',
        description: '深入了解AI模型在实际项目中的应用',
        coverColor: '#7232dd',
        totalTasks: 15,
        completedTasks: 6,
        progress: 42,
        completionRate: 40
      },
      {
        id: 3,
        title: 'Web前端开发',
        term: '2024年春季',
        description: '学习现代Web前端开发技术',
        coverColor: '#07c160',
        totalTasks: 10,
        completedTasks: 0,
        progress: 0,
        completionRate: 0
      },
      {
        id: 4,
        title: '大数据分析基础',
        term: '2025年春季',
        description: '学习大数据处理与分析的基础方法与工具',
        coverColor: '#ff976a',
        totalTasks: 14,
        completedTasks: 3,
        progress: 22,
        completionRate: 21
      },
      {
        id: 5,
        title: '智能硬件创新实践',
        term: '2025年秋季',
        description: '围绕智能硬件完成从创意到原型的项目实践',
        coverColor: '#ee0a24',
        totalTasks: 16,
        completedTasks: 5,
        progress: 31,
        completionRate: 31
      },
      {
        id: 6,
        title: 'Python程序设计',
        term: '2023年春季',
        description: '掌握Python语言基础与常用库的应用',
        coverColor: '#ffd01e',
        totalTasks: 12,
        completedTasks: 10,
        progress: 83,
        completionRate: 83
      },
      {
        id: 7,
        title: '计算机网络原理',
        term: '2023年秋季',
        description: '系统学习计算机网络体系结构与核心协议',
        coverColor: '#00c6ff',
        totalTasks: 11,
        completedTasks: 6,
        progress: 55,
        completionRate: 55
      }
    ];
  },

  // 搜索课程
  onSearch(e) {
    const keyword = e.detail || '';
    this.setData({
      searchKeyword: keyword
    });
    this.loadCourses();
  },

  // 搜索输入变化
  onSearchChange(e) {
    const keyword = e.detail || '';
    this.setData({
      searchKeyword: keyword
    });
    // 可以添加防抖逻辑，这里简化处理
    this.loadCourses();
  },

  // 选择学期筛选
  selectTerm(e) {
    const term = e.currentTarget.dataset.term;
    this.setData({
      selectedTerm: term
    });
    this.loadCourses();
  },

  // 进入课程
  enterCourse(e) {
    const courseId = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: `/pages/task/task?courseId=${courseId}`
    });
  },
  enterDashboard() {
    wx.navigateTo({
      url: '/pages/dashboard/index'
    });
  },
  
})
