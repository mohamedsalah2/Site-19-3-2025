// Site-wide Utilities
const SiteUtils = {
    // Toast Notifications
    showToast: function(message, type = 'info', duration = 5000) {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type} fade-in`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
            <div class="toast-content">
                <i class="toast-icon fas ${this.getToastIcon(type)}"></i>
                <span class="toast-message">${message}</span>
            </div>
            <button type="button" class="toast-close" onclick="this.parentElement.remove()">×</button>
        `;

        const container = document.getElementById('toastContainer');
        container.appendChild(toast);

        setTimeout(() => {
            toast.classList.add('fade-out');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    },

    getToastIcon: function(type) {
        const icons = {
            'success': 'fa-check-circle',
            'error': 'fa-exclamation-circle',
            'warning': 'fa-exclamation-triangle',
            'info': 'fa-info-circle'
        };
        return icons[type] || icons.info;
    },

    // Loading Overlay
    showLoading: function(show = true) {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.style.display = show ? 'flex' : 'none';
        }
    },

    // Form Validation
    validateForm: function(formId, config = {}) {
        const form = document.getElementById(formId);
        if (!form) return true;

        let isValid = true;
        let firstInvalidField = null;

        // Remove existing error messages
        form.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));
        form.querySelectorAll('.error-message').forEach(el => el.remove());

        // Validate required fields
        const requiredFields = form.querySelectorAll('[required]');
        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                isValid = false;
                if (!firstInvalidField) firstInvalidField = field;
                
                field.classList.add('field-error');
                
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.textContent = field.getAttribute('data-error') || 'هذا الحقل مطلوب';
                field.parentNode.appendChild(errorDiv);
            }
        });

        // Custom validation rules
        if (config.customValidation) {
            const customResult = config.customValidation();
            if (customResult !== true) {
                isValid = false;
                this.showToast(customResult, 'error');
            }
        }

        if (!isValid && firstInvalidField) {
            firstInvalidField.focus();
            this.showToast('يرجى ملء جميع الحقول المطلوبة', 'warning');
        }

        return isValid;
    },

    // File Upload Handling
    initFileUpload: function(inputId, options = {}) {
        const input = document.getElementById(inputId);
        if (!input) return;

        const container = input.parentElement;
        const defaultOptions = {
            maxSize: 10 * 1024 * 1024, // 10MB
            allowedTypes: ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.txt', '.jpg', '.jpeg', '.png'],
            onValidationError: (message) => this.showToast(message, 'error')
        };

        const config = { ...defaultOptions, ...options };

        // Add drag and drop support
        container.addEventListener('dragover', (e) => {
            e.preventDefault();
            e.stopPropagation();
            container.classList.add('highlight');
        });

        container.addEventListener('dragleave', (e) => {
            e.preventDefault();
            e.stopPropagation();
            container.classList.remove('highlight');
        });

        container.addEventListener('drop', (e) => {
            e.preventDefault();
            e.stopPropagation();
            container.classList.remove('highlight');
            
            const files = e.dataTransfer.files;
            if (this.validateFiles(files, config)) {
                input.files = files;
                this.updateFileList(input);
            }
        });

        // Handle file selection
        input.addEventListener('change', () => {
            if (this.validateFiles(input.files, config)) {
                this.updateFileList(input);
            }
        });
    },

    validateFiles: function(files, config) {
        for (const file of files) {
            if (file.size > config.maxSize) {
                config.onValidationError(`الملف ${file.name} كبير جداً. الحد الأقصى المسموح به هو ${this.formatFileSize(config.maxSize)}`);
                return false;
            }

            const ext = '.' + file.name.split('.').pop().toLowerCase();
            if (!config.allowedTypes.includes(ext)) {
                config.onValidationError(`نوع الملف ${file.name} غير مسموح به`);
                return false;
            }
        }
        return true;
    },

    updateFileList: function(input) {
        const container = input.parentElement;
        const listContainer = container.querySelector('.file-list') || document.createElement('div');
        listContainer.className = 'file-list';
        listContainer.innerHTML = '';

        Array.from(input.files).forEach(file => {
            const item = document.createElement('div');
            item.className = 'file-item';
            item.innerHTML = `
                <i class="fas ${this.getFileIcon(file.name)}"></i>
                <span class="file-name">${file.name}</span>
                <span class="file-size">(${this.formatFileSize(file.size)})</span>
            `;
            listContainer.appendChild(item);
        });

        if (!container.querySelector('.file-list')) {
            container.appendChild(listContainer);
        }
    },

    getFileIcon: function(fileName) {
        const ext = fileName.split('.').pop().toLowerCase();
        const icons = {
            'pdf': 'fa-file-pdf',
            'doc': 'fa-file-word',
            'docx': 'fa-file-word',
            'xls': 'fa-file-excel',
            'xlsx': 'fa-file-excel',
            'txt': 'fa-file-alt',
            'jpg': 'fa-file-image',
            'jpeg': 'fa-file-image',
            'png': 'fa-file-image'
        };
        return icons[ext] || 'fa-file';
    },

    formatFileSize: function(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    },

    // AJAX Utilities
    ajax: function(url, options = {}) {
        const defaultOptions = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            },
            showLoading: true
        };

        const config = { ...defaultOptions, ...options };

        if (config.showLoading) {
            this.showLoading(true);
        }

        return fetch(url, config)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .catch(error => {
                this.showToast('حدث خطأ أثناء تنفيذ العملية', 'error');
                throw error;
            })
            .finally(() => {
                if (config.showLoading) {
                    this.showLoading(false);
                }
            });
    },

    // Keyboard Shortcuts
    initKeyboardShortcuts: function(shortcuts) {
        document.addEventListener('keydown', (e) => {
            for (const [key, callback] of Object.entries(shortcuts)) {
                const [modifier, keyName] = key.toLowerCase().split('+');
                if (e[modifier + 'Key'] && e.key.toLowerCase() === keyName) {
                    e.preventDefault();
                    callback(e);
                }
            }
        });
    },

    // Responsive Table
    initResponsiveTable: function(tableId) {
        const table = document.getElementById(tableId);
        if (!table) return;

        const headers = Array.from(table.querySelectorAll('th')).map(th => th.textContent);
        
        table.querySelectorAll('td').forEach(td => {
            const index = td.cellIndex;
            td.setAttribute('data-label', headers[index]);
        });
    }
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Initialize keyboard shortcuts
    SiteUtils.initKeyboardShortcuts({
        'alt+n': () => document.querySelector('.btn-add-new')?.click(),
        'alt+s': () => document.querySelector('.btn-save')?.click(),
        'alt+e': () => document.querySelector('.btn-edit.selected')?.click()
    });

    // Initialize responsive tables
    document.querySelectorAll('.table-modern').forEach(table => {
        SiteUtils.initResponsiveTable(table.id);
    });

    // Initialize file uploads
    document.querySelectorAll('.file-upload input[type="file"]').forEach(input => {
        SiteUtils.initFileUpload(input.id);
    });
}); 