Imports System.Data.SqlClient
Imports System.Data

Partial Class OffceBlnce
    Inherits System.Web.UI.Page
    Public SumClass1 As New SumClass
    Public constr As String = (ConfigurationManager.ConnectionStrings("Post").ToString)
    Public Conn As New SqlConnection(constr)
    Dim OfceData_DT As New DataTable

    Public Sub Load_OfceData(ByVal Zone As String, ByVal OfceName As String)
        OfceData_DT.Clear()
        Dim CMD As New SqlCommand("Select * From OFFICES WHERE zone=@zone AND OfficeName=@OfceName", Conn)
        CMD.Parameters.Add("Zone", SqlDbType.VarChar).Value = Zone
        CMD.Parameters.Add("OfceName", SqlDbType.VarChar).Value = OfceName
        If Conn.State = ConnectionState.Open Then Conn.Close()
        Conn.Open()
        OfceData_DT.Load(CMD.ExecuteReader)
        Conn.Close()
        CMD = Nothing
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

       SumClass1.Session_logout()

        If Not Page.IsPostBack Then
            DropZone.SelectedValue = 6

            '       Load_OfceData(DropZone.SelectedValue, TxtOfceName.Text)
        End If

        If Session("PRMTION") = "1" Then
            Panel_Save.Visible = True
            Save_Btn.Visible = True

        End If

        SumClass1.Session_logout()
    End Sub


    Protected Sub Save_Btn_Click(sender As Object, e As System.EventArgs) Handles Save_Btn.Click
        SumClass1.Insert_OFFICES(SumClass1.MaxIDOffice() + 1, DropZone.SelectedItem.Text, TxtOfceName.Text, 0, TxtOfceManager.Text, DropZone.SelectedValue, TxtOfceManager.Text)
        ClientScript.RegisterClientScriptBlock(Me.GetType, "ExceptionMessage", "<script type='text/JavaScript'>alert('!تم الحفظ بنجاح');</script>")
        DgvOfce.DataBind()

    End Sub

End Class
