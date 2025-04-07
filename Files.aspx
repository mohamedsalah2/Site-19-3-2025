<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Files.aspx.vb" Inherits="Inventory" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Cal/Styles/calendar-blue.css" rel="stylesheet" type="text/css" />
    <title></title>
    <style type="text/css">
        .style15
        {
            font-weight: 700;
            font-style: italic;
            text-decoration: underline;
            font-size: xx-large;
        }
        .style16
        {
            width: 130px;
        }
    </style>
    <style type="text/css">
        .FixedHeader
        {
            position: absolute;
            font-weight: bold;
        }
    </style>
    <style type="text/css">
        .upper-case
        {
            text-transform: uppercase;
        }
        .style9
        {
            margin-right: 0px;
        }
        .style6
        {
        }
        .auto-style1 {
            width: 97%;
        }
        .auto-style2 {
            margin-right: 0px;
            font-size: large;
        }
        .auto-style3 {
            background-color: #9999FF;
        }
        .auto-style4 {
            width: 130px;
            text-align: center;
        }
        .auto-style7 {
            height: 32px;
        }
        .auto-style8 {
            width: 130px;
            height: 32px;
        }
        .auto-style9 {
            background-color: #9999FF;
            width: 82px;
        }
        .auto-style10 {
            height: 32px;
            width: 82px;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server" dir="rtl" style="background-color: #D2D2D2; height: auto;
    width: auto;">
    <div dir="rtl">
        <table align="center" style="margin-right: 0px;" dir="rtl" class="auto-style1">
            <tr>
                <td align="center" class="style18">
                    <asp:LinkButton ID="LinkButton2" runat="server" PostBackUrl="~/Main.aspx" Font-Bold="True"
                        Font-Size="18pt">الصفحة الرئيسية</asp:LinkButton>
                </td>
                <td align="center" class="style15" style="border-style: groove">
                    <asp:Label ID="Label23" runat="server" Text="ملفات القطاع" CssClass="style9" Font-Size="20pt"
                        Width="200px"></asp:Label>
                </td>
                <td align="center">
                    &nbsp;</td>
                <td align="center">
                    <asp:Button ID="ShowDate_BTN" runat="server" Text="ShowDate" Visible="False" Width="18px" Height="21px" />
                    <asp:TextBox ID="Txt_IPAddress" runat="server" Width="35px" CssClass="style9" Height="25px"
                        Font-Size="16pt" Enabled="False" Visible="False"></asp:TextBox>
                    <asp:TextBox ID="Txt_Password" runat="server" Width="35px" CssClass="style9" Height="25px"
                        Font-Size="16pt" Enabled="False" Visible="False"></asp:TextBox>
                </td>
                <td align="center">
                    <asp:LinkButton ID="LinkButton7" runat="server" PostBackUrl="~/Reports.aspx" Font-Bold="True"
                        Font-Size="18pt">التقارير</asp:LinkButton>
                </td>
            </tr>
        </table>
        <table align="center" class="table table-striped" dir="rtl" width="100%" 
            style="border-style: solid;" cellpadding="0" cellspacing="0">
            <tr style="border-style: solid">
                <td class="style32" height="25">
                    <span class="dtcDisplayArea">
                        <asp:Label ID="Label22" runat="server" Text="التاريخ" CssClass="style9" Font-Size="15pt"
                            Width="100px" Font-Bold="True" Height="25px"></asp:Label>
                    </span>
                </td>
                <td class="style26" height="25">
                    <span class="dtcDisplayArea" dir="rtl"><strong><span class="style35">
                        <script src="Cal/Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
                        <script src="Cal/Scripts/jquery.dynDateTime.min.js" type="text/javascript"></script>
                        <script src="Cal/Scripts/calendar-en.min.js" type="text/javascript"></script>
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $("#<%=TxtDate.ClientID %>").dynDateTime({
                                    Date: 'now',
                                    showsTime: true,
                                    timeFormat: "12",
                                    ifFormat: "%d/%m/%Y",     //the date format that will be used to display the date in displayArea 
                                    daFormat: "%e/%m/%Y",    //date format that will be stored in the input field 
                                    align: "BR",
                                    //          align: "TL",
                                    electric: true,
                                    singleClick: true,
                                    displayArea: ".siblings('.dtcDisplayArea')",
                                    button: ".next()",
                                    allowInputToggle: true

                                });
                            });

                        </script>
                        <asp:TextBox ID="TxtDate" runat="server" Width="99px" Height="25px"
                            AutoPostBack="True"></asp:TextBox>
                        <img src="cal/calender.png" alt="Click to popup the bank window!" style="width: 20px;
                            height: 26px; margin-top: 0px" /></span></strong></span>
                </td>
                <td class="auto-style4" height="25">
                    &nbsp;
                    <strong>
                    <asp:Label ID="Label24" runat="server" Text="ID" CssClass="auto-style2" Font-Size="16pt"
                        Width="48px" Height="25px" ForeColor="Red"></asp:Label>
                    </strong>
                </td>
                <td class="style28" height="25">
                    <asp:TextBox ID="Txt_FileID" runat="server" Width="63px" CssClass="style9" Height="25px"
                        Font-Size="16pt" ReadOnly="True"></asp:TextBox>
                    <asp:Button ID="Btn_Save" runat="server" Text="حفظ" Style="font-family: 'Times New Roman', Times, serif;
                        font-size: x-large; font-weight: 700;" Width="100px" Height="30px" />
                </td>
                <td class="auto-style9" style="border-style: double" height="25">
                    <asp:Button ID="Btn_Search" runat="server" Text="بحث" Style="font-family: 'Times New Roman', Times, serif;
                        font-size: x-large; font-weight: 700;" Width="94px" Height="30px" />
                </td>
                <td class="auto-style3" style="border-style: double" height="25">
                    <asp:TextBox ID="TxtSearch" runat="server" Width="208px" CssClass="style9" Height="25px"
                        Font-Size="15pt">*إكتب كلمه للبحث*</asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="auto-style7">
                    <asp:Label ID="Label5" runat="server" Text="المسئول" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style7">
                    <asp:DropDownList ID="Drop_Responsible" runat="server" CssClass="style9" Width="130px"
                        Font-Size="15pt" DataSourceID="ResponsibleSqlDataSource" DataTextField="UsrName" DataValueField="UsrName" Height="100%">
                    </asp:DropDownList>
                </td>
                <td class="auto-style8">
                    <asp:Label ID="Label18" runat="server" Text="ملاحظات" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style7">
                    <asp:TextBox ID="Txt_Notes" runat="server" Width="213px" CssClass="style9" Height="25px"
                        Font-Size="15pt"></asp:TextBox>
                </td>
                <td class="auto-style10">
                    &nbsp;</td>
                <td class="auto-style7">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style32">
                    <asp:Label ID="Label12" runat="server" Text="موضوع الملف" CssClass="style9" Font-Size="15pt"
                        Width="100px" Font-Bold="True" ForeColor="Red"></asp:Label>
                </td>
                <td class="style26">
                    <asp:TextBox ID="Txt_FileSubject" runat="server" Width="166px" CssClass="style9" Height="65px"
                        Font-Size="13pt" TextMode="MultiLine"></asp:TextBox>
                </td>
                <td class="style16">
                    <asp:Label ID="Label10" runat="server" Text="نبذة عن محتويات الملف" CssClass="style9" Font-Size="15pt"
                        Font-Bold="True" Width="94px" ForeColor="Red"></asp:Label>
                </td>
                <td colspan="3" dir="rtl">
                    <asp:TextBox ID="Txt_File_Content" runat="server" Width="536px" CssClass="style9" Height="65px"
                        Font-Size="13pt" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            </table>
        <div id="grdCharges" runat="server" style="width: 100%; overflow: auto; height: 500px;
            margin-bottom: 65px;" dir="rtl">
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None"
                BorderWidth="1px" CellPadding="1" CellSpacing="1" Style="font-family: 'Times New Roman', Times, serif;
                font-size: x-large; margin-top: 0PX; margin-left: 0px; text-align: center; margin-right: 0px;
                margin-bottom: 9px;" EmptyDataText="لا يوجد بيانات" ShowHeaderWhenEmpty="True"
                Font-Names="Times New Roman" Font-Size="Medium" DataKeyNames="ID" DataSourceID="Entry_DataSource"
                Height="100%" Width="100%" HorizontalAlign="Center" HeaderStyle-CssClass="30"
                HeaderStyle-BackColor="YellowGreen" HeaderStyle-Font-Underline="False">
                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectImageUrl="~/Images/Select.gif" SelectText="." />
                    <asp:BoundField DataField="ID" ReadOnly="True" HeaderText="ID" SortExpression="ID"
                        Visible="False"></asp:BoundField>
                    <asp:BoundField HeaderText="رقم الملف" DataField="File_ID" ReadOnly="True" SortExpression="File_ID" >
                    <ItemStyle Width="30px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DDate" HeaderText="التاريخ" SortExpression="DDate" Visible="False">
                    </asp:BoundField>
                    <asp:BoundField DataField="File_Subject" HeaderText="الموضوع"
                        SortExpression="File_Subject" >
<ItemStyle Width="30px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="File_Content" HeaderText="محتويات الملف____________________" SortExpression="File_Content" />
                    <asp:BoundField DataField="Response_emp" HeaderText="المسئول عن الملف" SortExpression="Response_emp">
                    <ControlStyle Width="90px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Notes" HeaderText="ملاحظات" SortExpression="Notes" />
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="True" CommandName="Update"
                                OnClientClick="return confirm('هل انت متأكد من  تحديث البيانات؟'); " Text="تحديث"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel"
                                Text="الغاء"></asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton6" runat="server" CausesValidation="False" CommandName="Edit"
                                Text="تعديل"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton4" runat="server" CausesValidation="False" CommandName="Delete"
                                Text="حذف" OnClientClick="return confirm('هل انت متأكد من  حذف البيانات؟ لا يمكن الرجوع'); "></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EditRowStyle Font-Size="Medium" CssClass="GridViewEditRow" />
                <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" Font-Size="Medium"
                    VerticalAlign="Middle" HorizontalAlign="Center" CssClass="30" />
                <PagerSettings Mode="NumericFirstLast" />
                <PagerStyle ForeColor="#8C4510" HorizontalAlign="Right" />
                <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" Font-Size="Medium" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#FFF1D4" />
                <SortedAscendingHeaderStyle BackColor="#B95C30" />
                <SortedDescendingCellStyle BackColor="#F1E5CE" />
                <SortedDescendingHeaderStyle BackColor="#93451F" />
            </asp:GridView>
        </div>
                     <asp:SqlDataSource ID="InvSearch" runat="server" 
                 ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                 
                 
                 
                 SelectCommand="SELECT ID, DDate, File_ID, File_Subject, File_Content, Response_emp, Notes FROM Files WHERE (CHARINDEX(@File_Subject, File_Subject) &gt; 0) OR (CHARINDEX(@File_Content, File_Content) &gt; 0) ORDER BY ID DESC" 
                 DeleteCommand="DELETE FROM Files WHERE (ID = @ID)">
                         <DeleteParameters>
                             <asp:Parameter Name="ID" />
                         </DeleteParameters>
                         <SelectParameters>
                             <asp:ControlParameter ControlID="TxtSearch" Name="File_Subject" PropertyName="Text" />
                             <asp:ControlParameter ControlID="TxtSearch" Name="File_Content" PropertyName="Text" />
                         </SelectParameters>
             </asp:SqlDataSource>
                     <asp:SqlDataSource ID="ResponsibleSqlDataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT ID, UsrName, Work_Area FROM USERS WHERE (Work_Area &lt;&gt; '')">
                     </asp:SqlDataSource>
        <asp:SqlDataSource ID="Entry_DataSource" runat="server" ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
            SelectCommand="SELECT ID, DDate, File_ID, File_Subject, File_Content, Response_emp, Notes FROM Files WHERE (DDate = @DDATE) ORDER BY ID DESC"
            DeleteCommand="DELETE FROM Files WHERE (ID = @ID)" UpdateCommand="UPDATE Files SET ID = @ID, File_Subject = @File_Subject, File_Content = @File_Content, Response_emp = @Response_emp, Notes = @Notes WHERE (ID = @ID)">
            <DeleteParameters>
                <asp:Parameter Name="ID" />
            </DeleteParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="TxtDate" Name="DDATE" PropertyName="Text" Type="DateTime" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ID" />
                <asp:Parameter Name="File_Subject" />
                <asp:Parameter Name="File_Content" />
                <asp:Parameter Name="Response_emp" />
                <asp:Parameter Name="Notes" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>