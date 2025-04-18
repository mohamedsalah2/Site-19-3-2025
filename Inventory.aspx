<%@ Page Title="المخزون" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Inventory.aspx.vb" Inherits="Site.Inventory" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Add SqlDataSource controls -->
    <asp:SqlDataSource ID="ResponsibleSqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
        SelectCommand="SELECT DISTINCT UsrName FROM Users ORDER BY UsrName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Subject_RelateSqlDataSource" runat="server"
        ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
        SelectCommand="SELECT DISTINCT Work_Area FROM Work_Areas ORDER BY Work_Area">
    </asp:SqlDataSource>

    <div class="inventory-page">
        <!-- Page Header -->
        <div class="page-header card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="mb-0">إدارة المخزون</h1>
                    <asp:Button ID="btnAddNew" runat="server" Text="إضافة جديد" CssClass="btn btn-primary" />
                </div>
            </div>
        </div>

        <!-- Filters Section -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="filters-section">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:Label runat="server" CssClass="form-label" Text="الجهة" />
                                <asp:DropDownList ID="ddlAuthority" runat="server" CssClass="form-control" AutoPostBack="true">
                                    <asp:ListItem Text="الكل" Value="" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:Label runat="server" CssClass="form-label" Text="الحالة" />
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" AutoPostBack="true">
                                    <asp:ListItem Text="الكل" Value="" />
                                    <asp:ListItem Text="نشط" Value="نشط" />
                                    <asp:ListItem Text="مكتمل" Value="مكتمل" />
                                    <asp:ListItem Text="ملغي" Value="ملغي" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:Label runat="server" CssClass="form-label" Text="الموظف المسؤول" />
                                <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-control" AutoPostBack="true">
                                    <asp:ListItem Text="الكل" Value="" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:Label runat="server" CssClass="form-label" Text="بحث" />
                                <div class="search-box">
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="ابحث هنا..." />
                                    <asp:Button ID="btnSearch" runat="server" Text="بحث" CssClass="btn btn-primary" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Inventory Grid -->
        <div class="card">
            <div class="card-body">
                <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" 
                    CssClass="table-modern" AllowPaging="True" PageSize="15"
                    EmptyDataText="لا توجد بيانات للعرض">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="الرقم" />
                        <asp:BoundField DataField="Subject" HeaderText="الموضوع" />
                        <asp:BoundField DataField="Authority" HeaderText="الجهة" />
                        <asp:BoundField DataField="Response_emp" HeaderText="الموظف المسؤول" />
                        <asp:BoundField DataField="Created_Date" HeaderText="تاريخ الإنشاء" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="الحالة">
                            <ItemTemplate>
                                <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm btn-outline" 
                                        CommandName="EditItem" CommandArgument='<%# Eval("ID") %>'
                                        ToolTip="تعديل">
                                        <i class="fas fa-edit"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-sm btn-outline" 
                                        CommandName="ViewItem" CommandArgument='<%# Eval("ID") %>'
                                        ToolTip="عرض">
                                        <i class="fas fa-eye"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-outline-danger" 
                                        CommandName="DeleteItem" CommandArgument='<%# Eval("ID") %>'
                                        OnClientClick="return confirmDelete();"
                                        ToolTip="حذف">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Edit Modal -->
        <div id="editModal" class="modal" style="display: none;">
            <div class="modal-content card">
                <div class="modal-header">
                    <h3 id="modalTitle">تعديل عنصر</h3>
                    <button type="button" class="close-button" onclick="closeModal()">×</button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hdnItemId" runat="server" />
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" Text="الموضوع" />
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" Text="الجهة" />
                        <asp:DropDownList ID="ddlEditAuthority" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" Text="الموظف المسؤول" />
                        <asp:DropDownList ID="ddlEditEmployee" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" Text="الحالة" />
                        <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="نشط" Value="نشط" />
                            <asp:ListItem Text="مكتمل" Value="مكتمل" />
                            <asp:ListItem Text="ملغي" Value="ملغي" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" Text="المرفقات" />
                        <div class="file-upload">
                            <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" AllowMultiple="true" />
                            <div class="upload-hint">اسحب الملفات هنا أو اضغط للاختيار</div>
                        </div>
                        <div id="fileList" class="file-list"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="btn btn-primary" />
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">إلغاء</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        .inventory-page {
            animation: fadeIn 0.5s ease;
        }

        .filters-section {
            background-color: var(--surface-color);
            border-radius: 8px;
            padding: 1.5rem;
        }

        .search-box {
            display: flex;
            gap: 0.5rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .status-active {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }

        .status-completed {
            background-color: rgba(23, 162, 184, 0.1);
            color: #17a2b8;
        }

        .status-cancelled {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            justify-content: flex-end;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(3px);
            z-index: 1000;
            animation: fadeIn 0.3s ease;
        }

        .modal-content {
            position: relative;
            width: 90%;
            max-width: 600px;
            margin: 2rem auto;
            animation: slideIn 0.3s ease;
        }

        .modal-header {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-body {
            padding: 1.5rem;
            max-height: calc(100vh - 200px);
            overflow-y: auto;
        }

        .modal-footer {
            padding: 1rem;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }

        .close-button {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--text-secondary);
            padding: 0.25rem;
        }

        .file-upload {
            border: 2px dashed var(--border-color);
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all var(--transition-fast);
        }

        .file-upload:hover {
            border-color: var(--primary-color);
            background-color: rgba(165, 81, 41, 0.05);
        }

        .upload-hint {
            color: var(--text-secondary);
            margin-top: 0.5rem;
            font-size: 0.875rem;
        }

        @keyframes slideIn {
            from { transform: translateY(-10%); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @media (max-width: 768px) {
            .search-box {
                flex-direction: column;
            }

            .action-buttons {
                justify-content: flex-start;
            }

            .modal-content {
                width: 95%;
                margin: 1rem auto;
            }
        }
    </style>

    <script>
        function confirmDelete() {
            return confirm('هل أنت متأكد من حذف هذا العنصر؟');
        }

        function openModal() {
            document.getElementById('editModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Initialize file upload
        document.addEventListener('DOMContentLoaded', function() {
            SiteUtils.initFileUpload('fileUpload');
        });

        // Close modal on escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.altKey && e.key === 'n') {
                e.preventDefault();
                document.getElementById('btnAddNew').click();
            }
        });
    </script>
</asp:Content>
