Imports System.Globalization

Partial Class Inventory
    Inherits System.Web.UI.Page
    Public SumClass1 As New SumClass
    Dim dob As DateTime

    Protected Sub CLR()

        Txt_FileID.Text = SumClass1.MaxIDFiles() + 1
        Txt_FileSubject.Text = ""
        Txt_File_Content.Text = ""
        Txt_Notes.Text = ""

        If Not Page.IsPostBack Then
            'لعدم تكرار حفظ الصف عند عمل ريفريش
            Response.Redirect(Request.Url.AbsoluteUri)
        End If
    End Sub

    Protected Sub Btn_Save_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Btn_Save.Click
        Try
            If Txt_FileSubject.Text = "" Or Txt_File_Content.Text = "" Then
                'If Txt_Subject.Text = "" Then
                ClientScript.RegisterClientScriptBlock(Me.GetType, "ExceptionMessage", "<script type='text/JavaScript'>alert('   برجاء ادخال البيانات الاساسيه!');</script>")
            Else
                'dob = DateTime.Parse(Request.Form(TxtDate.UniqueID))
                'dob = DateTime.ParseExact(TxtDate.Text.ToString(), "dd/MM/yyyy", CultureInfo.InvariantCulture)
                dob = Convert.ToDateTime(TxtDate.Text, System.Globalization.CultureInfo.GetCultureInfo("ar-Eg"))
                SumClass1.Insert_Files(SumClass1.MaxIDFiles() + 1, dob, SumClass1.MaxIDFiles() + 1, Txt_FileSubject.Text, Txt_File_Content.Text, Drop_Responsible.SelectedValue, Txt_Notes.Text)
                GridView1.DataBind()
                CLR()
                ClientScript.RegisterClientScriptBlock(Me.GetType, "ExceptionMessage", "<script type='text/JavaScript'>alert('تم الحفظ بنجاح برقم موضوع');</script>")
            End If

        Catch ex As Exception
            'MsgBox("!  هذا الرقم المسلسل تم تسجيله من قبلSerial Number")
            'ClientScript.RegisterClientScriptBlock(Me.GetType, "ExceptionMessage", "<script type='text/JavaScript'>alert('!  هذا الرقم المسلسل تم تسجيله من قبلSerial Number');</script>")
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SumClass1.Session_logout()

        If Not Page.IsPostBack Then
            'TxtDate.Text = Format(Now.Date, "dd/MM/yyyy")
            dob = Convert.ToDateTime(Now, System.Globalization.CultureInfo.GetCultureInfo("ar-Eg"))
            TxtDate.Text = Format(dob, "dd/MM/yyyy")
            Txt_FileID.Text = SumClass1.MaxIDFiles() + 1

            GridView1.DataSourceID = "Entry_DataSource"
            GridView1.DataBind()

            Drop_Responsible.DataBind()
            If Drop_Responsible.Items.Count > 0 Then
                If Drop_Responsible.Items.Contains(New ListItem(Session("UsrName").ToString)) Then
                    Drop_Responsible.SelectedValue = Session("UsrName").ToString
                End If
            End If
            If Session("PRMTION") = 1 Then
                Txt_Password.Visible = True
            End If
        End If
        Txt_IPAddress.Text = SumClass.GetIP4Address()

        'TxtDate.Text = Now
        'TxtDate.Text = Date.Today
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.RowIndex = 0 Then e.Row.Style.Add("height", "50px")
        End If

        'If e.Row.RowType <> DataControlRowType.DataRow Then
        '    Return
        'End If
        'Dim updateButton = CType(e.Row.Cells(0).Controls(0), LinkButton)
        'If updateButton.Text = "Update" Then
        '    updateButton.OnClientClick = "return confirm('Do you really want to update?');"
        'End If
        'Dim deleteButton As LinkButton = CType(e.Row.FindControl("LinkButtonID"), LinkButton)
        ''Dim deleteButton = CType(e.Row.Cells(0).Controls(2), LinkButton)
        'If deleteButton.Text = "حذف" Then
        '    deleteButton.OnClientClick = "return confirm('Do you really want to delete? محمد');"
        'End If

        'Dim deleteButton As LinkButton = TryCast(e.Row.Cells(22).Controls(0), LinkButton)
        'If deleteButton IsNot Nothing Then
        '    deleteButton.OnClientClick = "return confirm('محمد');"
        'End If

    End Sub


    'Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ShowDate_BTN.Click
    '    'Dim dob As DateTime = DateTime.Parse(Request.Form(TxtDate.UniqueID))
    '    'ClientScript.RegisterClientScriptBlock(Me.GetType(), "ExceptionMessage", "<script type='text/JavaScript'>alert('Date: " + dob.ToShortDateString() + "\\nTime: " + dob.ToShortTimeString() + "');", True)

    '    dob = DateTime.Parse(TxtDate.Text)
    '    dob = Convert.ToDateTime(TxtDate.Text, System.Globalization.CultureInfo.GetCultureInfo("ar-Eg"))
    '    'dob = Convert.ToDateTime(TxtDate.Text)
    '    'dob = DateTime.ParseExact(TxtDate.Text, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture)

    '    ClientScript.RegisterStartupScript(Me.GetType, "alert", ("alert('Date: " + (dob.ToShortDateString + ("\" & vbLf & "Time: " _
    '             + (dob.ToShortTimeString + "');")))), True)
    'End Sub

    Protected Sub Btn_Search_Click(sender As Object, e As EventArgs) Handles Btn_Search.Click
        GridView1.DataSourceID = "InvSearch"
        GridView1.DataBind()
    End Sub


    Protected Sub GridView1_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        '    If Txt_Password.Text = "Sabry" Then

        '    Else

        '    End If

        '    ClientScript.RegisterClientScriptBlock(Me.GetType, "ExceptionMessage", "<script type='text/JavaScript'>alert('تم الحذف بنجاح');</script>")



        'If e.Row.RowType = DataControlRowType.DataRow Then
        '    ' loop all data rows
        '    For Each cell As DataControlFieldCell In e.Row.Cells
        '        ' check all cells in one row
        '        For Each control As Control In cell.Controls
        '            ' Must use LinkButton here instead of ImageButton
        '            ' if you are having Links (not images) as the command button.
        '            Dim button As LinkButton = TryCast(control, LinkButton)
        '            If button IsNot Nothing AndAlso button.CommandName = "Delete" Then
        '                ' Add delete confirmation
        '                button.OnClientClick = "return confirm('Are you sure " + "you want to delete this record?');"
        '            End If
        '        Next
        '    Next
        'End If
    End Sub


End Class
