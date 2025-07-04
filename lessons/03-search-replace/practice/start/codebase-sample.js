// Sample Codebase for Advanced Search Practice
// ============================================

// User Management Module
class UserManager {
    constructor() {
        this.users = [];
        this.activeUsers = new Map();
    }

    // TODO: Implement user validation
    addUser(userData) {
        if (!this.validateUser(userData)) {
            throw new Error("Invalid user data");
        }
        
        const user = {
            id: this.generateId(),
            name: userData.name,
            email: userData.email,
            createdAt: new Date(),
            isActive: true
        };
        
        this.users.push(user);
        this.activeUsers.set(user.id, user);
        
        console.log(`User ${user.name} added successfully`);
        return user;
    }

    // FIXME: This method has performance issues
    findUser(searchTerm) {
        return this.users.find(user => 
            user.name.includes(searchTerm) || 
            user.email.includes(searchTerm)
        );
    }

    updateUser(userId, updateData) {
        const user = this.findUserById(userId);
        if (!user) {
            console.error(`User with ID ${userId} not found`);
            return null;
        }

        // TODO: Add validation for update data
        Object.assign(user, updateData);
        this.activeUsers.set(userId, user);
        
        console.log(`User ${userId} updated`);
        return user;
    }

    deleteUser(userId) {
        const index = this.users.findIndex(user => user.id === userId);
        if (index === -1) {
            console.error(`Cannot delete: User ${userId} not found`);
            return false;
        }

        this.users.splice(index, 1);
        this.activeUsers.delete(userId);
        
        console.log(`User ${userId} deleted`);
        return true;
    }

    // Helper methods
    validateUser(userData) {
        return userData && 
               userData.name && 
               userData.email && 
               this.isValidEmail(userData.email);
    }

    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    findUserById(userId) {
        return this.users.find(user => user.id === userId);
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }
}

// Data Processing Functions
function processUserData(rawData) {
    console.log("Processing user data...");
    
    if (!rawData || !Array.isArray(rawData)) {
        console.error("Invalid data format");
        return [];
    }

    return rawData.map(item => {
        // TODO: Add more data validation
        return {
            id: item.id || generateId(),
            name: item.name ? item.name.trim() : "Unknown",
            email: item.email ? item.email.toLowerCase() : "",
            age: parseInt(item.age) || 0,
            department: item.department || "General"
        };
    });
}

function calculateUserStats(users) {
    console.log("Calculating user statistics...");
    
    const stats = {
        totalUsers: users.length,
        averageAge: 0,
        departmentCounts: {},
        activeUsers: 0
    };

    let totalAge = 0;
    
    users.forEach(user => {
        // Calculate average age
        totalAge += user.age;
        
        // Count by department
        if (stats.departmentCounts[user.department]) {
            stats.departmentCounts[user.department]++;
        } else {
            stats.departmentCounts[user.department] = 1;
        }
        
        // Count active users
        if (user.isActive) {
            stats.activeUsers++;
        }
    });

    stats.averageAge = users.length > 0 ? totalAge / users.length : 0;
    
    console.log("Statistics calculated:", stats);
    return stats;
}

// API Integration
async function fetchUserData(endpoint) {
    try {
        console.log(`Fetching data from ${endpoint}...`);
        
        const response = await fetch(endpoint);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        console.log("Data fetched successfully");
        
        return data;
    } catch (error) {
        console.error("Failed to fetch user data:", error);
        throw error;
    }
}

async function saveUserData(userData, endpoint) {
    try {
        console.log(`Saving data to ${endpoint}...`);
        
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(userData)
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        console.log("Data saved successfully");
        return await response.json();
    } catch (error) {
        console.error("Failed to save user data:", error);
        throw error;
    }
}

// Event Handlers
function handleUserCreation(formData) {
    console.log("Handling user creation...");
    
    try {
        const userManager = new UserManager();
        const newUser = userManager.addUser(formData);
        
        // TODO: Add success notification
        displaySuccessMessage(`User ${newUser.name} created successfully`);
        
        return newUser;
    } catch (error) {
        console.error("User creation failed:", error);
        displayErrorMessage("Failed to create user");
        throw error;
    }
}

function handleUserUpdate(userId, updateData) {
    console.log(`Handling user update for ID: ${userId}`);
    
    try {
        const userManager = new UserManager();
        const updatedUser = userManager.updateUser(userId, updateData);
        
        if (updatedUser) {
            displaySuccessMessage("User updated successfully");
        }
        
        return updatedUser;
    } catch (error) {
        console.error("User update failed:", error);
        displayErrorMessage("Failed to update user");
        throw error;
    }
}

// Utility Functions
function displaySuccessMessage(message) {
    console.log(`SUCCESS: ${message}`);
    // TODO: Show UI notification
}

function displayErrorMessage(message) {
    console.error(`ERROR: ${message}`);
    // TODO: Show error notification
}

function generateId() {
    return `user_${Date.now()}_${Math.random().toString(36).substr(2, 5)}`;
}

// Configuration
const config = {
    apiBaseUrl: "https://api.example.com/v1",
    timeout: 5000,
    retryAttempts: 3,
    debugMode: true
};

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        UserManager,
        processUserData,
        calculateUserStats,
        fetchUserData,
        saveUserData
    };
}