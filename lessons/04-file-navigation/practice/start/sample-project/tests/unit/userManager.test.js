// User Manager Unit Tests
// ======================

import { UserManager } from '../../src/utils/userManager.js';

describe('UserManager', () => {
    let userManager;

    beforeEach(() => {
        userManager = new UserManager();
        // Clear localStorage for clean tests
        localStorage.clear();
    });

    afterEach(() => {
        userManager.clearCache();
    });

    describe('Authentication', () => {
        test('should authenticate valid user credentials', async () => {
            const credentials = {
                username: 'admin',
                password: 'password123'
            };

            const result = await userManager.authenticateUser(credentials);

            expect(result.success).toBe(true);
            expect(result.user).toBeDefined();
            expect(result.user.username).toBe('admin');
            expect(result.token).toBeDefined();
        });

        test('should reject invalid credentials', async () => {
            const credentials = {
                username: 'admin',
                password: 'wrongpassword'
            };

            const result = await userManager.authenticateUser(credentials);

            expect(result.success).toBe(false);
            expect(result.error).toBeDefined();
        });

        test('should validate credentials format', () => {
            // Valid credentials
            expect(userManager.validateCredentials({
                username: 'user@example.com',
                password: 'password123'
            })).toBe(true);

            // Invalid username (too short)
            expect(userManager.validateCredentials({
                username: 'us',
                password: 'password123'
            })).toBe(false);

            // Invalid password (too short)
            expect(userManager.validateCredentials({
                username: 'user',
                password: '123'
            })).toBe(false);

            // Invalid email format
            expect(userManager.validateCredentials({
                username: 'invalid-email',
                password: 'password123'
            })).toBe(false);
        });

        test('should handle authentication API errors', async () => {
            // Mock API to throw error
            const originalCallAuthAPI = userManager.callAuthAPI;
            userManager.callAuthAPI = jest.fn().mockRejectedValue(new Error('Network error'));

            const credentials = {
                username: 'admin',
                password: 'password123'
            };

            const result = await userManager.authenticateUser(credentials);

            expect(result.success).toBe(false);
            expect(result.error).toBe('Network error');

            // Restore original method
            userManager.callAuthAPI = originalCallAuthAPI;
        });
    });

    describe('User Profile Management', () => {
        beforeEach(async () => {
            // Authenticate a user first
            await userManager.authenticateUser({
                username: 'admin',
                password: 'password123'
            });
        });

        test('should update user profile with valid data', async () => {
            const profileData = {
                firstName: 'John',
                lastName: 'Doe',
                email: 'john.doe@example.com',
                phone: '+1-555-123-4567'
            };

            const result = await userManager.updateUserProfile(1, profileData);

            expect(result.success).toBe(true);
            expect(result.user.firstName).toBe('John');
            expect(result.user.lastName).toBe('Doe');
            expect(result.user.email).toBe('john.doe@example.com');
        });

        test('should reject invalid email format', async () => {
            const profileData = {
                email: 'invalid-email-format'
            };

            const result = await userManager.updateUserProfile(1, profileData);

            expect(result.success).toBe(false);
            expect(result.error).toBe('Invalid email format');
        });

        test('should reject invalid phone format', async () => {
            const profileData = {
                phone: 'invalid-phone'
            };

            const result = await userManager.updateUserProfile(1, profileData);

            expect(result.success).toBe(false);
            expect(result.error).toBe('Invalid phone format');
        });

        test('should sanitize input data', async () => {
            const profileData = {
                firstName: '  John  ',
                lastName: '  Doe  ',
                email: 'JOHN.DOE@EXAMPLE.COM'
            };

            const result = await userManager.updateUserProfile(1, profileData);

            expect(result.success).toBe(true);
            expect(result.user.firstName).toBe('John');
            expect(result.user.lastName).toBe('Doe');
            expect(result.user.email).toBe('john.doe@example.com');
        });
    });

    describe('User Data Management', () => {
        test('should fetch user by ID', async () => {
            const user = await userManager.getUserById(1);

            expect(user).toBeDefined();
            expect(user.id).toBe(1);
            expect(user.username).toBe('admin');
        });

        test('should return null for non-existent user', async () => {
            const user = await userManager.getUserById(999);

            expect(user).toBeNull();
        });

        test('should cache user data', async () => {
            // First call
            const user1 = await userManager.getUserById(1);
            expect(user1).toBeDefined();

            // Mock the API to ensure cache is used
            const originalFetchUser = userManager.fetchUserFromAPI;
            userManager.fetchUserFromAPI = jest.fn();

            // Second call should use cache
            const user2 = await userManager.getUserById(1);
            expect(user2).toEqual(user1);
            expect(userManager.fetchUserFromAPI).not.toHaveBeenCalled();

            // Restore original method
            userManager.fetchUserFromAPI = originalFetchUser;
        });

        test('should limit cache size', async () => {
            // Fill cache beyond limit
            for (let i = 1; i <= 105; i++) {
                userManager.cacheUser({ id: i, username: `user${i}` });
            }

            // Cache should be limited to 100 items
            expect(userManager.userCache.size).toBeLessThanOrEqual(100);
        });
    });

    describe('Session Management', () => {
        test('should sync user data', async () => {
            // Set current user
            userManager.currentUser = { id: 1, username: 'admin' };

            // Mock API response
            const mockUpdatedUser = { id: 1, username: 'admin', lastLogin: new Date() };
            userManager.fetchUserFromAPI = jest.fn().mockResolvedValue(mockUpdatedUser);

            await userManager.syncUserData();

            expect(userManager.currentUser).toEqual(mockUpdatedUser);
            expect(userManager.fetchUserFromAPI).toHaveBeenCalledWith(1);
        });

        test('should handle logout', () => {
            userManager.currentUser = { id: 1, username: 'admin' };
            const logoutSpy = jest.fn();
            userManager.addEventListener('user-logout', logoutSpy);

            userManager.logout();

            expect(userManager.currentUser).toBeNull();
            expect(userManager.userCache.size).toBe(0);
            expect(logoutSpy).toHaveBeenCalled();
        });
    });

    describe('Event Management', () => {
        test('should add and trigger event listeners', () => {
            const callback = jest.fn();
            userManager.addEventListener('test-event', callback);

            userManager.notifyListeners('test-event', { data: 'test' });

            expect(callback).toHaveBeenCalledWith({ data: 'test' });
        });

        test('should remove event listeners', () => {
            const callback = jest.fn();
            userManager.addEventListener('test-event', callback);
            userManager.removeEventListener('test-event', callback);

            userManager.notifyListeners('test-event', { data: 'test' });

            expect(callback).not.toHaveBeenCalled();
        });

        test('should handle listener errors gracefully', () => {
            const errorCallback = jest.fn().mockImplementation(() => {
                throw new Error('Listener error');
            });
            const normalCallback = jest.fn();

            userManager.addEventListener('test-event', errorCallback);
            userManager.addEventListener('test-event', normalCallback);

            // Should not throw despite error in first listener
            expect(() => {
                userManager.notifyListeners('test-event', { data: 'test' });
            }).not.toThrow();

            expect(errorCallback).toHaveBeenCalled();
            expect(normalCallback).toHaveBeenCalled();
        });
    });

    describe('Utility Methods', () => {
        test('should return current user', () => {
            expect(userManager.getCurrentUser()).toBeNull();

            userManager.currentUser = { id: 1, username: 'admin' };
            expect(userManager.getCurrentUser()).toEqual({ id: 1, username: 'admin' });
        });

        test('should check authentication status', () => {
            expect(userManager.isAuthenticated()).toBe(false);

            userManager.currentUser = { id: 1, username: 'admin' };
            expect(userManager.isAuthenticated()).toBe(true);
        });

        test('should check user permissions', () => {
            // No user
            expect(userManager.hasPermission('read')).toBe(false);

            // User with permissions
            userManager.currentUser = {
                id: 1,
                username: 'admin',
                permissions: ['read', 'write', 'admin']
            };

            expect(userManager.hasPermission('read')).toBe(true);
            expect(userManager.hasPermission('admin')).toBe(true);
            expect(userManager.hasPermission('delete')).toBe(false);
        });

        test('should get user permissions by role', () => {
            expect(userManager.getUserPermissions('admin')).toEqual(['read', 'write', 'delete', 'admin']);
            expect(userManager.getUserPermissions('user')).toEqual(['read']);
            expect(userManager.getUserPermissions('invalid')).toEqual(['read']);
        });
    });
});