// Main Application Entry Point
// ==========================

import { UserManager } from './utils/userManager.js';
import { ApiClient } from './utils/apiClient.js';
import { Dashboard } from './components/Dashboard.js';
import { UserProfile } from './components/UserProfile.js';
import { useAuth } from './hooks/useAuth.js';
import config from '../config/app.json';

class Application {
    constructor() {
        this.userManager = new UserManager();
        this.apiClient = new ApiClient(config.apiBaseUrl);
        this.currentUser = null;
        this.dashboard = null;
    }

    async initialize() {
        console.log('Initializing application...');
        
        try {
            // Load configuration
            await this.loadConfiguration();
            
            // Initialize authentication
            const authResult = await this.initializeAuth();
            if (!authResult.success) {
                throw new Error('Authentication failed');
            }
            
            // Setup main components
            this.setupComponents();
            
            // Start the application
            this.start();
            
            console.log('Application initialized successfully');
        } catch (error) {
            console.error('Failed to initialize application:', error);
            this.handleInitializationError(error);
        }
    }

    async loadConfiguration() {
        console.log('Loading configuration...');
        // Configuration loading logic
    }

    async initializeAuth() {
        console.log('Setting up authentication...');
        
        // Check for existing session
        const existingSession = localStorage.getItem('userSession');
        if (existingSession) {
            const sessionData = JSON.parse(existingSession);
            return await this.validateSession(sessionData);
        }
        
        // Redirect to login if no session
        return { success: false, reason: 'No existing session' };
    }

    setupComponents() {
        console.log('Setting up components...');
        
        // Initialize dashboard
        this.dashboard = new Dashboard({
            userManager: this.userManager,
            apiClient: this.apiClient
        });
        
        // Setup event listeners
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Global event listeners
        window.addEventListener('beforeunload', () => {
            this.cleanup();
        });
        
        // User interaction events
        document.addEventListener('user-logout', () => {
            this.handleLogout();
        });
    }

    start() {
        console.log('Starting application...');
        
        // Render main interface
        this.dashboard.render();
        
        // Start periodic tasks
        this.startPeriodicTasks();
    }

    startPeriodicTasks() {
        // Periodic session validation
        setInterval(() => {
            this.validateCurrentSession();
        }, config.sessionCheckInterval || 300000); // 5 minutes
        
        // Periodic data sync
        setInterval(() => {
            this.syncData();
        }, config.dataSyncInterval || 600000); // 10 minutes
    }

    async validateSession(sessionData) {
        try {
            const response = await this.apiClient.validateSession(sessionData.token);
            if (response.valid) {
                this.currentUser = response.user;
                return { success: true, user: response.user };
            }
            return { success: false, reason: 'Invalid session' };
        } catch (error) {
            console.error('Session validation failed:', error);
            return { success: false, reason: 'Validation error' };
        }
    }

    async validateCurrentSession() {
        if (!this.currentUser) return;
        
        const result = await this.validateSession({ token: this.currentUser.token });
        if (!result.success) {
            this.handleLogout();
        }
    }

    async syncData() {
        try {
            console.log('Syncing data...');
            
            // Sync user data
            await this.userManager.syncUserData();
            
            // Sync application state
            await this.dashboard.syncData();
            
            console.log('Data sync completed');
        } catch (error) {
            console.error('Data sync failed:', error);
        }
    }

    handleLogout() {
        console.log('Handling user logout...');
        
        // Clear user data
        this.currentUser = null;
        localStorage.removeItem('userSession');
        
        // Cleanup components
        if (this.dashboard) {
            this.dashboard.cleanup();
        }
        
        // Redirect to login
        window.location.href = '/login';
    }

    handleInitializationError(error) {
        console.error('Application initialization failed:', error);
        
        // Show error message to user
        const errorDiv = document.createElement('div');
        errorDiv.className = 'init-error';
        errorDiv.innerHTML = `
            <h2>Application Error</h2>
            <p>Failed to initialize the application. Please refresh the page or contact support.</p>
            <details>
                <summary>Error Details</summary>
                <pre>${error.message}</pre>
            </details>
        `;
        document.body.appendChild(errorDiv);
    }

    cleanup() {
        console.log('Cleaning up application...');
        
        // Save pending data
        if (this.dashboard) {
            this.dashboard.savePendingChanges();
        }
        
        // Clear intervals
        // Note: In real app, you'd store interval IDs and clear them
    }
}

// Initialize application when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const app = new Application();
    app.initialize();
});

export default Application;