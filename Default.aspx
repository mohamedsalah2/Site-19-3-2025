<%@ Page Title="الرئيسية" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="Site._Default" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard">
        <!-- Welcome Section -->
        <div class="card mb-4">
            <div class="card-body">
                <h1 class="mb-3">مرحباً بك في نظام إدارة المخزون</h1>
                <p class="text-secondary">اختر إحدى الخدمات التالية للبدء</p>
            </div>
        </div>

        <!-- Quick Actions Grid -->
        <div class="grid mb-4">
            <!-- Inventory Management -->
            <div class="card">
                <div class="card-body">
                    <div class="quick-action">
                        <i class="fas fa-boxes fa-2x"></i>
                        <h3>إدارة المخزون</h3>
                        <p>عرض وإدارة المخزون والمستندات</p>
                        <a href="~/Inventory.aspx" runat="server" class="btn btn-primary mt-2">
                            <i class="fas fa-arrow-left"></i>
                            فتح المخزون
                        </a>
                    </div>
                </div>
            </div>

            <!-- Reports -->
            <div class="card">
                <div class="card-body">
                    <div class="quick-action">
                        <i class="fas fa-chart-bar fa-2x"></i>
                        <h3>التقارير</h3>
                        <p>عرض وتحميل تقارير المخزون</p>
                        <a href="~/Reports.aspx" runat="server" class="btn btn-primary mt-2">
                            <i class="fas fa-arrow-left"></i>
                            عرض التقارير
                        </a>
                    </div>
                </div>
            </div>

            <!-- Search -->
            <div class="card">
                <div class="card-body">
                    <div class="quick-action">
                        <i class="fas fa-search fa-2x"></i>
                        <h3>البحث السريع</h3>
                        <p>البحث في المستندات والمخزون</p>
                        <div class="search-box mt-2">
                            <asp:TextBox ID="txtQuickSearch" runat="server" CssClass="form-control" placeholder="ابحث هنا..." />
                            <asp:Button ID="btnQuickSearch" runat="server" Text="بحث" CssClass="btn btn-primary" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="card">
            <div class="card-header">
                <h3>النشاط الأخير</h3>
            </div>
            <div class="card-body">
                <asp:GridView ID="gvRecentActivity" runat="server" AutoGenerateColumns="False" 
                    CssClass="table-modern" AllowPaging="True" PageSize="5">
                    <Columns>
                        <asp:BoundField DataField="ActivityDate" HeaderText="التاريخ" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="ActivityType" HeaderText="نوع النشاط" />
                        <asp:BoundField DataField="Description" HeaderText="الوصف" />
                        <asp:BoundField DataField="User" HeaderText="المستخدم" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <style>
        .dashboard {
            animation: fadeIn 0.5s ease;
        }

        .quick-action {
            text-align: center;
            padding: 1rem;
        }

        .quick-action i {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .quick-action h3 {
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }

        .quick-action p {
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .search-box {
            display: flex;
            gap: 0.5rem;
        }

        .search-box .form-control {
            border-radius: 4px;
        }

        @media (max-width: 768px) {
            .search-box {
                flex-direction: column;
            }
        }
    </style>
</asp:Content> 