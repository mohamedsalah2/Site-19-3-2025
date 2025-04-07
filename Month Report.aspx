<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Month Report.aspx.vb" Inherits="Month_Report" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            font-size: large;
        }
        .auto-style2 {
            text-align: center;
        }
        .auto-style3 {
            height: 41px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="auto-style2" dir="rtl">
    
        <em><strong>
            <asp:Label ID="Label1" runat="server" CssClass="auto-style1" Text="موضوعات القطاع"></asp:Label>
            &nbsp;<asp:TextBox ID="TxtDate" runat="server" CssClass="style6" Width="90px">1-1-2020</asp:TextBox>
            </strong></em>
    
    </div>
        <div dir="rtl" style="overflow: auto; width: 100%;">
                    <rsweb:ReportViewer ID="RV_1MT" runat="server" Font-Names="Verdana" Font-Size="8pt"
                        WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Height="944px" Width="100%"
                        Style="margin-bottom: 26px" SizeToReportContent="True" ZoomMode="PageWidth">
                        <LocalReport ReportPath="REPORTS\Inventory_Month_RPT.rdlc">
                            <DataSources>
                                <rsweb:ReportDataSource DataSourceId="Inv_DailyDataSource" Name="DataSet1" />
                            </DataSources>
                        </LocalReport>
                    </rsweb:ReportViewer>
        </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    <asp:SqlDataSource ID="InvMonthDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
        SelectCommand="SELECT ID, DDate, Response_emp, Incoming_Type, Postal_Code, Authority, Emp_Number, Emp_Name, Subject, Subject_Content, In_Tashira, Out_Tashira, Incoming_From, Action_Taken, Aditional_Actions, Required_Time, Aditional_Tashira, Subject_Status, Notes, YEAR(DDate) AS Expr1, MONTH(DDate) AS Expr2 FROM Inventory WHERE (YEAR(DDate) = YEAR(@rpDate)) AND (MONTH(DDate) = MONTH(@rpDate)) ORDER BY DDate">
        <SelectParameters>
            <asp:ControlParameter ControlID="TxtDate" Name="rpDate" PropertyName="Text" Type="datetime" />
        </SelectParameters>
    </asp:SqlDataSource>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="DataSet1TableAdapters.InventoryTableAdapter">
            <SelectParameters>
                <asp:ControlParameter ControlID="TxtDate" DefaultValue="1-1-2020" Name="rpDate" PropertyName="Text" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>
</body>
</html>
