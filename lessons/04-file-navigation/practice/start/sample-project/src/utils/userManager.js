// User Management Utility
// =======================

export class UserManager {
    constructor() {
        this.users = new Map();
        this.currentUser = null;
        this.userCache = new Map();
        this.eventListeners = new Map();
    }

    // User Authentication
    async authenticateUser(credentials) {
        console.log('Authenticating user...');
        
        try {
            const { username, password } = credentials;
            
            // Validate credentials format
            if (!this.validateCredentials(credentials)) {
                throw new Error('Invalid credentials format');
            }
            
            // Simulate API call
            const authResponse = await this.callAuthAPI(username, password);
            
            if (authResponse.success) {
                this.currentUser = authResponse.user;
                this.cacheUser(authResponse.user);
                this.notifyListeners('user-authenticated', authResponse.user);
                
                return {
                    success: true,
                    user: authResponse.user,
                    token: authResponse.token
                };
            }
            
            return {
                success: false,
                error: authResponse.error || 'Authentication failed'
            };
            
        } catch (error) {
            console.error('Authentication error:', error);
            return {
                success: false,
                error: error.message
            };
        }
    }

    validateCredentials(credentials) {
        if (!credentials) return false;
        if (!credentials.username || credentials.username.length < 3) return false;
        if (!credentials.password || credentials.password.length < 6) return false;
        
        // Email format validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (credentials.username.includes('@') && !emailRegex.test(credentials.username)) {
            return false;
        }
        
        return true;
    }

    async callAuthAPI(username, password) {
        // Simulate API delay
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock authentication logic
        const mockUsers = [
            { id: 1, username: 'admin', email: 'admin@example.com', role: 'admin' },
            { id: 2, username: 'user1', email: 'user1@example.com', role: 'user' },
            { id: 3, username: 'developer', email: 'dev@example.com', role: 'developer' }
        ];
        
        const user = mockUsers.find(u => u.username === username);
        
        if (user && password === 'password123') {
            return {
                success: true,
                user: {
                    ...user,
                    lastLogin: new Date(),
                    permissions: this.getUserPermissions(user.role)
                },
                token: `token_${user.id}_${Date.now()}`
            };
        }
        
        return {
            success: false,
            error: 'Invalid username or password'
        };
    }

    getUserPermissions(role) {
        const permissions = {
            admin: ['read', 'write', 'delete', 'admin'],
            developer: ['read', 'write', 'debug'],
            user: ['read']
        };
        
        return permissions[role] || permissions.user;
    }

    // User Profile Management
    async updateUserProfile(userId, profileData) {
        console.log(`Updating profile for user ${userId}...`);
        
        try {
            const user = await this.getUserById(userId);
            if (!user) {
                throw new Error('User not found');
            }
            
            // Validate profile data
            const validatedData = this.validateProfileData(profileData);
            
            // Update user data
            const updatedUser = {
                ...user,
                ...validatedData,
                updatedAt: new Date()
            };
            
            // Save to cache
            this.cacheUser(updatedUser);
            
            // Notify listeners
            this.notifyListeners('user-updated', updatedUser);
            
            return {
                success: true,
                user: updatedUser
            };
            
        } catch (error) {
            console.error('Profile update error:', error);
            return {
                success: false,
                error: error.message
            };
        }
    }

    validateProfileData(data) {
        const validatedData = {};
        
        // Validate and sanitize each field
        if (data.firstName) {
            validatedData.firstName = data.firstName.trim();
        }
        
        if (data.lastName) {
            validatedData.lastName = data.lastName.trim();
        }
        
        if (data.email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailRegex.test(data.email)) {
                validatedData.email = data.email.toLowerCase();
            } else {
                throw new Error('Invalid email format');
            }
        }
        
        if (data.phone) {
            const phoneRegex = /^\+?[\d\s-()]+$/;
            if (phoneRegex.test(data.phone)) {
                validatedData.phone = data.phone.replace(/\s/g, '');
            } else {
                throw new Error('Invalid phone format');
            }
        }
        
        return validatedData;
    }

    // User Data Management
    async getUserById(userId) {
        // Check cache first
        if (this.userCache.has(userId)) {
            return this.userCache.get(userId);
        }
        
        // Simulate API call
        try {
            const userData = await this.fetchUserFromAPI(userId);
            if (userData) {
                this.cacheUser(userData);
                return userData;
            }
            return null;
        } catch (error) {
            console.error(`Failed to fetch user ${userId}:`, error);
            return null;
        }
    }

    async fetchUserFromAPI(userId) {
        // Simulate API delay
        await new Promise(resolve => setTimeout(resolve, 500));
        
        // Mock user data
        const mockUsers = {
            1: { id: 1, username: 'admin', email: 'admin@example.com', role: 'admin', firstName: 'Admin', lastName: 'User' },
            2: { id: 2, username: 'user1', email: 'user1@example.com', role: 'user', firstName: 'John', lastName: 'Doe' },
            3: { id: 3, username: 'developer', email: 'dev@example.com', role: 'developer', firstName: 'Jane', lastName: 'Smith' }
        };
        
        return mockUsers[userId] || null;
    }

    cacheUser(user) {
        if (user && user.id) {
            this.userCache.set(user.id, {
                ...user,
                cachedAt: new Date()
            });
            
            // Limit cache size
            if (this.userCache.size > 100) {
                const firstKey = this.userCache.keys().next().value;
                this.userCache.delete(firstKey);
            }
        }
    }

    // Session Management
    async syncUserData() {
        if (!this.currentUser) return;
        
        try {
            console.log('Syncing user data...');
            
            // Fetch latest user data
            const latestUserData = await this.fetchUserFromAPI(this.currentUser.id);
            
            if (latestUserData) {
                this.currentUser = latestUserData;
                this.cacheUser(latestUserData);
                this.notifyListeners('user-synced', latestUserData);
            }
            
        } catch (error) {
            console.error('User data sync failed:', error);
        }
    }

    logout() {
        console.log('Logging out user...');
        
        if (this.currentUser) {
            this.notifyListeners('user-logout', this.currentUser);
            this.currentUser = null;
        }
        
        // Clear sensitive data from cache
        this.userCache.clear();
    }

    // Event Management
    addEventListener(event, callback) {
        if (!this.eventListeners.has(event)) {
            this.eventListeners.set(event, new Set());
        }
        this.eventListeners.get(event).add(callback);
    }

    removeEventListener(event, callback) {
        if (this.eventListeners.has(event)) {
            this.eventListeners.get(event).delete(callback);
        }
    }

    notifyListeners(event, data) {
        if (this.eventListeners.has(event)) {
            this.eventListeners.get(event).forEach(callback => {
                try {
                    callback(data);
                } catch (error) {
                    console.error(`Event listener error for ${event}:`, error);
                }
            });
        }
    }

    // Utility Methods
    getCurrentUser() {
        return this.currentUser;
    }

    isAuthenticated() {
        return this.currentUser !== null;
    }

    hasPermission(permission) {
        if (!this.currentUser || !this.currentUser.permissions) {
            return false;
        }
        return this.currentUser.permissions.includes(permission);
    }

    clearCache() {
        console.log('Clearing user cache...');
        this.userCache.clear();
    }
}