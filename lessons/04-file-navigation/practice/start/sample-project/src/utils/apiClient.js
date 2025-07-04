// API Client Utility
// ==================

export class ApiClient {
    constructor(baseUrl, options = {}) {
        this.baseUrl = baseUrl.replace(/\/$/, ''); // Remove trailing slash
        this.timeout = options.timeout || 10000;
        this.retryAttempts = options.retryAttempts || 3;
        this.retryDelay = options.retryDelay || 1000;
        this.defaultHeaders = {
            'Content-Type': 'application/json',
            ...options.headers
        };
        this.interceptors = {
            request: [],
            response: []
        };
    }

    // Core HTTP Methods
    async get(endpoint, options = {}) {
        return this.request('GET', endpoint, null, options);
    }

    async post(endpoint, data, options = {}) {
        return this.request('POST', endpoint, data, options);
    }

    async put(endpoint, data, options = {}) {
        return this.request('PUT', endpoint, data, options);
    }

    async patch(endpoint, data, options = {}) {
        return this.request('PATCH', endpoint, data, options);
    }

    async delete(endpoint, options = {}) {
        return this.request('DELETE', endpoint, null, options);
    }

    // Main Request Method
    async request(method, endpoint, data = null, options = {}) {
        const url = this.buildUrl(endpoint);
        const config = this.buildRequestConfig(method, data, options);
        
        let lastError;
        for (let attempt = 1; attempt <= this.retryAttempts; attempt++) {
            try {
                console.log(`[API] ${method} ${url} (attempt ${attempt})`);
                
                // Apply request interceptors
                const interceptedConfig = await this.applyRequestInterceptors(config);
                
                // Make the actual request
                const response = await this.makeRequest(url, interceptedConfig);
                
                // Apply response interceptors
                const interceptedResponse = await this.applyResponseInterceptors(response);
                
                console.log(`[API] ${method} ${url} - Success`);
                return interceptedResponse;
                
            } catch (error) {
                lastError = error;
                console.warn(`[API] ${method} ${url} - Attempt ${attempt} failed:`, error.message);
                
                // Don't retry on client errors (4xx)
                if (error.status && error.status >= 400 && error.status < 500) {
                    break;
                }
                
                // Wait before retry (except on last attempt)
                if (attempt < this.retryAttempts) {
                    await this.delay(this.retryDelay * attempt);
                }
            }
        }
        
        console.error(`[API] ${method} ${url} - All attempts failed`);
        throw lastError;
    }

    buildUrl(endpoint) {
        // Handle absolute URLs
        if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
            return endpoint;
        }
        
        // Build relative URL
        const cleanEndpoint = endpoint.startsWith('/') ? endpoint.slice(1) : endpoint;
        return `${this.baseUrl}/${cleanEndpoint}`;
    }

    buildRequestConfig(method, data, options) {
        const config = {
            method,
            headers: {
                ...this.defaultHeaders,
                ...options.headers
            },
            signal: options.signal || this.createTimeoutSignal()
        };

        // Add body for methods that support it
        if (data && ['POST', 'PUT', 'PATCH'].includes(method)) {
            if (data instanceof FormData) {
                // Let browser set Content-Type for FormData
                delete config.headers['Content-Type'];
                config.body = data;
            } else if (typeof data === 'object') {
                config.body = JSON.stringify(data);
            } else {
                config.body = data;
            }
        }

        // Handle query parameters
        if (options.params) {
            const url = new URL(config.url || '');
            Object.entries(options.params).forEach(([key, value]) => {
                if (value !== undefined && value !== null) {
                    url.searchParams.append(key, value);
                }
            });
            config.url = url.toString();
        }

        return config;
    }

    async makeRequest(url, config) {
        const response = await fetch(url, config);
        
        // Create response object with additional metadata
        const result = {
            data: null,
            status: response.status,
            statusText: response.statusText,
            headers: this.parseHeaders(response.headers),
            url: response.url
        };

        // Parse response body
        const contentType = response.headers.get('content-type') || '';
        
        if (contentType.includes('application/json')) {
            try {
                result.data = await response.json();
            } catch (error) {
                throw new Error('Invalid JSON response');
            }
        } else if (contentType.includes('text/')) {
            result.data = await response.text();
        } else {
            result.data = await response.blob();
        }

        // Handle HTTP error status
        if (!response.ok) {
            const error = new Error(`HTTP ${response.status}: ${response.statusText}`);
            error.status = response.status;
            error.response = result;
            throw error;
        }

        return result;
    }

    parseHeaders(headers) {
        const parsed = {};
        for (const [key, value] of headers.entries()) {
            parsed[key] = value;
        }
        return parsed;
    }

    createTimeoutSignal() {
        if (typeof AbortController !== 'undefined') {
            const controller = new AbortController();
            setTimeout(() => controller.abort(), this.timeout);
            return controller.signal;
        }
        return undefined;
    }

    // Interceptors
    addRequestInterceptor(interceptor) {
        this.interceptors.request.push(interceptor);
    }

    addResponseInterceptor(interceptor) {
        this.interceptors.response.push(interceptor);
    }

    async applyRequestInterceptors(config) {
        let modifiedConfig = config;
        
        for (const interceptor of this.interceptors.request) {
            try {
                modifiedConfig = await interceptor(modifiedConfig);
            } catch (error) {
                console.error('Request interceptor error:', error);
            }
        }
        
        return modifiedConfig;
    }

    async applyResponseInterceptors(response) {
        let modifiedResponse = response;
        
        for (const interceptor of this.interceptors.response) {
            try {
                modifiedResponse = await interceptor(modifiedResponse);
            } catch (error) {
                console.error('Response interceptor error:', error);
            }
        }
        
        return modifiedResponse;
    }

    // Authentication Methods
    setAuthToken(token) {
        if (token) {
            this.defaultHeaders['Authorization'] = `Bearer ${token}`;
        } else {
            delete this.defaultHeaders['Authorization'];
        }
    }

    async validateSession(token) {
        try {
            const response = await this.get('/auth/validate', {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            return response.data;
        } catch (error) {
            console.error('Session validation failed:', error);
            return { valid: false, error: error.message };
        }
    }

    // Specialized API Methods
    async uploadFile(endpoint, file, options = {}) {
        const formData = new FormData();
        formData.append('file', file);
        
        // Add additional fields
        if (options.fields) {
            Object.entries(options.fields).forEach(([key, value]) => {
                formData.append(key, value);
            });
        }

        return this.post(endpoint, formData, {
            headers: {
                // Remove Content-Type to let browser set it with boundary
                ...options.headers
            }
        });
    }

    async downloadFile(endpoint, options = {}) {
        const response = await this.get(endpoint, {
            ...options,
            headers: {
                'Accept': 'application/octet-stream',
                ...options.headers
            }
        });

        return response.data; // Blob
    }

    // Utility Methods
    async delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    // Health Check
    async healthCheck() {
        try {
            const response = await this.get('/health');
            return {
                healthy: true,
                response: response.data
            };
        } catch (error) {
            return {
                healthy: false,
                error: error.message
            };
        }
    }

    // Configuration
    updateConfig(config) {
        if (config.baseUrl) {
            this.baseUrl = config.baseUrl.replace(/\/$/, '');
        }
        if (config.timeout) {
            this.timeout = config.timeout;
        }
        if (config.retryAttempts) {
            this.retryAttempts = config.retryAttempts;
        }
        if (config.headers) {
            this.defaultHeaders = {
                ...this.defaultHeaders,
                ...config.headers
            };
        }
    }

    getConfig() {
        return {
            baseUrl: this.baseUrl,
            timeout: this.timeout,
            retryAttempts: this.retryAttempts,
            headers: { ...this.defaultHeaders }
        };
    }
}