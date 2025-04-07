<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Head_Sector.aspx.vb" Inherits="Inventory" %>


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
            font-size: medium;
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
        .auto-style5 {
            height: 73px;
        }
        .auto-style6 {
            width: 130px;
            height: 73px;
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
        .auto-style11 {
            width: 82px;
        }
        .auto-style12 {
            height: 73px;
            width: 82px;
        }
        .auto-style13 {
            width: 72px;
        }
        .auto-style14 {
            margin-right: 0px;
            font-size: medium;
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
                    <asp:Label ID="Label23" runat="server" Text="تقرير مرور رئيس  القطاع" CssClass="style9" Font-Size="20pt"
                        Width="244px"></asp:Label>
                </td>
                <td align="center" class="auto-style13">
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
                        <asp:Label ID="Label22" runat="server" Text="تاريخ-ساعه المرور" CssClass="style9" Font-Size="11pt"
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
                        <asp:TextBox ID="TxtDate" runat="server" Width="86px" Height="25px"
                            AutoPostBack="True"></asp:TextBox>
                        <img src="cal/calender.png" alt="Click to popup the bank window!" style="width: 20px;
                            height: 26px; margin-top: 0px" /></span></strong></span>
                    <asp:DropDownList ID="Drop_Time" runat="server" CssClass="style9" Width="51px"
                        Font-Size="15pt" Height="85%">
                        <asp:ListItem Selected="True">1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem>10</asp:ListItem>
                        <asp:ListItem>11</asp:ListItem>
                        <asp:ListItem>12</asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td class="auto-style4" height="25">
                    &nbsp;
                    <strong>
                    <asp:Label ID="Label24" runat="server" Text="ID" CssClass="auto-style2" Font-Size="16pt"
                        Width="48px" Height="25px" ForeColor="Red"></asp:Label>
                    </strong>
                </td>
                <td class="style28" height="25">
                    <asp:TextBox ID="Txt_Record_ID" runat="server" Width="63px" CssClass="style9" Height="25px"
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
                    <asp:Label ID="Label5" runat="server" Text="المنطقه" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style7">
                    <asp:DropDownList ID="Drop_Zone" runat="server" CssClass="style9" Width="130px"
                        Font-Size="15pt" DataSourceID="Zone_DataSource" DataTextField="Zone_Name" DataValueField="ZoneID" Height="100%" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
                <td class="auto-style8">
                    <asp:Label ID="Label4" runat="server" Text="اسم الوحده" CssClass="style9" Font-Size="15pt"
                        Width="91px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style7">
                    <asp:DropDownList ID="Drop_Office" runat="server" CssClass="style9" Width="130px"
                        Font-Size="15pt" DataSourceID="Office_DataSource" DataTextField="OFCE_NAME" DataValueField="OFCE_NAME" Height="100%" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
                <td class="auto-style10">
                    <asp:Label ID="Label9" runat="server" Text="الرقم البريدي" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style7">
                    <asp:DropDownList ID="Drop_PostalCode" runat="server" CssClass="style9" Width="129px"
                        Font-Size="15pt" DataSourceID="OfficePostalCode_DataSource" DataTextField="P_Code" DataValueField="P_Code" Height="100%" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="style32">
                    <asp:Label ID="Label6" runat="server" Text="الكود المالي" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="style26">
                    <asp:DropDownList ID="Drop_OfficeCode" runat="server" CssClass="style9" Width="130px"
                        Font-Size="15pt" Height="100%" DataSourceID="OfficeID_DataSource" DataTextField="OFCE_ID" DataValueField="OFCE_ID">
                    </asp:DropDownList>
                </td>
                <td class="style16">
                    <asp:Label ID="Label7" runat="server" Text="اسم مدير الوحده" CssClass="style9" Font-Size="15pt"
                        Width="104px" Height="25px"></asp:Label>
                </td>
                <td class="style28">
                    <asp:DropDownList ID="Drop_Manager_Name" runat="server" CssClass="style9" Width="210px"
                        Font-Size="15pt" DataSourceID="ManagerName_DataSource" DataTextField="Manager_Name" DataValueField="Manager_Name" Height="100%">
                    </asp:DropDownList>
                </td>
                <td class="auto-style11">
                    <asp:Label ID="Label19" runat="server" Text="اسم المرافق" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="style30">
                    <asp:TextBox ID="Txt_Fellow_Name" runat="server" Width="210px" CssClass="style9" Height="25px"
                        Font-Size="15pt"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style32">
                    <asp:Label ID="Label12" runat="server" Text="ملاحظات التقرير" CssClass="style9" Font-Size="15pt"
                        Width="100px" Font-Bold="True" ForeColor="Red"></asp:Label>
                </td>
                <td class="style26">
                    <asp:TextBox ID="Txt_Report_Notes" runat="server" Width="166px" CssClass="style9" Height="65px"
                        Font-Size="13pt" TextMode="MultiLine"></asp:TextBox>
                </td>
                <td class="style16">
                    <asp:Label ID="Label10" runat="server" Text="الايضاحات" CssClass="style9" Font-Size="15pt"
                        Font-Bold="True" Width="94px" ForeColor="Red"></asp:Label>
                </td>
                <td colspan="3" dir="rtl">
                    <asp:TextBox ID="Txt_inform" runat="server" Width="536px" CssClass="style9" Height="65px"
                        Font-Size="13pt" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="auto-style5">
                    <asp:Label ID="Label11" runat="server" Text="اجراءات المنطقة" CssClass="auto-style14"
                        Font-Size="15pt" Width="100px" Height="63px"></asp:Label>
                </td>
                <td class="auto-style5">
                    <asp:TextBox ID="Txt_Action_Taken" runat="server" Width="165px" CssClass="style9"
                        Height="25px" Font-Size="15pt"></asp:TextBox>
                </td>
                <td class="auto-style6">
                    <asp:Label ID="Label1" runat="server" Text="المتابعه" CssClass="style9" Font-Size="15pt"
                        Width="94px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style5">
                    <asp:TextBox ID="Txt_FollowUp" runat="server" Width="200px" CssClass="style9" Height="25px"
                        Font-Size="12pt"></asp:TextBox>
                    </td>
                <td class="auto-style12">
                    <asp:Label ID="Label18" runat="server" Text="ملاحظات" CssClass="style9" Font-Size="15pt"
                        Width="100px" Height="25px"></asp:Label>
                </td>
                <td class="auto-style5">
                    <asp:TextBox ID="Txt_Notes" runat="server" Width="213px" CssClass="style9" Height="25px"
                        Font-Size="15pt"></asp:TextBox>
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
                Font-Names="Times New Roman" Font-Size="Medium" DataKeyNames="ID"
                Height="100%" Width="100%" HorizontalAlign="Center" HeaderStyle-CssClass="30"
                HeaderStyle-BackColor="YellowGreen" HeaderStyle-Font-Underline="False" DataSourceID="Entry_DataSource">
                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectImageUrl="~/Images/Select.gif" SelectText="." />
                    <asp:BoundField DataField="ID" ReadOnly="True" HeaderText="ID" SortExpression="ID"
                        Visible="False"></asp:BoundField>
                    <asp:BoundField HeaderText="ID" DataField="Record_ID" ReadOnly="True" SortExpression="Record_ID" />
                    <asp:BoundField DataField="Zone" HeaderText="المنطقة" SortExpression="Zone">
                    <ControlStyle Width="90px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="OFCE_NAME" HeaderText="اسم الوحدة"
                        SortExpression="OFCE_NAME" />
                    <asp:BoundField DataField="Postal_Code" HeaderText="الرقم البريدي" SortExpression="Postal_Code" />
                    <asp:BoundField DataField="OFCE_ID" HeaderText="الكود المالي" SortExpression="OFCE_ID">
                    <ItemStyle Width="30px" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Manager_Name" HeaderText="اسم المدير" SortExpression="Manager_Name"
                        ReadOnly="True">
                    <ItemStyle Width="30px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Fellow_Name" HeaderText="اسم المرافق" 
                        SortExpression="Fellow_Name">
                    <ControlStyle Width="50px" />
                    <HeaderStyle Wrap="False" Font-Underline="False" />
                    <ItemStyle Width="30px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Moror_Date" HeaderText="تاريخ المرور" SortExpression="Moror_Date" Visible="False" />
                    <asp:BoundField DataField="Moror_Time" HeaderText="ساعة المرور" SortExpression="Moror_Time">
                    <ItemStyle Width="30px" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="ملاحظات التقرير" DataField="Report_Notes" SortExpression="Report_Notes"
                        ItemStyle-Width="160px">
                    <FooterStyle Wrap="True" />
                    <HeaderStyle Wrap="False" />
                    <ItemStyle Width="160px" Wrap="False"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField HeaderText="الايضحات" DataField="inform" SortExpression="inform">
                    <HeaderStyle Wrap="False" />
                    <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="اجراءات  المنطقة" DataField="Action_Taken" SortExpression="Action_Taken" />
                    <asp:BoundField HeaderText="المتابعة" DataField="FollowUp" SortExpression="FollowUp">
                    <ItemStyle Wrap="True" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="ملاحظات" DataField="Notes" SortExpression="Notes" />
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
                 
                 
                 
                 SelectCommand="SELECT ID, Record_ID, Zone, OFCE_NAME, Postal_Code, OFCE_ID, Manager_Name, Fellow_Name, Moror_Date, Moror_Time, Report_Notes, Action_Taken, FollowUp, Notes, inform FROM Head_Sector WHERE (CHARINDEX(@Report_Notes, Report_Notes) &gt; 0) OR (CHARINDEX(@Action_Taken, Action_Taken) &gt; 0) ORDER BY ID DESC" 
                 DeleteCommand="DELETE FROM [dbo].[Head_Sector]  WHERE [ID] = @ID">
                         <DeleteParameters>
                             <asp:Parameter Name="ID" />
                         </DeleteParameters>
                         <SelectParameters>
                             <asp:ControlParameter ControlID="TxtSearch" Name="Report_Notes" 
                                 PropertyName="Text" />
                             <asp:ControlParameter ControlID="TxtSearch" Name="Action_Taken" PropertyName="Text" />
                         </SelectParameters>
             </asp:SqlDataSource>
                     <asp:SqlDataSource ID="Zone_DataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT DISTINCT Zone_Name, ZoneID FROM OFFICES">
                     </asp:SqlDataSource>
                     <asp:SqlDataSource ID="Office_DataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT OFCE_ID, OFCE_NAME, ZoneID, P_Code, Zone_Name, Manager_Name FROM OFFICES WHERE (ZoneID = @ZoneID) ORDER BY OFCE_NAME">
                         <SelectParameters>
                             <asp:ControlParameter ControlID="Drop_Zone" DefaultValue="6" Name="ZoneID" PropertyName="SelectedValue" />
                         </SelectParameters>
                     </asp:SqlDataSource>
                     <asp:SqlDataSource ID="OfficeID_DataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT OFCE_ID, OFCE_NAME, ZoneID, P_Code FROM OFFICES WHERE (OFCE_NAME = @OFCE_NAME) ORDER BY OFCE_ID">
                         <SelectParameters>
                             <asp:ControlParameter ControlID="Drop_Office" Name="OFCE_NAME" PropertyName="SelectedValue" />
                         </SelectParameters>
                     </asp:SqlDataSource>
                     <asp:SqlDataSource ID="OfficePostalCode_DataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT OFCE_ID, OFCE_NAME, P_Code FROM OFFICES WHERE (OFCE_NAME = @OFCE_NAME)">
                         <SelectParameters>
                             <asp:ControlParameter ControlID="Drop_Office" Name="OFCE_NAME" PropertyName="SelectedValue" />
                         </SelectParameters>
                     </asp:SqlDataSource>
                     <asp:SqlDataSource ID="ManagerName_DataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT OFCE_ID, OFCE_NAME, ZoneID, P_Code, Manager_Name FROM OFFICES WHERE (OFCE_NAME = @OFCE_NAME) ORDER BY OFCE_ID">
                         <SelectParameters>
                             <asp:ControlParameter ControlID="Drop_Office" Name="OFCE_NAME" PropertyName="SelectedValue" />
                         </SelectParameters>
                     </asp:SqlDataSource>
        <asp:SqlDataSource ID="Entry_DataSource" runat="server" ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
            SelectCommand="SELECT ID, Record_ID, Zone, OFCE_NAME, Postal_Code, OFCE_ID, Manager_Name, Fellow_Name,Moror_Date, Moror_Time, Report_Notes, inform, Action_Taken, FollowUp, Notes FROM Head_Sector WHERE (CONVERT(VARCHAR(12), Moror_Date, 103)  = @Moror_Date) ORDER BY ID DESC"
            DeleteCommand="DELETE FROM Head_Sector WHERE  (ID = @ID)" UpdateCommand="UPDATE Head_Sector SET ID = @ID,  Zone = @Zone, OFCE_NAME = @OFCE_NAME, Postal_Code = @Postal_Code, OFCE_ID = @OFCE_ID, Manager_Name = @Manager_Name, Fellow_Name = @Fellow_Name, Moror_Time = @Moror_Time, Report_Notes = @Report_Notes, inform = @inform, Action_Taken = @Action_Taken, FollowUp = @FollowUp, Notes = @Notes WHERE (ID = @ID)">
            <DeleteParameters>
                <asp:Parameter Name="ID" />
            </DeleteParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="TxtDate" Name="Moror_Date" PropertyName="Text" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ID" />
                <asp:Parameter Name="Zone" />
                <asp:Parameter Name="OFCE_NAME" />
                <asp:Parameter Name="Postal_Code" />
                <asp:Parameter Name="OFCE_ID" />
                <asp:Parameter Name="Manager_Name" />
                <asp:Parameter Name="Fellow_Name" />
                <asp:Parameter Name="Moror_Time" />
                <asp:Parameter Name="Report_Notes" />
                <asp:Parameter Name="inform" />
                <asp:Parameter Name="Action_Taken" />
                <asp:Parameter Name="FollowUp" />
                <asp:Parameter Name="Notes" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>