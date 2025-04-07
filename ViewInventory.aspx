<%@ Page Title="عرض العنصر" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ViewInventory.aspx.vb" Inherits="Site.ViewInventory" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Add PDF.js for PDF preview -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.min.js"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="view-inventory-page">
        <!-- Page Header -->
        <div class="page-header card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="mb-0">تفاصيل المخزون</h1>
                    <div class="header-actions">
                        <button type="button" class="btn btn-outline-primary ms-2" onclick="printInventory()">
                            <i class="fas fa-print"></i> طباعة
                        </button>
                        <asp:Button ID="btnEdit" runat="server" Text="تعديل" CssClass="btn btn-primary ms-2" />
                        <asp:Button ID="btnBack" runat="server" Text="رجوع" CssClass="btn btn-secondary" OnClientClick="javascript:history.back(); return false;" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Details Section -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="details-section">
                    <div class="row">
                        <!-- Basic Information -->
                        <div class="col-md-6">
                            <div class="details-group">
                                <h3 class="details-title">المعلومات الأساسية</h3>
                                <div class="details-content">
                                    <div class="detail-item">
                                        <span class="detail-label">رقم الموضوع:</span>
                                        <asp:Label ID="lblSubjectID" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">تاريخ الإنشاء:</span>
                                        <asp:Label ID="lblCreatedDate" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الموظف المسؤول:</span>
                                        <asp:Label ID="lblResponsible" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الجهة:</span>
                                        <asp:Label ID="lblAuthority" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الحالة:</span>
                                        <asp:Label ID="lblStatus" runat="server" CssClass="detail-value status-badge" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Subject Information -->
                        <div class="col-md-6">
                            <div class="details-group">
                                <h3 class="details-title">معلومات الموضوع</h3>
                                <div class="details-content">
                                    <div class="detail-item">
                                        <span class="detail-label">نوع الوارد:</span>
                                        <asp:Label ID="lblIncomingType" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الرمز البريدي:</span>
                                        <asp:Label ID="lblPostalCode" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الموضوع:</span>
                                        <asp:Label ID="lblSubject" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">محتوى الموضوع:</span>
                                        <asp:Label ID="lblSubjectContent" runat="server" CssClass="detail-value" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Information -->
                    <div class="row mt-4">
                        <div class="col-md-12">
                            <div class="details-group">
                                <h3 class="details-title">معلومات إضافية</h3>
                                <div class="details-content">
                                    <div class="detail-item">
                                        <span class="detail-label">التأشيرة الداخلية:</span>
                                        <asp:Label ID="lblInTashira" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">التأشيرة الخارجية:</span>
                                        <asp:Label ID="lblOutTashira" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">التأشيرة الإضافية:</span>
                                        <asp:Label ID="lblAdditionalTashira" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الإجراءات الإضافية:</span>
                                        <asp:Label ID="lblAdditionalActions" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">الوقت المطلوب:</span>
                                        <asp:Label ID="lblRequiredTime" runat="server" CssClass="detail-value" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">ملاحظات:</span>
                                        <asp:Label ID="lblNotes" runat="server" CssClass="detail-value" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Attachments Section -->
                    <div class="row mt-4">
                        <div class="col-md-12">
                            <div class="details-group">
                                <h3 class="details-title">المرفقات</h3>
                                <div class="details-content">
                                    <asp:Panel ID="pnlAttachments" runat="server" CssClass="attachments-list">
                                        <asp:Repeater ID="rptAttachments" runat="server">
                                            <ItemTemplate>
                                                <div class="attachment-item">
                                                    <i class="fas fa-<%# GetFileIcon(Eval("FileName")) %>"></i>
                                                    <span class="attachment-name"><%# Eval("FileName") %></span>
                                                    <div class="attachment-actions">
                                                        <asp:LinkButton ID="btnDownload" runat="server" 
                                                            CssClass="btn btn-sm btn-outline-primary" 
                                                            CommandName="Download" 
                                                            CommandArgument='<%# Eval("FilePath") %>'
                                                            ToolTip="تحميل">
                                                            <i class="fas fa-download"></i>
                                                        </asp:LinkButton>
                                                        <button type="button" 
                                                            class="btn btn-sm btn-outline-secondary btn-preview preview-button"
                                                            data-file-path='<%# Eval("FilePath") %>'
                                                            data-file-name='<%# Eval("FileName") %>'
                                                            title="معاينة">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- File Preview Modal -->
    <div id="previewModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="previewTitle">معاينة الملف</h3>
                <button type="button" class="close-button" onclick="closePreviewModal()">×</button>
            </div>
            <div class="modal-body">
                <div id="previewContainer">
                    <!-- Preview content will be loaded here -->
                    <div id="pdfViewer" class="pdf-viewer"></div>
                    <img id="imageViewer" class="image-viewer" style="display: none;" />
                    <div id="previewError" class="preview-error" style="display: none;">
                        <i class="fas fa-exclamation-circle"></i>
                        <p>لا يمكن معاينة هذا النوع من الملفات. يرجى تحميل الملف لعرضه.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .view-inventory-page {
            animation: fadeIn 0.5s ease;
        }

        .details-group {
            background-color: var(--surface-color);
            border-radius: 8px;
            padding: 1.5rem;
            height: 100%;
        }

        .details-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--primary-color);
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 0.5rem;
        }

        .details-content {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .detail-item {
            display: flex;
            gap: 1rem;
            align-items: flex-start;
        }

        .detail-label {
            min-width: 150px;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .detail-value {
            flex: 1;
            color: var(--text-primary);
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .attachments-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .attachment-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem;
            background-color: rgba(0, 0, 0, 0.02);
            border-radius: 4px;
            transition: all var(--transition-fast);
        }

        .attachment-item:hover {
            background-color: rgba(0, 0, 0, 0.04);
        }

        .attachment-name {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .attachment-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-preview {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .detail-item {
                flex-direction: column;
                gap: 0.25rem;
            }

            .detail-label {
                min-width: auto;
            }

            .details-group {
                margin-bottom: 1rem;
            }
        }

        /* Print Styles */
        @media print {
            .header-actions,
            .btn,
            .no-print {
                display: none !important;
            }

            .card {
                border: none !important;
                box-shadow: none !important;
            }

            .details-group {
                page-break-inside: avoid;
            }

            .view-inventory-page {
                padding: 0 !important;
            }

            .detail-label {
                color: #000 !important;
            }

            .detail-value {
                color: #333 !important;
            }
        }

        /* Preview Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1050;
        }

        .modal-content {
            position: relative;
            width: 90%;
            max-width: 800px;
            margin: 2rem auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .modal-header {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-body {
            padding: 1rem;
            max-height: calc(100vh - 200px);
            overflow-y: auto;
        }

        .pdf-viewer {
            width: 100%;
            height: 600px;
            border: 1px solid var(--border-color);
            background: #f8f9fa;
        }

        .image-viewer {
            max-width: 100%;
            height: auto;
            border: 1px solid var(--border-color);
        }

        .preview-error {
            text-align: center;
            padding: 2rem;
            color: var(--text-secondary);
        }

        .preview-error i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
    </style>

    <script>
        // Print functionality
        function printInventory() {
            window.print();
        }

        // File preview functionality
        function showPreviewModal(filePath, fileName) {
            const modal = document.getElementById('previewModal');
            const pdfViewer = document.getElementById('pdfViewer');
            const imageViewer = document.getElementById('imageViewer');
            const previewError = document.getElementById('previewError');
            const previewTitle = document.getElementById('previewTitle');

            // Reset viewers
            pdfViewer.style.display = 'none';
            imageViewer.style.display = 'none';
            previewError.style.display = 'none';

            previewTitle.textContent = fileName;
            modal.style.display = 'block';

            const extension = fileName.split('.').pop().toLowerCase();
            
            if (extension === 'pdf') {
                pdfViewer.style.display = 'block';
                loadPdfPreview(filePath);
            } else if (['jpg', 'jpeg', 'png', 'gif'].includes(extension)) {
                imageViewer.style.display = 'block';
                imageViewer.src = filePath;
            } else {
                previewError.style.display = 'block';
            }
        }

        function closePreviewModal() {
            const modal = document.getElementById('previewModal');
            modal.style.display = 'none';
        }

        async function loadPdfPreview(url) {
            try {
                const pdfjsLib = window['pdfjs-dist/build/pdf'];
                pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.worker.min.js';

                const loadingTask = pdfjsLib.getDocument(url);
                const pdf = await loadingTask.promise;
                const page = await pdf.getPage(1);

                const scale = 1.5;
                const viewport = page.getViewport({ scale });

                const canvas = document.createElement('canvas');
                const context = canvas.getContext('2d');
                canvas.height = viewport.height;
                canvas.width = viewport.width;

                const renderContext = {
                    canvasContext: context,
                    viewport: viewport
                };

                const pdfViewer = document.getElementById('pdfViewer');
                pdfViewer.innerHTML = '';
                pdfViewer.appendChild(canvas);

                await page.render(renderContext).promise;
            } catch (error) {
                console.error('Error loading PDF:', error);
                document.getElementById('previewError').style.display = 'block';
            }
        }

        // Close modal on escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closePreviewModal();
            }
        });

        // Print shortcut (Ctrl + P)
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'p') {
                e.preventDefault();
                printInventory();
            }
        });

        // Initialize preview buttons
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.preview-button').forEach(button => {
                button.addEventListener('click', function() {
                    const filePath = this.getAttribute('data-file-path');
                    const fileName = this.getAttribute('data-file-name');
                    showPreviewModal(filePath, fileName);
                });
            });
        });
    </script>
</asp:Content> 