<%@ Page Title="" Language="VB" MasterPageFile="~/PostMaster.master" AutoEventWireup="false" CodeFile="USERS.aspx.vb" Inherits="Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1 {
            width: 100%;
            text-align: center;
            border: 2px solid #ffffff;
            background-color: #ffffff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table class="style1" dir="rtl">
        <tr>
            <td>&nbsp;</td>
            <td>
                <asp:LinkButton ID="Hide_PWD" runat="server">Hide Password</asp:LinkButton>
            </td>
            <td>
                <asp:LinkButton ID="Show_PWD" runat="server">Show Password</asp:LinkButton>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td colspan="3" style="width: 70%" dir="rtl" valign="top">
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" Width="100%"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="ID"
                        DataSourceID="UsersDataSource" CellPadding="2" HorizontalAlign="Center"
                        BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px"
                        CellSpacing="2">
                        <Columns>
                            <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True"
                                SortExpression="ID" Visible="False" />
                            <asp:BoundField DataField="UsrName" HeaderText="الاسم بالكامل"
                                SortExpression="UsrName" />
                            <asp:BoundField DataField="UsrID" HeaderText="اسم المستخدم" SortExpression="UsrID" />
                            <asp:BoundField DataField="PWD" HeaderText="الباسورد" SortExpression="PWD"
                                Visible="False" />
                            <asp:BoundField DataField="PRMTION" HeaderText="الصلاحيه"
                                SortExpression="PRMTION" Visible="False" >
<ItemStyle Font-Size="16pt" Width="10px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Work_Area" HeaderText="التخصص" SortExpression="Work_Area" />
                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
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
                    <asp:SqlDataSource ID="UsersDataSource" runat="server"
                        ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
                        DeleteCommand="DELETE FROM [USERS] WHERE [ID] = @ID"
                        InsertCommand="INSERT INTO [USERS] ([UsrName], [UsrID], [PWD], [Work_Area], [PRMTION]) VALUES (@UsrName, @UsrID, @PWD, @Work_Area, @PRMTION)"
                        SelectCommand="SELECT ID, UsrName, UsrID, PWD, Work_Area, PRMTION FROM USERS ORDER BY PRMTION, UsrName"
                        UpdateCommand="UPDATE [USERS] SET [UsrName] = @UsrName, [UsrID] = @UsrID, [PWD] = @PWD, [Work_Area] = @Work_Area, [PRMTION] = @PRMTION WHERE [ID] = @ID">
                        <DeleteParameters>
                            <asp:Parameter Name="ID" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="UsrName" Type="String" />
                            <asp:Parameter Name="UsrID" Type="String" />
                            <asp:Parameter Name="PWD" Type="String" />
                            <asp:Parameter Name="Work_Area" />
                            <asp:Parameter Name="PRMTION" Type="Int32" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="UsrName" Type="String" />
                            <asp:Parameter Name="UsrID" Type="String" />
                            <asp:Parameter Name="PWD" Type="String" />
                            <asp:Parameter Name="Work_Area" />
                            <asp:Parameter Name="PRMTION" Type="Int32" />
                            <asp:Parameter Name="ID" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
            </td>

            <td style="width: 30%" valign="top">
                <asp:DetailsView ID="DetailsView1" runat="server"
                    AutoGenerateRows="False" BackColor="White" BorderColor="#E7E7FF"
                    BorderStyle="None" BorderWidth="1px" CellPadding="3" DataKeyNames="ID"
                    DataSourceID="InsertUserDataSource" Height="158px"
                    HorizontalAlign="Center" Style="margin-right: 0px" Width="100%">
                    <AlternatingRowStyle BackColor="#F7F7F7" />
                    <EditRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    <Fields>
                        <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True"
                            SortExpression="ID" Visible="False" />
                        <asp:BoundField DataField="UsrName" HeaderText="الاسم بالكامل"
                            SortExpression="UsrName" />
                        <asp:BoundField DataField="UsrID" HeaderText="اسم المستخدم" SortExpression="UsrID" />
                        <asp:BoundField DataField="PWD" HeaderText="كلمه المرور" SortExpression="PWD" />
                        <asp:BoundField DataField="PRMTION" HeaderText="الصلاحيه"
                            SortExpression="PRMTION" />
                        <asp:CommandField
                            ShowInsertButton="True" />
                    </Fields>
                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                    <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
                    <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                </asp:DetailsView>
                <asp:SqlDataSource ID="InsertUserDataSource" runat="server"
                    ConnectionString="<%$ ConnectionStrings:Post_DBConnectionString %>"
                    DeleteCommand="DELETE FROM [USERS] WHERE [ID] = @ID"
                    InsertCommand="INSERT INTO USERS(UsrName, UsrID, PWD, PRMTION, Work_Area) VALUES (@UsrName, @UsrID, @PWD, @PRMTION, @Work_Area)"
                    SelectCommand="SELECT * FROM [USERS]"
                    UpdateCommand="UPDATE USERS SET UsrName = @UsrName, UsrID = @UsrID, PWD = @PWD, PRMTION = @PRMTION, Work_Area = WHERE (ID = @ID)">
                    <DeleteParameters>
                        <asp:Parameter Name="ID" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="UsrName" Type="String" />
                        <asp:Parameter Name="UsrID" Type="String" />
                        <asp:Parameter Name="PWD" Type="String" />
                        <asp:Parameter Name="PRMTION" Type="Int32" />
                        <asp:Parameter Name="Work_Area" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="UsrName" Type="String" />
                        <asp:Parameter Name="UsrID" Type="String" />
                        <asp:Parameter Name="PWD" Type="String" />
                        <asp:Parameter Name="PRMTION" Type="Int32" />
                        <asp:Parameter Name="ID" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Content>

