<%@ Page Title="" Language="VB" MasterPageFile="~/PostMaster.master" AutoEventWireup="false" CodeFile="ChngePswrd.aspx.vb" Inherits="ChngePswrd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1
        {
            width: 100%;
            border: 2px solid #ccffcc;
            background-color: #ffffff;
        }
        .style2
        {
            width: 223px;
            text-align: left;
        }
        .style3
        {
            width: 223px;
            text-align: left;
            height: 36px;
        }
        .style4
        {
            height: 36px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="style1" dir="rtl">
        <tr>
            <td class="style2">
                <asp:Label ID="Label1" runat="server" Font-Bold="True" 
                    Font-Names="Times New Roman" Font-Size="Large" style="text-align: left" 
                    Text="كلمة المرور القديمة :"></asp:Label>
            </td>
            <td style="text-align: right">
                <asp:TextBox ID="TextBox1" runat="server" TextMode="Password" Width="350px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="style3">
                <asp:Label ID="Label2" runat="server" Font-Bold="True" 
                    Font-Names="Times New Roman" Font-Size="Large" Text="كلمة المرور الجديدة :"></asp:Label>
            </td>
            <td class="style4">
                <asp:TextBox ID="TextBox2" runat="server" TextMode="Password" Width="350px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="style3">
                <asp:Label ID="Label3" runat="server" Font-Bold="True" 
                    Font-Names="Times New Roman" Font-Size="Large" 
                    Text="تأكيد كلمة المرور الجديدة :"></asp:Label>
            </td>
            <td class="style4">
                <asp:TextBox ID="TxtDate" runat="server" TextMode="Password" Width="350px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="style2">
                &nbsp;</td>
            <td>
                <asp:LinkButton ID="LinkButton1" runat="server" Font-Bold="True" 
                    Font-Names="Times New Roman" Font-Size="Large" 
                    style="font-weight: 700; text-align: center; font-size: x-large">حفظ</asp:LinkButton>
&nbsp;&nbsp;&nbsp; <asp:Label ID="LblErr" runat="server" ForeColor="Red" 
                    style="font-family: 'Times New Roman', Times, serif; font-size: large; font-weight: 700; text-align: right"></asp:Label>
                </td>
        </tr>
    </table>
</asp:Content>

