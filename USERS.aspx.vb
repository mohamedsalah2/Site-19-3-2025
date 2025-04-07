
Partial Class Users
    Inherits System.Web.UI.Page

    Public SumClass1 As New SumClass
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        SumClass1.Session_logout()
        If Session("PRMTION") = 2 Then
            HttpContext.Current.Response.Redirect("~/login.aspx")
            Session.Clear()
        End If
    End Sub

    Protected Sub Show_PWD_Click(sender As Object, e As System.EventArgs) Handles Show_PWD.Click
        GridView1.Columns(3).Visible = True
        GridView1.Columns(5).Visible = True
        GridView1.DataBind()

    End Sub


    Protected Sub Hide_PWD_Click(sender As Object, e As System.EventArgs) Handles Hide_PWD.Click
        GridView1.Columns(3).Visible = False
        GridView1.Columns(5).Visible = False
        GridView1.DataBind()

    End Sub
End Class
