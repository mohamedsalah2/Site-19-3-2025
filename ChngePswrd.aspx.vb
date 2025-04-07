Imports System.Data.SqlClient
Imports System.Data

Partial Class ChngePswrd
    Inherits System.Web.UI.Page
    Public constr As String = (ConfigurationManager.ConnectionStrings("Post").ToString)
    Public Conn As New SqlConnection(constr)
    Public SumClass1 As New SumClass

    Public Sub Update_USERS(ByVal PWD As String, ByVal ID2 As Int32)

        Dim CMD As New SqlCommand("Update USERS Set PWD =@PWD Where ID= @ID2", Conn)
        With CMD.Parameters
            .Add("PWD", SqlDbType.VarChar).Value = PWD
            .Add("ID2", SqlDbType.Int).Value = ID2
        End With

        If Conn.State = ConnectionState.Open Then Conn.Close()
        Conn.Open()
        CMD.ExecuteNonQuery()
        Conn.Close()
        CMD = Nothing
    End Sub

    Protected Sub LinkButton1_Click(sender As Object, e As System.EventArgs) Handles LinkButton1.Click

        If TextBox1.Text <> Session("PWD") Then

            LblErr.Text = "كلمة المرور القديمة خاطئة"
            Me.TextBox1.Text = ""
            Me.TextBox2.Text = ""
            Me.TxtDate.Text = ""

            TextBox1.Focus()
            Exit Sub
        End If

        If Val(TextBox2.Text) = Val(TxtDate.Text) Then

            Update_USERS(TextBox2.Text, Session("ID"))
            LblErr.Text = "تم تغيير كلمة المرور بنجاح"
            Response.Redirect("login.aspx")
            Session.Clear()

        Else

            Me.TextBox1.Text = ""
            Me.TextBox2.Text = ""
            Me.TxtDate.Text = ""
            TextBox1.Focus()

            LblErr.Text = "كلمة المرور الجديد غير متطابقة"
            Exit Sub
        End If

    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        SumClass1.Session_logout()
    End Sub
End Class
