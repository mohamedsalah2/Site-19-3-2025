// Helper Functions
function showElement(elementId, show = true) {
    const element = document.getElementById(elementId);
    if (element) {
        element.style.display = show ? 'block' : 'none';
    } else {
        console.warn(`Element with id "${elementId}" not found`);
    }
}

function setElementValue(elementId, value) {
    const element = document.getElementById(elementId);
    if (!element) {
        console.warn(`Element with id "${elementId}" not found`);
        return;
    }

    try {
        if (element.tagName === 'SELECT') {
            const exists = Array.from(element.options).some(option => option.value === value);
            if (exists) {
                element.value = value;
            } else {
                console.warn(`Value "${value}" not found in options for select element "${elementId}"`);
            }
        } else {
            element.value = value || '';
        }
    } catch (error) {
        console.error(`Error setting value for element "${elementId}":`, error);
    }
}

function showLoading(show = true) {
    let loadingDiv = document.getElementById('loadingOverlay');
    if (!loadingDiv && show) {
        loadingDiv = document.createElement('div');
        loadingDiv.id = 'loadingOverlay';
        loadingDiv.innerHTML = `
            <div class="loading-spinner"></div>
            <div class="loading-text">جاري التحميل...</div>
        `;
        document.body.appendChild(loadingDiv);
    } else if (loadingDiv && !show) {
        loadingDiv.remove();
    }
}

// Popup Management
function openEditPopup(rowData) {
    try {
        showLoading(true);
        const data = typeof rowData === 'string' ? JSON.parse(rowData) : rowData;
        
        // Populate form fields
        const fields = {
            'ddlResponsible': 'Response_emp',
            'ddlIncomingType': 'Incoming_Type',
            'txtAuthority': 'Authority',
            'txtSubject': 'Subject',
            'txtSubjectContent': 'Subject_content'
        };

        Object.entries(fields).forEach(([elementId, dataKey]) => {
            setElementValue(elementId, data[dataKey]);
        });
        
        // Store the record ID
        setElementValue('hdnRecordId', data.ID);

        // Load attachments if any
        if (data.Attachments) {
            loadAttachments(data.Attachments);
        }

        // Show popup and overlay with animation
        const popup = document.querySelector('.popup-panel');
        const overlay = document.getElementById('overlay');
        
        if (popup && overlay) {
            popup.classList.add('fade-in');
            overlay.classList.add('fade-in');
            showElement('overlay');
            popup.style.display = 'block';
        }

    } catch (error) {
        console.error('Error opening edit popup:', error);
        alert('حدث خطأ أثناء فتح نافذة التعديل');
    } finally {
        showLoading(false);
    }
}

function loadAttachments(attachments) {
    const attachmentsPanel = document.getElementById('pnlAttachments');
    if (!attachmentsPanel) return;

    try {
        attachmentsPanel.innerHTML = '';
        if (!attachments || !attachments.length) {
            attachmentsPanel.innerHTML = '<div class="no-attachments">لا توجد مرفقات</div>';
            return;
        }

        const list = document.createElement('div');
        list.className = 'attachments-list';

        attachments.forEach(attachment => {
            const item = document.createElement('div');
            item.className = 'attachment-item';
            
            const icon = getFileIcon(attachment.FileType);
            item.innerHTML = `
                <div class="attachment-icon">${icon}</div>
                <div class="attachment-details">
                    <div class="attachment-name">${attachment.FileName}</div>
                    <div class="attachment-size">${formatFileSize(attachment.FileSize)}</div>
                </div>
                <div class="attachment-actions">
                    <button class="btn-download" onclick="downloadAttachment('${attachment.ID}')">
                        <i class="fas fa-download"></i>
                    </button>
                    <button class="btn-delete" onclick="deleteAttachment('${attachment.ID}')">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
            list.appendChild(item);
        });

        attachmentsPanel.appendChild(list);
    } catch (error) {
        console.error('Error loading attachments:', error);
        attachmentsPanel.innerHTML = '<div class="error-message">حدث خطأ أثناء تحميل المرفقات</div>';
    }
}

function getFileIcon(fileType) {
    const icons = {
        'pdf': '<i class="fas fa-file-pdf"></i>',
        'doc': '<i class="fas fa-file-word"></i>',
        'docx': '<i class="fas fa-file-word"></i>',
        'xls': '<i class="fas fa-file-excel"></i>',
        'xlsx': '<i class="fas fa-file-excel"></i>',
        'txt': '<i class="fas fa-file-alt"></i>',
        'jpg': '<i class="fas fa-file-image"></i>',
        'jpeg': '<i class="fas fa-file-image"></i>',
        'png': '<i class="fas fa-file-image"></i>'
    };
    return icons[fileType.toLowerCase()] || '<i class="fas fa-file"></i>';
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

async function downloadAttachment(attachmentId) {
    try {
        showLoading(true);
        const response = await fetch(`Inventory.aspx/DownloadAttachment?id=${attachmentId}`);
        if (!response.ok) throw new Error('Download failed');
        
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = ''; // Server will set the filename
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        a.remove();
    } catch (error) {
        console.error('Error downloading attachment:', error);
        alert('حدث خطأ أثناء تحميل الملف');
    } finally {
        showLoading(false);
    }
}

async function deleteAttachment(attachmentId) {
    if (!confirm('هل أنت متأكد من حذف هذا الملف؟')) return;

    try {
        showLoading(true);
        const response = await fetch('Inventory.aspx/DeleteAttachment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8',
            },
            body: JSON.stringify({ attachmentId })
        });

        const data = await response.json();
        if (data.d) {
            const item = document.querySelector(`[data-attachment-id="${attachmentId}"]`);
            if (item) {
                item.remove();
                if (!document.querySelector('.attachment-item')) {
                    document.getElementById('pnlAttachments').innerHTML = 
                        '<div class="no-attachments">لا توجد مرفقات</div>';
                }
            }
        } else {
            throw new Error('Delete failed');
        }
    } catch (error) {
        console.error('Error deleting attachment:', error);
        alert('حدث خطأ أثناء حذف الملف');
    } finally {
        showLoading(false);
    }
}

function closeEditPopup() {
    try {
        const popup = document.querySelector('.popup-panel');
        const overlay = document.getElementById('overlay');
        
        if (popup && overlay) {
            popup.classList.remove('fade-in');
            overlay.classList.remove('fade-in');
            
            // Reset form
            resetForm();

            // Hide elements
            showElement('overlay', false);
            popup.style.display = 'none';
        }
    } catch (error) {
        console.error('Error closing edit popup:', error);
        alert('حدث خطأ أثناء إغلاق نافذة التعديل');
    }
}

function resetForm() {
    try {
        // Reset form fields
        const form = document.getElementById('form1');
        if (form) {
            form.querySelectorAll('input[type="text"], textarea, select').forEach(input => {
                input.value = '';
            });
        }

        // Reset file upload
        const fileUpload = document.getElementById('fileUpload');
        if (fileUpload) {
            fileUpload.value = '';
            updateFileUploadText();
        }

        // Clear attachments panel
        const attachmentsPanel = document.getElementById('pnlAttachments');
        if (attachmentsPanel) {
            attachmentsPanel.innerHTML = '';
        }
    } catch (error) {
        console.error('Error resetting form:', error);
    }
}

// Toast Notifications
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type} fade-in`;
    toast.innerHTML = `
        <div class="toast-content">
            <i class="toast-icon fas ${getToastIcon(type)}"></i>
            <span class="toast-message">${message}</span>
        </div>
        <button class="toast-close" onclick="this.parentElement.remove()">×</button>
    `;
    document.body.appendChild(toast);

    // Auto remove after 5 seconds
    setTimeout(() => {
        toast.classList.add('fade-out');
        setTimeout(() => toast.remove(), 300);
    }, 5000);
}

function getToastIcon(type) {
    const icons = {
        'success': 'fa-check-circle',
        'error': 'fa-exclamation-circle',
        'warning': 'fa-exclamation-triangle',
        'info': 'fa-info-circle'
    };
    return icons[type] || icons.info;
}

// Enhanced Form Validation with Better Feedback
function validateEditForm() {
    try {
        const requiredFields = {
            'ddlResponsible': 'المسئول',
            'ddlIncomingType': 'نوع الوارد',
            'txtAuthority': 'الجهة',
            'txtSubject': 'الموضوع'
        };

        let isValid = true;
        let firstInvalidField = null;

        // Remove any existing error indicators
        document.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));
        document.querySelectorAll('.error-message').forEach(el => el.remove());

        for (const [fieldId, fieldName] of Object.entries(requiredFields)) {
            const field = document.getElementById(fieldId);
            if (!field || !field.value.trim()) {
                isValid = false;
                if (!firstInvalidField) firstInvalidField = field;
                
                // Add error styling
                field.classList.add('field-error');
                
                // Add error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.textContent = `الرجاء إدخال ${fieldName}`;
                field.parentNode.appendChild(errorDiv);
            }
        }

        if (!isValid) {
            showToast('يرجى ملء جميع الحقول المطلوبة', 'warning');
            if (firstInvalidField) firstInvalidField.focus();
            return false;
        }

        return validateFileUpload();
    } catch (error) {
        console.error('Error validating form:', error);
        showToast('حدث خطأ أثناء التحقق من صحة البيانات', 'error');
        return false;
    }
}

// Enhanced File Upload Validation
function validateFileUpload() {
    const fileInput = document.getElementById('fileUpload');
    if (!fileInput || !fileInput.files || !fileInput.files.length) {
        return true;
    }

    const maxSize = 10 * 1024 * 1024; // 10MB
    const allowedTypes = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.txt', '.jpg', '.jpeg', '.png'];
    
    for (const file of fileInput.files) {
        if (file.size > maxSize) {
            showToast(`الملف ${file.name} كبير جداً. الحد الأقصى المسموح به هو 10 ميجابايت`, 'error');
            fileInput.value = '';
            updateFileUploadText();
            return false;
        }
        
        const extension = file.name.substring(file.name.lastIndexOf('.')).toLowerCase();
        if (!allowedTypes.includes(extension)) {
            showToast(`نوع الملف ${file.name} غير مسموح به`, 'error');
            fileInput.value = '';
            updateFileUploadText();
            return false;
        }
    }
    
    return true;
}

// Enhanced File Upload UI
function updateFileUploadText() {
    const fileUpload = document.getElementById('fileUpload');
    const uploadText = document.querySelector('.upload-text');
    if (fileUpload && uploadText) {
        if (fileUpload.files.length > 0) {
            const fileList = Array.from(fileUpload.files)
                .map(file => `<div class="file-item">
                    <i class="fas ${getFileIcon(file.name.split('.').pop())}"></i>
                    <span>${file.name}</span>
                    <small>(${formatFileSize(file.size)})</small>
                </div>`).join('');
            uploadText.innerHTML = `
                <div class="selected-files">
                    ${fileList}
                </div>
            `;
        } else {
            uploadText.innerHTML = `
                <i class="fas fa-cloud-upload-alt"></i>
                <div>اسحب الملفات هنا أو انقر للاختيار</div>
            `;
        }
    }
}

// Enhanced Error Handling
function handleError(error, userMessage) {
    console.error(error);
    showToast(userMessage, 'error');
}

// Keyboard Shortcuts
function initializeKeyboardShortcuts() {
    document.addEventListener('keydown', e => {
        // Alt + N: New Record
        if (e.altKey && e.key === 'n') {
            e.preventDefault();
            document.querySelector('.btn-add-new')?.click();
        }
        
        // Alt + S: Save Changes
        if (e.altKey && e.key === 's') {
            e.preventDefault();
            if (document.querySelector('.popup-panel').style.display === 'block') {
                document.getElementById('btnSave')?.click();
            }
        }
        
        // Alt + E: Edit Selected
        if (e.altKey && e.key === 'e') {
            e.preventDefault();
            const selectedRow = document.querySelector('.selected-row');
            if (selectedRow) {
                selectedRow.querySelector('.btn-edit')?.click();
            }
        }
    });
}

// Initialize Event Listeners
document.addEventListener('DOMContentLoaded', function() {
    try {
        initializeKeyboardShortcuts();
        
        // Enhanced File Upload Handling
        const fileUpload = document.getElementById('fileUpload');
        if (fileUpload) {
            const fileUploadContainer = document.querySelector('.file-upload');
            
            // Drag and drop enhancements
            if (fileUploadContainer) {
                fileUploadContainer.addEventListener('dragenter', e => {
                    e.preventDefault();
                    e.stopPropagation();
                    fileUploadContainer.classList.add('highlight');
                    showToast('اسحب الملفات هنا', 'info');
                }, false);

                fileUploadContainer.addEventListener('drop', e => {
                    e.preventDefault();
                    e.stopPropagation();
                    fileUploadContainer.classList.remove('highlight');
                    
                    const files = e.dataTransfer.files;
                    if (files.length > 0) {
                        fileUpload.files = files;
                        updateFileUploadText();
                        validateFileUpload();
                        showToast(`تم اختيار ${files.length} ملف(ات)`, 'success');
                    }
                });
            }
        }
        
        // Popup close handlers
        const overlay = document.getElementById('overlay');
        const closeButton = document.getElementById('btnClosePopup');
        const cancelButton = document.getElementById('btnCancel');

        if (overlay) {
            overlay.addEventListener('click', closeEditPopup);
        }

        if (closeButton) {
            closeButton.addEventListener('click', e => {
                e.preventDefault();
                closeEditPopup();
            });
        }

        if (cancelButton) {
            cancelButton.addEventListener('click', e => {
                e.preventDefault();
                closeEditPopup();
            });
        }

        // Escape key handler
        document.addEventListener('keydown', e => {
            if (e.key === 'Escape') {
                closeEditPopup();
            }
        });

        // Form validation
        const form = document.getElementById('form1');
        if (form) {
            form.addEventListener('submit', e => {
                if (!validateEditForm()) {
                    e.preventDefault();
                }
            });
        }

    } catch (error) {
        handleError(error, 'حدث خطأ أثناء تهيئة التطبيق');
    }
});