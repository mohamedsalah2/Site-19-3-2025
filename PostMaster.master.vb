
Partial Class PostMaster
    Inherits System.Web.UI.MasterPage
    Public valuePath As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        LblUserName.Text = "إسم المستخدم : " + Session("UsrName")
        prmtion()

    End Sub

    'الصلاحيات
    Public Sub prmtion()

        Select Case Session("PRMTION")
            Case Session("PRMTION") = 1
                Usrs.Enabled = True
                RPT.Enabled = True
            Case Is = 2
                'Invntry.Enabled = True
                'DailyAcc.Enabled = True
        End Select

    End Sub

    Protected Sub LinkButton2_Click(sender As Object, e As System.EventArgs) Handles LinkButton2.Click

        Session.Clear()
        Session.RemoveAll()
        Session.Abandon()
    End Sub

End Class

