<%@ Page Title="بيانات المكاتب" Language="VB" MasterPageFile="~/PostMaster.master" AutoEventWireup="false" CodeFile="OffceData.aspx.vb" Inherits="OffceBlnce" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1
        {
            width: 100%;
            border: 2px solid #ffffff;
            background-color: #ffffff;
        }
        .style7
        {
            width: 94px;
        }
        .style8
        {
            width: 95px;
        }
        .style9
        {
            width: 185px;
        }
        .style10
        {
            width: 427px;
        }
        .auto-style3 {
            font-weight: bold;
            font-size: large;
        }
        .auto-style4 {
            font-size: large;
        }
        .auto-style5 {
            width: 106px;
            height: 60px;
        }
        .auto-style6 {
            width: 427px;
            height: 60px;
        }
        .auto-style7 {
            width: 95px;
            height: 60px;
        }
        .auto-style8 {
            width: 94px;
            height: 60px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id = "PageBody" class="PageBody" dir="rtl"> 
    
        <table class="style1" dir="rtl">
            <tr>
                <td style="text-align: right" class="auto-style5">
                    <b>
                    <asp:Label ID="Label1" runat="server" Text="المنطقة" Font-Size="14pt" CssClass="auto-style4"></asp:Label>
                    <span class="auto-style4">&nbsp;&nbsp; 
                    </span></b> 
                    <asp:DropDownList ID="DropZone" runat="server" AutoPostBack="True" 
                        DataSourceID="ZoneDataSource" DataTextField="Zone_Name" 
                        DataValueField="ZoneID" CssClass="auto-style3">
                    </asp:DropDownList>
                </td>
                <td style="text-align: left" class="auto-style6">
                    <asp:DropDownList ID="DropOfce1" runat="server" AutoPostBack="True" 
                        DataSourceID="OfceSqlDataSource" DataTextField="OFCE_NAME" 
                        DataValueField="OFCE_ID" 
                        style="margin-right: 0px ; " Height="33px" Width="30px" CssClass="style9" 
                         Font-Size="15pt" Visible="False">
                    </asp:DropDownList>

                           
                    <asp:Panel ID="Panel_Save" runat="server" Visible="False" Width="526px">
                        <asp:Label ID="Label2" runat="server" Text="الكود المالي " 
                        Font-Size="14pt"></asp:Label>
                        <asp:TextBox ID="TxtOfceID" runat="server" Width="89px"></asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Font-Size="14pt" Text="إسم المكتب"></asp:Label>
                        <asp:TextBox ID="TxtOfceName" runat="server" Width="102px"></asp:TextBox>
                        <asp:Label ID="Label4" runat="server" Font-Size="14pt" Text="المدير"></asp:Label>
                        <asp:TextBox ID="TxtOfceManager" runat="server" Width="89px"></asp:TextBox>
                    </asp:Panel>

                           
                </td>
                <td class="auto-style7">
                </td>
                <td style="text-align: center" class="auto-style8">
                    <asp:Button ID="Save_Btn" runat="server" Text="حفظ" Visible="False" 
                        Font-Names="Times New Roman" Font-Size="18pt" />
                     <asp:TextBox ID="TxtDpt" runat="server" AutoPostBack="True" Visible="False" 
                         Width="16px">0</asp:TextBox>
                 </td>
            </tr>
            <tr>
                <td colspan="4" 
                    style=" margin-right:auto ; margin-left:auto ; text-align: center" >
                    <asp:DetailsView ID="DetailsView1" runat="server" 
                        DataSourceID="AddOfceSqlDataSource" Height="50px" Width="125px">
                    </asp:DetailsView>
                    <asp:SqlDataSource ID="AddOfceSqlDataSource" runat="server"></asp:SqlDataSource>
                    <asp:GridView ID="DgvOfce" runat="server" AllowPaging="True" 
                        AllowSorting="True" AutoGenerateColumns="False" BackColor="#DEBA84" 
                        BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                        CellSpacing="2" DataSourceID="OfceSqlDataSource" PageSize="30" 
                        Width="930px" style="font-size: large" DataKeyNames="ID">
                        <Columns>
                            <asp:BoundField DataField="ID" HeaderText="ID" SortExpression="ID" Visible="False" />
                            <asp:BoundField DataField="OFCE_ID" HeaderText="الكود المالي" 
                                SortExpression="OFCE_ID" />
                            <asp:BoundField DataField="OFCE_NAME" HeaderText="إسم المكتب" 
                                SortExpression="OFCE_NAME" />
                            <asp:BoundField DataField="ZoneID" HeaderText="المنطقه" 
                                SortExpression="ZoneID" Visible="False" />
                            <asp:BoundField DataField="Manager_Name" HeaderText="مدير الوحده" 
                                SortExpression="Manager_Name" />
                            <asp:BoundField DataField="P_CODE" HeaderText="الرقم البريدي" 
                                SortExpression="P_CODE" />
                            <asp:CommandField DeleteText="مسح" EditText="تعديل" ShowDeleteButton="True" />
                            <asp:CommandField EditText="تعديل" ShowEditButton="True" />
                        </Columns>
                        <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                        <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
                        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                        <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#FFF1D4" />
                        <SortedAscendingHeaderStyle BackColor="#B95C30" />
                        <SortedDescendingCellStyle BackColor="#F1E5CE" />
                        <SortedDescendingHeaderStyle BackColor="#93451F" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="OfceSqlDataSource" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                        
                        SelectCommand="SELECT ZoneID, OFCE_NAME, OFCE_ID, P_Code, ID, Manager_Name, Zone_Name FROM OFFICES WHERE (ZoneID = @ZoneID) ORDER BY OFCE_NAME" DeleteCommand="DELETE FROM OFFICES WHERE (ID = @ID)" UpdateCommand="UPDATE OFFICES SET OFCE_NAME = @OFCE_NAME, OFCE_ID = @OFCE_ID, P_Code = @P_Code, Manager_Name = @Manager_Name WHERE (ID = @ID)">
                        <DeleteParameters>
                            <asp:Parameter Name="ID" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="DropZone" Name="ZoneID" 
                                PropertyName="SelectedValue" Type="Int32" DefaultValue="" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="OFCE_NAME" />
                            <asp:Parameter Name="OFCE_ID" />
                            <asp:Parameter Name="P_Code" />
                            <asp:Parameter Name="Manager_Name" />
                            <asp:Parameter Name="ID" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                     <asp:SqlDataSource ID="ZoneDataSource" runat="server" 
                         ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>" 
                         
                         SelectCommand="SELECT DISTINCT Zone_Name, ZoneID FROM OFFICES">
                     </asp:SqlDataSource>
               </td>
            </tr>
            </table>
    <br />
    <br />

    </div>
</asp:Content>

