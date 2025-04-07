
Partial Class Main
    Inherits System.Web.UI.Page

    Public SumClass1 As New SumClass

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        SumClass1.Session_logout()
    End Sub
End Class
