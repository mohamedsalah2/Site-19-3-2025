<%@ Page Title="البحث" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Search.aspx.vb" Inherits="Site.Search" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="search-page">
        <!-- Search Header -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="search-header">
                    <h1 class="mb-3">البحث في النظام</h1>
                    <div class="search-form">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="ابحث عن..." />
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlSearchType" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="الكل" Value="" />
                                        <asp:ListItem Text="المخزون" Value="inventory" />
                                        <asp:ListItem Text="المستندات" Value="documents" />
                                        <asp:ListItem Text="التقارير" Value="reports" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <asp:Button ID="btnSearch" runat="server" Text="بحث" CssClass="btn btn-primary w-100" />
                            </div>
                        </div>

                        <!-- Advanced Filters -->
                        <div class="advanced-filters mt-3" id="advancedFilters" style="display: none;">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <asp:Label runat="server" CssClass="form-label" Text="تاريخ من" />
                                        <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date" />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <asp:Label runat="server" CssClass="form-label" Text="تاريخ إلى" />
                                        <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date" />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <asp:Label runat="server" CssClass="form-label" Text="الجهة" />
                                        <asp:DropDownList ID="ddlAuthority" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="الكل" Value="" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn btn-link mt-2" onclick="toggleAdvancedFilters()">
                            <i class="fas fa-sliders-h"></i>
                            خيارات متقدمة
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search Results -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3>نتائج البحث</h3>
                <div class="results-count">
                    <asp:Literal ID="litResultsCount" runat="server" />
                </div>
            </div>
            <div class="card-body">
                <asp:GridView ID="gvSearchResults" runat="server" AutoGenerateColumns="False" 
                    CssClass="table-modern" AllowPaging="True" PageSize="10" 
                    EmptyDataText="لا توجد نتائج للبحث">
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <i class="fas fa-<%# GetItemIcon(Eval("ItemType")) %>"></i>
                            </ItemTemplate>
                            <ItemStyle Width="40px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Title" HeaderText="العنوان" />
                        <asp:BoundField DataField="Type" HeaderText="النوع" />
                        <asp:BoundField DataField="Authority" HeaderText="الجهة" />
                        <asp:BoundField DataField="Date" HeaderText="التاريخ" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-sm btn-outline" 
                                    CommandName="ViewItem" CommandArgument='<%# Eval("ID") %>'>
                                    <i class="fas fa-eye"></i>
                                    عرض
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <style>
        .search-page {
            animation: fadeIn 0.5s ease;
        }

        .search-header {
            max-width: 800px;
            margin: 0 auto;
        }

        .search-form {
            background-color: var(--surface-color);
            border-radius: 8px;
            padding: 1.5rem;
        }

        .advanced-filters {
            background-color: rgba(0, 0, 0, 0.02);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .results-count {
            color: var(--text-secondary);
            font-size: 0.875rem;
        }

        /* Grid Columns */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: -0.5rem;
        }

        .col-md-3, .col-md-4, .col-md-6 {
            padding: 0.5rem;
        }

        .col-md-3 { width: 25%; }
        .col-md-4 { width: 33.333333%; }
        .col-md-6 { width: 50%; }

        .w-100 { width: 100%; }

        @media (max-width: 768px) {
            .col-md-3, .col-md-4, .col-md-6 {
                width: 100%;
            }
        }
    </style>

    <script>
        function toggleAdvancedFilters() {
            const filters = document.getElementById('advancedFilters');
            const isHidden = filters.style.display === 'none';
            filters.style.display = isHidden ? 'block' : 'none';
        }
    </script>
</asp:Content> 