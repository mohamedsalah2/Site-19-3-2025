<%@ Page Title="التقارير" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Reports.aspx.vb" Inherits="Site.Reports" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="reports-page">
        <!-- Reports Header -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="reports-header">
                    <h1 class="mb-3">تقارير المخزون</h1>
                    <div class="reports-filters">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <asp:Label runat="server" CssClass="form-label" Text="نوع التقرير" />
                                    <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-control" AutoPostBack="true">
                                        <asp:ListItem Text="تقرير المخزون" Value="inventory" />
                                        <asp:ListItem Text="تقرير المستندات" Value="documents" />
                                        <asp:ListItem Text="تقرير النشاط" Value="activity" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <asp:Label runat="server" CssClass="form-label" Text="الجهة" />
                                    <asp:DropDownList ID="ddlAuthority" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="الكل" Value="" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <asp:Label runat="server" CssClass="form-label" Text="من تاريخ" />
                                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <asp:Label runat="server" CssClass="form-label" Text="إلى تاريخ" />
                                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-9">
                                <asp:Button ID="btnGenerateReport" runat="server" Text="إنشاء التقرير" CssClass="btn btn-primary" />
                            </div>
                            <div class="col-md-3">
                                <div class="export-options">
                                    <asp:Button ID="btnExportExcel" runat="server" Text="تصدير Excel" CssClass="btn btn-outline" />
                                    <asp:Button ID="btnExportPdf" runat="server" Text="تصدير PDF" CssClass="btn btn-outline" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Content -->
        <div class="card">
            <div class="card-header">
                <h3>نتائج التقرير</h3>
            </div>
            <div class="card-body">
                <asp:MultiView ID="mvReports" runat="server" ActiveViewIndex="0">
                    <!-- Inventory Report -->
                    <asp:View ID="vwInventory" runat="server">
                        <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" 
                            CssClass="table-modern" AllowPaging="True" PageSize="15"
                            EmptyDataText="لا توجد بيانات للعرض">
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="الرقم" />
                                <asp:BoundField DataField="Subject" HeaderText="الموضوع" />
                                <asp:BoundField DataField="Authority" HeaderText="الجهة" />
                                <asp:BoundField DataField="Response_emp" HeaderText="الموظف المسؤول" />
                                <asp:BoundField DataField="Created_Date" HeaderText="تاريخ الإنشاء" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="Status" HeaderText="الحالة" />
                            </Columns>
                        </asp:GridView>
                    </asp:View>

                    <!-- Documents Report -->
                    <asp:View ID="vwDocuments" runat="server">
                        <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False" 
                            CssClass="table-modern" AllowPaging="True" PageSize="15"
                            EmptyDataText="لا توجد بيانات للعرض">
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="الرقم" />
                                <asp:BoundField DataField="DocTitle" HeaderText="عنوان المستند" />
                                <asp:BoundField DataField="DocType" HeaderText="نوع المستند" />
                                <asp:BoundField DataField="Authority" HeaderText="الجهة" />
                                <asp:BoundField DataField="DocDate" HeaderText="تاريخ المستند" DataFormatString="{0:dd/MM/yyyy}" />
                            </Columns>
                        </asp:GridView>
                    </asp:View>

                    <!-- Activity Report -->
                    <asp:View ID="vwActivity" runat="server">
                        <asp:GridView ID="gvActivity" runat="server" AutoGenerateColumns="False" 
                            CssClass="table-modern" AllowPaging="True" PageSize="15"
                            EmptyDataText="لا توجد بيانات للعرض">
                            <Columns>
                                <asp:BoundField DataField="ActivityDate" HeaderText="التاريخ" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                                <asp:BoundField DataField="ActivityType" HeaderText="نوع النشاط" />
                                <asp:BoundField DataField="Description" HeaderText="الوصف" />
                                <asp:BoundField DataField="User" HeaderText="المستخدم" />
                            </Columns>
                        </asp:GridView>
                    </asp:View>
                </asp:MultiView>

                <!-- Summary Section -->
                <div class="report-summary mt-4" id="reportSummary" runat="server" visible="false">
                    <h4>ملخص التقرير</h4>
                    <div class="summary-grid">
                        <div class="summary-item">
                            <div class="summary-label">إجمالي العناصر</div>
                            <div class="summary-value">
                                <asp:Literal ID="litTotalItems" runat="server" />
                            </div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">العناصر النشطة</div>
                            <div class="summary-value">
                                <asp:Literal ID="litActiveItems" runat="server" />
                            </div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">العناصر المكتملة</div>
                            <div class="summary-value">
                                <asp:Literal ID="litCompletedItems" runat="server" />
                            </div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">متوسط وقت المعالجة</div>
                            <div class="summary-value">
                                <asp:Literal ID="litAverageTime" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .reports-page {
            animation: fadeIn 0.5s ease;
        }

        .reports-header {
            max-width: 1000px;
            margin: 0 auto;
        }

        .reports-filters {
            background-color: var(--surface-color);
            border-radius: 8px;
            padding: 1.5rem;
        }

        .export-options {
            display: flex;
            gap: 0.5rem;
            justify-content: flex-end;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .summary-item {
            background-color: var(--surface-color);
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }

        .summary-label {
            color: var(--text-secondary);
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .summary-value {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .export-options {
                margin-top: 1rem;
                justify-content: flex-start;
            }
        }
    </style>
</asp:Content>
