<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LOGIN.aspx.vb" Inherits="LOGIN" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>مشروع اداره اعمال محور شئون المناطق </title>
    <link rel="stylesheet" href="style.css" type="text/css" charset="utf-8" />
    <style type="text/css">
        .style1
        {
            font-family: "Times New Roman" , Times, serif;
            font-size: medium;
        }
        .style2
        {
            width: 100%;
            border: 0px solid #99CCFF;
            background-color: #99CCFF;
        }
        .style4
        {
            text-align: center;
        }
        .style5
        {
            text-align: center;
        }
        .style6
        {
            text-align: center;
        }
        .style7
        {
            text-align: center;
            height: 41px;
        }
        .style8
        {
            font-weight: bold;
            font-size: medium;
        }
    </style>
</head>
<img src="images/Logo.jpg" style="width: 100%; height: 419px" alt="Smiley face" />
<body style="background-color: #99CCFF">
    <form id="form1" runat="server" defaultbutton="linkbutton1" dir="ltr">
    <div id="wrapper">
        <div id="headline" style="background-color: #99CCFF">
            <table class="style2" dir="rtl">
                <tr>
                    <td class="style5" style="background-color: #99CCFF; font-size: xx-large; color: #0000FF; font-weight: bold;" dir="rtl">
                        &nbsp;&nbsp; مشروع اداره اعمال محور شئون المناطق</td>
                    <td style="background-color: #99CCFF">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="style6" colspan="2" style="background-color: #99CCFF">
                        <asp:Label ID="Label3" runat="server" Style="font-size: large; font-family: 'Times New Roman', Times, serif;
                            font-weight: bold; text-align: left;" Text="إسم المستخدم :"></asp:Label>
                        <asp:TextBox ID="TextBox1" runat="server" Width="300px" CssClass="style1"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="style7" colspan="2" style="background-color: #99CCFF">
                        <asp:Label ID="Label4" runat="server" Style="font-size: large; font-family: 'Times New Roman', Times, serif;
                            font-weight: bold; text-align: left;" Text="كلمة المـــرور :"></asp:Label>
                        <asp:TextBox ID="TextBox2" runat="server" Width="300px" TextMode="Password" CssClass="style1"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="style5" colspan="2" style="background-color: #99CCFF">
                        <asp:LinkButton ID="LinkButton1" runat="server" Font-Bold="True" Font-Names="Times New Roman"
                            Font-Size="XX-Large">دخــول</asp:LinkButton>
                    </td>
                </tr>
                <tr>
                    <td class="style4" colspan="2" style="background-color: #99CCFF">
                        <asp:Label ID="LblErr" runat="server" ForeColor="Red" Style="font-family: 'Times New Roman', Times, serif;
                            font-size: large; font-weight: 700; text-align: right"></asp:Label>
                    </td>
                </tr>
            </table>
            <p style="text-align: center">
                <b>Server IP:</b><asp:Label ID="Txt_IPAddress" runat="server" Font-Bold="True" Font-Size="16pt" ForeColor="Red" Width="142px" CssClass="style8"></asp:Label>
            </p>
            <p style="text-align: center">
                <b>
                <asp:Label ID="Label5" runat="server" Text="Clinet IP:" Visible="False"></asp:Label>
                </b><asp:Label ID="Txt_IPAddress1" runat="server" Font-Bold="True" Font-Size="16pt" ForeColor="Red" Width="142px" CssClass="style8" Visible="False"></asp:Label>
            </p>
        </div>
    </div>
    </form>
</body>
</html>
