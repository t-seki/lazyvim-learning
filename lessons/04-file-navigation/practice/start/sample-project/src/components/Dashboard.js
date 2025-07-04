// Dashboard Component
// ==================

export class Dashboard {
    constructor(options = {}) {
        this.userManager = options.userManager;
        this.apiClient = options.apiClient;
        this.container = null;
        this.widgets = new Map();
        this.refreshInterval = null;
        this.eventListeners = new Map();
        
        this.initializeEventListeners();
    }

    // Initialization
    initializeEventListeners() {
        // Listen to user manager events
        if (this.userManager) {
            this.userManager.addEventListener('user-authenticated', (user) => {
                this.handleUserAuthenticated(user);
            });
            
            this.userManager.addEventListener('user-updated', (user) => {
                this.handleUserUpdated(user);
            });
            
            this.userManager.addEventListener('user-logout', () => {
                this.handleUserLogout();
            });
        }
    }

    // Rendering
    render() {
        console.log('Rendering dashboard...');
        
        this.container = this.createContainer();
        this.renderHeader();
        this.renderMainContent();
        this.renderSidebar();
        this.renderFooter();
        
        // Attach to DOM
        const appContainer = document.getElementById('app') || document.body;
        appContainer.appendChild(this.container);
        
        // Initialize widgets
        this.initializeWidgets();
        
        // Start periodic updates
        this.startPeriodicUpdates();
        
        console.log('Dashboard rendered successfully');
    }

    createContainer() {
        const container = document.createElement('div');
        container.className = 'dashboard-container';
        container.innerHTML = `
            <div class="dashboard-header"></div>
            <div class="dashboard-main">
                <div class="dashboard-content"></div>
                <div class="dashboard-sidebar"></div>
            </div>
            <div class="dashboard-footer"></div>
        `;
        return container;
    }

    renderHeader() {
        const header = this.container.querySelector('.dashboard-header');
        const currentUser = this.userManager?.getCurrentUser();
        
        header.innerHTML = `
            <div class="header-content">
                <div class="header-left">
                    <h1 class="app-title">Dashboard</h1>
                    <nav class="main-nav">
                        <a href="#dashboard" class="nav-link active">Dashboard</a>
                        <a href="#projects" class="nav-link">Projects</a>
                        <a href="#users" class="nav-link">Users</a>
                        <a href="#settings" class="nav-link">Settings</a>
                    </nav>
                </div>
                <div class="header-right">
                    ${currentUser ? `
                        <div class="user-info">
                            <span class="user-name">${currentUser.firstName || currentUser.username}</span>
                            <button class="user-menu-btn" id="userMenuBtn">▼</button>
                        </div>
                    ` : `
                        <button class="login-btn" id="loginBtn">Login</button>
                    `}
                </div>
            </div>
        `;
        
        this.setupHeaderEventListeners();
    }

    setupHeaderEventListeners() {
        // Navigation links
        const navLinks = this.container.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                this.handleNavigation(link.getAttribute('href').slice(1));
            });
        });
        
        // User menu
        const userMenuBtn = this.container.querySelector('#userMenuBtn');
        if (userMenuBtn) {
            userMenuBtn.addEventListener('click', () => {
                this.toggleUserMenu();
            });
        }
        
        // Login button
        const loginBtn = this.container.querySelector('#loginBtn');
        if (loginBtn) {
            loginBtn.addEventListener('click', () => {
                this.showLoginModal();
            });
        }
    }

    renderMainContent() {
        const content = this.container.querySelector('.dashboard-content');
        
        content.innerHTML = `
            <div class="content-header">
                <h2>Welcome to your Dashboard</h2>
                <div class="action-buttons">
                    <button class="btn btn-primary" id="refreshBtn">Refresh</button>
                    <button class="btn btn-secondary" id="exportBtn">Export</button>
                </div>
            </div>
            
            <div class="widget-grid">
                <div class="widget-row">
                    <div class="widget" id="statsWidget"></div>
                    <div class="widget" id="activityWidget"></div>
                </div>
                <div class="widget-row">
                    <div class="widget large" id="chartWidget"></div>
                </div>
                <div class="widget-row">
                    <div class="widget" id="recentWidget"></div>
                    <div class="widget" id="tasksWidget"></div>
                </div>
            </div>
        `;
        
        this.setupContentEventListeners();
    }

    setupContentEventListeners() {
        const refreshBtn = this.container.querySelector('#refreshBtn');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => {
                this.refreshDashboard();
            });
        }
        
        const exportBtn = this.container.querySelector('#exportBtn');
        if (exportBtn) {
            exportBtn.addEventListener('click', () => {
                this.exportDashboardData();
            });
        }
    }

    renderSidebar() {
        const sidebar = this.container.querySelector('.dashboard-sidebar');
        
        sidebar.innerHTML = `
            <div class="sidebar-section">
                <h3>Quick Actions</h3>
                <ul class="action-list">
                    <li><a href="#" class="action-link" data-action="new-project">New Project</a></li>
                    <li><a href="#" class="action-link" data-action="invite-user">Invite User</a></li>
                    <li><a href="#" class="action-link" data-action="view-reports">View Reports</a></li>
                </ul>
            </div>
            
            <div class="sidebar-section">
                <h3>Recent Activity</h3>
                <div class="activity-feed" id="activityFeed">
                    <div class="loading">Loading...</div>
                </div>
            </div>
            
            <div class="sidebar-section">
                <h3>System Status</h3>
                <div class="status-indicators" id="statusIndicators">
                    <div class="status-item">
                        <span class="status-dot status-green"></span>
                        <span class="status-label">API Server</span>
                    </div>
                    <div class="status-item">
                        <span class="status-dot status-yellow"></span>
                        <span class="status-label">Database</span>
                    </div>
                    <div class="status-item">
                        <span class="status-dot status-green"></span>
                        <span class="status-label">Cache</span>
                    </div>
                </div>
            </div>
        `;
        
        this.setupSidebarEventListeners();
    }

    setupSidebarEventListeners() {
        const actionLinks = this.container.querySelectorAll('.action-link');
        actionLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const action = link.getAttribute('data-action');
                this.handleQuickAction(action);
            });
        });
    }

    renderFooter() {
        const footer = this.container.querySelector('.dashboard-footer');
        
        footer.innerHTML = `
            <div class="footer-content">
                <div class="footer-left">
                    <span class="app-version">v1.2.3</span>
                    <span class="last-update">Last updated: <span id="lastUpdateTime">--</span></span>
                </div>
                <div class="footer-right">
                    <a href="#help" class="footer-link">Help</a>
                    <a href="#privacy" class="footer-link">Privacy</a>
                    <a href="#terms" class="footer-link">Terms</a>
                </div>
            </div>
        `;
        
        this.updateLastUpdateTime();
    }

    // Widget Management
    initializeWidgets() {
        console.log('Initializing dashboard widgets...');
        
        this.initializeStatsWidget();
        this.initializeActivityWidget();
        this.initializeChartWidget();
        this.initializeRecentWidget();
        this.initializeTasksWidget();
        
        console.log('All widgets initialized');
    }

    initializeStatsWidget() {
        const widget = this.container.querySelector('#statsWidget');
        widget.innerHTML = `
            <div class="widget-header">
                <h3>Statistics</h3>
                <button class="widget-menu">⋯</button>
            </div>
            <div class="widget-content">
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value" id="totalUsers">--</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value" id="activeProjects">--</div>
                        <div class="stat-label">Active Projects</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value" id="completedTasks">--</div>
                        <div class="stat-label">Completed Tasks</div>
                    </div>
                </div>
            </div>
        `;
        
        this.loadStatsData();
    }

    async loadStatsData() {
        try {
            const response = await this.apiClient?.get('/dashboard/stats');
            if (response?.data) {
                this.updateStatsDisplay(response.data);
            }
        } catch (error) {
            console.error('Failed to load stats data:', error);
            this.showStatsError();
        }
    }

    updateStatsDisplay(data) {
        const totalUsers = this.container.querySelector('#totalUsers');
        const activeProjects = this.container.querySelector('#activeProjects');
        const completedTasks = this.container.querySelector('#completedTasks');
        
        if (totalUsers) totalUsers.textContent = data.totalUsers || '0';
        if (activeProjects) activeProjects.textContent = data.activeProjects || '0';
        if (completedTasks) completedTasks.textContent = data.completedTasks || '0';
    }

    showStatsError() {
        const statsGrid = this.container.querySelector('.stats-grid');
        if (statsGrid) {
            statsGrid.innerHTML = '<div class="error-message">Failed to load statistics</div>';
        }
    }

    // Event Handlers
    handleUserAuthenticated(user) {
        console.log('User authenticated, updating dashboard...', user);
        this.renderHeader();
        this.refreshDashboard();
    }

    handleUserUpdated(user) {
        console.log('User updated, refreshing user info...', user);
        this.renderHeader();
    }

    handleUserLogout() {
        console.log('User logged out, cleaning up dashboard...');
        this.cleanup();
    }

    handleNavigation(section) {
        console.log(`Navigating to: ${section}`);
        
        // Update active nav link
        const navLinks = this.container.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${section}`) {
                link.classList.add('active');
            }
        });
        
        // Load section content
        this.loadSection(section);
    }

    async loadSection(section) {
        const content = this.container.querySelector('.dashboard-content');
        content.innerHTML = '<div class="loading">Loading...</div>';
        
        try {
            // Simulate loading different sections
            await new Promise(resolve => setTimeout(resolve, 500));
            
            switch (section) {
                case 'dashboard':
                    this.renderMainContent();
                    this.initializeWidgets();
                    break;
                case 'projects':
                    content.innerHTML = '<h2>Projects</h2><p>Projects content goes here...</p>';
                    break;
                case 'users':
                    content.innerHTML = '<h2>Users</h2><p>Users management content goes here...</p>';
                    break;
                case 'settings':
                    content.innerHTML = '<h2>Settings</h2><p>Settings content goes here...</p>';
                    break;
                default:
                    content.innerHTML = '<h2>Page Not Found</h2>';
            }
        } catch (error) {
            console.error(`Failed to load section ${section}:`, error);
            content.innerHTML = '<div class="error-message">Failed to load content</div>';
        }
    }

    // Data Management
    async syncData() {
        console.log('Syncing dashboard data...');
        
        try {
            await Promise.all([
                this.loadStatsData(),
                this.loadActivityData(),
                this.updateSystemStatus()
            ]);
            
            this.updateLastUpdateTime();
            console.log('Dashboard data sync completed');
        } catch (error) {
            console.error('Dashboard data sync failed:', error);
        }
    }

    async refreshDashboard() {
        console.log('Refreshing dashboard...');
        
        // Show loading state
        const refreshBtn = this.container.querySelector('#refreshBtn');
        if (refreshBtn) {
            refreshBtn.textContent = 'Refreshing...';
            refreshBtn.disabled = true;
        }
        
        try {
            await this.syncData();
        } finally {
            // Reset button state
            if (refreshBtn) {
                refreshBtn.textContent = 'Refresh';
                refreshBtn.disabled = false;
            }
        }
    }

    startPeriodicUpdates() {
        // Update every 5 minutes
        this.refreshInterval = setInterval(() => {
            this.syncData();
        }, 5 * 60 * 1000);
    }

    updateLastUpdateTime() {
        const lastUpdateTime = this.container.querySelector('#lastUpdateTime');
        if (lastUpdateTime) {
            lastUpdateTime.textContent = new Date().toLocaleTimeString();
        }
    }

    // Cleanup
    cleanup() {
        console.log('Cleaning up dashboard...');
        
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
            this.refreshInterval = null;
        }
        
        // Remove event listeners
        this.eventListeners.clear();
        
        // Remove from DOM
        if (this.container && this.container.parentNode) {
            this.container.parentNode.removeChild(this.container);
        }
        
        console.log('Dashboard cleanup completed');
    }

    savePendingChanges() {
        console.log('Saving pending dashboard changes...');
        // Implement any pending changes save logic
    }
}