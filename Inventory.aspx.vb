Imports System.Globalization
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Services
Imports Newtonsoft.Json
Imports System
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Namespace Site
    Public Class Inventory
        Inherits System.Web.UI.Page
        Public SumClass1 As New SumClass
        Dim dob As DateTime

        ' Control declarations with WithEvents
        Protected WithEvents GridView1 As GridView
        Protected WithEvents FileUpload1 As FileUpload
        Protected WithEvents FileUploadMulti As FileUpload
        Protected WithEvents pnlFilePopup As Panel
        Protected WithEvents cblFileListPopup As CheckBoxList
        Protected WithEvents HiddenFieldRecordID As HiddenField
        Protected WithEvents hdnEditRecordID As HiddenField
        Protected WithEvents rblDownloadOption As RadioButtonList
        Protected WithEvents Btn_Save As Button
        Protected WithEvents Btn_Search As Button
        Protected WithEvents Txt_Password As TextBox
        Protected WithEvents Txt_IPAddress As TextBox

        ' Form controls
        Protected WithEvents Txt_SubjectID As TextBox
        Protected WithEvents TxtDate As TextBox
        Protected WithEvents Txt_Subject As TextBox
        Protected WithEvents Txt_Authority As TextBox
        Protected WithEvents Txt_PostalCode As TextBox
        Protected WithEvents Txt_EmpNo As TextBox
        Protected WithEvents Txt_EmpName As TextBox
        Protected WithEvents Txt_InTashira As TextBox
        Protected WithEvents Txt_OutTashira As TextBox
        Protected WithEvents Txt_Aditional_Tashira As TextBox
        Protected WithEvents Txt_Action_Taken As TextBox
        Protected WithEvents Txt_Notes As TextBox
        Protected WithEvents Txt_Attach1 As TextBox
        Protected WithEvents TXT_incoming_From As TextBox

        ' Dropdown controls
        Protected WithEvents Drop_Responsible As DropDownList
        Protected WithEvents Drop_IncomType As DropDownList
        Protected WithEvents Drop_Subject As DropDownList
        Protected WithEvents Drop_Time As DropDownList
        Protected WithEvents Drop_Subject_Status As DropDownList
        Protected WithEvents Drop_Aditional_Actions As DropDownList
        Protected WithEvents Work_Area As DropDownList

        ' Edit controls
        Protected WithEvents ddlEditResponsible As DropDownList
        Protected WithEvents ddlEditIncomingType As DropDownList
        Protected WithEvents ddlEditSubject As DropDownList
        Protected WithEvents ddlEditWorkArea As DropDownList
        Protected WithEvents Drop_Time0 As DropDownList
        Protected WithEvents Drop_Subject_Status0 As DropDownList
        Protected WithEvents Drop_Aditional_Actions0 As DropDownList

        ' SqlDataSource controls
        Protected WithEvents ResponsibleSqlDataSource As SqlDataSource
        Protected WithEvents Subject_RelateSqlDataSource As SqlDataSource

        ' Additional fields
        Protected WithEvents Followup3 As TextBox

        Private Sub CLR()
            ' Clear all textboxes except TxtDate
            ClearTextBoxesRecursive(Me.Form)

            ' Set the new subject ID
            Try
                Txt_SubjectID.Text = (SumClass1.MaxSubjectID() + 1).ToString()
            Catch ex As Exception
                ' Log the error and set a default value
                Trace.Warn("Error in CLR()", "Failed to get MaxSubjectID: " & ex.Message)
                Txt_SubjectID.Text = "1"
            End Try
        End Sub

        Private Sub ClearTextBoxesRecursive(parent As Control)
            For Each ctrl As Control In parent.Controls
                If TypeOf ctrl Is TextBox AndAlso ctrl.ID <> "TxtDate" Then
                    DirectCast(ctrl, TextBox).Text = String.Empty
                ElseIf ctrl.HasControls() Then
                    ClearTextBoxesRecursive(ctrl)
                End If
            Next
        End Sub

        Protected Sub Btn_Save_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Btn_Save.Click
            Try
                If String.IsNullOrEmpty(Txt_Authority.Text) Or String.IsNullOrEmpty(Txt_Subject.Text) Then
                    ClientScript.RegisterClientScriptBlock(Me.GetType, "ExceptionMessage", "<script type='text/JavaScript'>alert('برجاء ادخال البيانات الاساسيه!');</script>")
                    Return
                End If

                UploadFiles(FileUpload1, Txt_Attach1)
                Dim commaSeparatedFileNames As String = ConvertTextToCommaSeparated(Txt_Attach1.Text)
                Txt_Attach1.Text = commaSeparatedFileNames
                dob = Convert.ToDateTime(TxtDate.Text, CultureInfo.GetCultureInfo("ar-Eg"))

                SumClass1.Insert_Inventory(
                    SumClass1.MaxIDInv() + 1, dob, Drop_Responsible.SelectedValue, Drop_IncomType.SelectedValue, Txt_PostalCode.Text, Txt_Authority.Text, Txt_EmpNo.Text,
                    Txt_EmpName.Text, Txt_SubjectID.Text, Drop_Subject.SelectedValue, Txt_Subject.Text, Txt_InTashira.Text, Txt_OutTashira.Text, TXT_incoming_From.Text,
                    Txt_Action_Taken.Text, Drop_Aditional_Actions.SelectedValue, Drop_Time.SelectedValue, Txt_Aditional_Tashira.Text, Drop_Subject_Status.SelectedValue,
                    Txt_Notes.Text, Work_Area.SelectedValue, Txt_Attach1.Text, Followup3.Text)

                GridView1.DataBind()
                CLR()
                ClientScript.RegisterClientScriptBlock(Me.GetType(), "SuccessMessage", "<script type='text/javascript'>alert('تم الحفظ بنجاح برقم موضوع: " & SumClass1.MaxSubjectID() & "');</script>")
            Catch ex As Exception
                Trace.Warn("Error in Btn_Save_Click", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                ClientScript.RegisterClientScriptBlock(Me.GetType(), "ErrorMessage", "<script type='text/javascript'>alert('حدث خطأ أثناء حفظ البيانات. يرجى المحاولة مرة أخرى.');</script>")
            End Try
        End Sub

        Private Function ConvertTextToCommaSeparated(text As String) As String
            Dim fileNames As String() = text.Split(New String() {Environment.NewLine}, StringSplitOptions.RemoveEmptyEntries)
            Return String.Join(",", fileNames)
        End Function

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Try
                SumClass1.Session_logout()

                If Not Page.IsPostBack Then
                    InitializeEditControls()
                    dob = Convert.ToDateTime(Now, CultureInfo.GetCultureInfo("ar-Eg"))
                    TxtDate.Text = Format(dob, "dd/MM/yyyy")
                    Txt_SubjectID.Text = (SumClass1.MaxSubjectID() + 1).ToString()

                    GridView1.DataSourceID = "Entry_DataSource"
                    GridView1.DataBind()

                    Drop_Responsible.DataBind()
                    If Drop_Responsible.Items.Count > 0 AndAlso Drop_Responsible.Items.Contains(New ListItem(Session("UsrName").ToString())) Then
                        Drop_Responsible.SelectedValue = Session("UsrName").ToString()
                        Work_Area.SelectedValue = Session("work_area").ToString()
                        Work_Area.DataBind()
                    End If

                    If Session("PRMTION") = 1 Then
                        Txt_Password.Visible = True
                    End If
                End If

                Txt_IPAddress.Text = SumClass.GetIP4Address()
            Catch ex As Exception
                Trace.Warn("Error in Page_Load", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
            End Try
        End Sub

        Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
            If e.Row.RowType = DataControlRowType.DataRow Then
                If e.Row.RowIndex = 0 Then
                    e.Row.Style.Add("height", "50px")
                End If

                Dim selectedWork_Area As String = Work_Area.SelectedValue
                Dim rowWork_Area As String = DataBinder.Eval(e.Row.DataItem, "Work_Area").ToString()

                If rowWork_Area <> selectedWork_Area AndAlso Session("PRMTION") = 2 Then
                    e.Row.BackColor = System.Drawing.Color.Aquamarine
                    Dim btnDelete As LinkButton = TryCast(e.Row.FindControl("LinkButton4"), LinkButton)
                    If btnDelete IsNot Nothing Then
                        btnDelete.Enabled = False
                        btnDelete.ForeColor = System.Drawing.Color.Gray
                        btnDelete.OnClientClick = "return false;"
                    End If
                End If
            End If
        End Sub

        Protected Sub Txt_PostalCode_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Txt_PostalCode.TextChanged
            Txt_PostalCode.Text = Txt_PostalCode.Text.ToUpper()
        End Sub

        Protected Sub Btn_Search_Click(sender As Object, e As EventArgs) Handles Btn_Search.Click
            GridView1.DataSourceID = "InvSearch"
            GridView1.DataBind()
        End Sub

        Protected Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Select Case e.CommandName
                Case "Download" : HandleDownloadCommand(e)
                Case "DeleteAttachment" : HandleDeleteAttachmentCommand(e)
                Case "Upload" : HandleUploadCommand(e)
                Case "Edit" : HandleEditCommand(e)
                Case "Delete" : pnlFilePopup.Visible = False
            End Select
            GridView1.DataBind()
        End Sub

        Private Sub HandleDownloadCommand(e As GridViewCommandEventArgs)
            Dim fileNames As String = e.CommandArgument.ToString().Trim()
            Dim fileList As List(Of String) = fileNames.Split(","c).ToList()

            Dim btn As ImageButton = TryCast(e.CommandSource, ImageButton)
            If btn IsNot Nothing Then
                Dim row As GridViewRow = TryCast(btn.NamingContainer, GridViewRow)
                Dim rowIndex As Integer = row.RowIndex
                Dim recordID As String = GridView1.DataKeys(rowIndex).Value.ToString()

                HiddenFieldRecordID.Value = recordID
                DisplayFileSelectionPopup(fileList)
            End If
        End Sub

        Private Sub HandleDeleteAttachmentCommand(e As GridViewCommandEventArgs)
            Dim row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
            Dim recordID As String = GridView1.DataKeys(row.RowIndex).Value.ToString()

            Dim connStr As String = ConfigurationManager.ConnectionStrings("post_DBConnectionString").ConnectionString
            Dim fileNames As String = ""

            Using conn As New SqlConnection(connStr)
                conn.Open()
                Dim query As String = "SELECT Attach1 FROM Inventory WHERE ID = @ID"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@ID", recordID)
                    Dim result As Object = cmd.ExecuteScalar()
                    If result IsNot Nothing Then
                        fileNames = result.ToString()
                    End If
                End Using
            End Using

            If Not String.IsNullOrEmpty(fileNames) Then
                Dim files As String() = fileNames.Split(","c)
                For Each file As String In files
                    Dim filePath As String = Server.MapPath("~/Attachments/" & file.Trim())
                    If System.IO.File.Exists(filePath) Then
                        System.IO.File.Delete(filePath)
                    End If
                Next
            End If

            Using conn As New SqlConnection(connStr)
                conn.Open()
                Dim query As String = "UPDATE Inventory SET Attach1 = NULL WHERE ID = @ID"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@ID", recordID)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            GridView1.DataBind()
        End Sub

        Private Sub HandleUploadCommand(e As GridViewCommandEventArgs)
            Dim btn As LinkButton = TryCast(e.CommandSource, LinkButton)
            If btn IsNot Nothing Then
                Dim row As GridViewRow = TryCast(btn.NamingContainer, GridViewRow)
                Dim recordID As String = GridView1.DataKeys(row.RowIndex).Value.ToString()
                HiddenFieldRecordID.Value = recordID

                Dim currentAttach1Value As String = GetAttach1FileNames(recordID)
                pnlFilePopup.Style("display") = "block"

                Dim fileUpload As FileUpload = TryCast(row.FindControl("FileUploadMulti"), FileUpload)
                If fileUpload IsNot Nothing AndAlso fileUpload.HasFiles Then
                    Dim uploadedFiles As New List(Of String)()
                    
                    For Each file As HttpPostedFile In fileUpload.PostedFiles
                        If file.ContentLength > 0 Then
                            ' Validate file size (e.g., 10MB limit)
                            If file.ContentLength > 10485760 Then ' 10MB in bytes
                                ClientScript.RegisterStartupScript(Me.GetType(), "FileTooLarge", 
                                    "alert('File " & file.FileName & " is too large. Maximum size is 10MB.');", True)
                                Continue For
                            End If

                            ' Validate file type
                            Dim extension As String = Path.GetExtension(file.FileName).ToLower()
                            Dim allowedExtensions As String() = {".pdf", ".doc", ".docx", ".xls", ".xlsx", ".txt", ".jpg", ".jpeg", ".png"}
                            If Not allowedExtensions.Contains(extension) Then
                                ClientScript.RegisterStartupScript(Me.GetType(), "InvalidFileType", 
                                    "alert('File " & file.FileName & " has an invalid file type.');", True)
                                Continue For
                            End If

                            Dim fileName As String = ProcessUploadedFile(file)
                            If Not String.IsNullOrEmpty(fileName) Then
                                uploadedFiles.Add(fileName)
                            End If
                        End If
                    Next

                    If uploadedFiles.Count > 0 Then
                        Dim newAttachments As String = If(String.IsNullOrEmpty(currentAttach1Value), "", currentAttach1Value & ",") & String.Join(",", uploadedFiles)
                        UpdateAttach1FileNamesInDatabase(recordID, newAttachments)
                        ClientScript.RegisterStartupScript(Me.GetType(), "FilesUploaded", "alert('Files uploaded successfully.');", True)
                        LoadFileListFromDatabase(recordID)
                    End If
                End If
                pnlFilePopup.Style("display") = "block"
            End If
        End Sub

        Private Function ProcessUploadedFile(file As HttpPostedFile) As String
            Try
                Dim uploadFolder As String = Server.MapPath("~/Attachments/")
                If Not Directory.Exists(uploadFolder) Then
                    Directory.CreateDirectory(uploadFolder)
                End If

                Dim originalFileName As String = Path.GetFileNameWithoutExtension(file.FileName)
                Dim fileExtension As String = Path.GetExtension(file.FileName)
                Dim uniqueFileName As String = originalFileName & "_" & DateTime.Now.ToString("yyyyMMddHHmmss") & fileExtension
                Dim savePath As String = Path.Combine(uploadFolder, uniqueFileName)

                ' Ensure filename uniqueness
                Dim counter As Integer = 1
                While System.IO.File.Exists(savePath)
                    uniqueFileName = String.Format("{0}_{1}_{2}{3}", originalFileName, DateTime.Now.ToString("yyyyMMddHHmmss"), counter, fileExtension)
                    savePath = Path.Combine(uploadFolder, uniqueFileName)
                    counter += 1
                End While

                file.SaveAs(savePath)
                Return uniqueFileName
            Catch ex As Exception
                Trace.Warn("Error in ProcessUploadedFile", ex.Message)
                Return String.Empty
            End Try
        End Function

        Private Sub UpdateAttach1FileNamesInDatabase(rowId As Integer, updatedFileNames As String)
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString
            Dim query As String = "UPDATE Inventory SET Attach1 = @Attach1 WHERE ID = @ID"

            Using conn As New SqlConnection(connectionString)
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@Attach1", updatedFileNames)
                    cmd.Parameters.AddWithValue("@ID", rowId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
        End Sub

        Private Function GetAttach1FileNames(recordID As String) As String
            Dim fileNames As String = String.Empty
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString
            Dim query As String = "SELECT Attach1 FROM Inventory WHERE ID = @ID"

            Using conn As New SqlConnection(connectionString)
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@ID", recordID)
                    conn.Open()
                    Dim result = cmd.ExecuteScalar()
                    If result IsNot Nothing Then
                        fileNames = result.ToString()
                    End If
                    conn.Close()
                End Using
            End Using

            Return fileNames
        End Function

        Protected Sub DisplayFileSelectionPopup(fileList As List(Of String))
            cblFileListPopup.DataSource = fileList
            cblFileListPopup.DataBind()
            pnlFilePopup.Style("display") = "block"
        End Sub

        Protected Sub btnClosePopup_Click(sender As Object, e As EventArgs)
            Dim script As String = "document.getElementById('" & pnlFilePopup.ClientID & "').style.display = 'none';"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ClosePopup", script, True)
            cblFileListPopup.Items.Clear()
        End Sub

        Protected Sub btnUploadFiles_Click(sender As Object, e As EventArgs)
            If String.IsNullOrEmpty(HiddenFieldRecordID.Value) Then
                ClientScript.RegisterStartupScript(Me.GetType(), "NoRecordSelected", "alert('Please select a record to upload files.');", True)
                Return
            End If

            Dim uploadFolder As String = Server.MapPath("~/Attachments/")
            If Not Directory.Exists(uploadFolder) Then
                Directory.CreateDirectory(uploadFolder)
            End If

            If FileUploadMulti.HasFiles Then
                Dim uploadedFiles As New List(Of String)()
                For Each file As HttpPostedFile In FileUploadMulti.PostedFiles
                    If file.ContentLength > 0 Then
                        Dim originalFileName As String = Path.GetFileNameWithoutExtension(file.FileName)
                        Dim fileExtension As String = Path.GetExtension(file.FileName)
                        Dim uniqueFileName As String = originalFileName & fileExtension
                        Dim savePath As String = Path.Combine(uploadFolder, uniqueFileName)
                        Dim counter As Integer = 1
                        While System.IO.File.Exists(savePath)
                            uniqueFileName = originalFileName & "_" & DateTime.Now.ToString("dd-MM-yyyy_HHmm") & "_" & counter.ToString() & fileExtension
                            savePath = Path.Combine(uploadFolder, uniqueFileName)
                            counter += 1
                        End While
                        file.SaveAs(savePath)
                        uploadedFiles.Add(uniqueFileName)
                    End If
                Next

                If uploadedFiles.Count > 0 Then
                    Dim currentAttach1Value As String = GetAttach1FileNames(HiddenFieldRecordID.Value)
                    Dim newAttachments As String = String.Join(",", uploadedFiles)
                    If Not String.IsNullOrEmpty(currentAttach1Value) Then
                        newAttachments = currentAttach1Value & "," & newAttachments
                    End If
                    UpdateAttach1FileNamesInDatabase(HiddenFieldRecordID.Value, newAttachments)
                    ClientScript.RegisterStartupScript(Me.GetType(), "FilesUploaded", "alert('Files uploaded successfully.');", True)
                    LoadFileListFromDatabase(HiddenFieldRecordID.Value)
                End If
            Else
                ClientScript.RegisterStartupScript(Me.GetType(), "NoFilesUploaded", "alert('No files were selected for upload.');", True)
            End If
            GridView1.DataBind()
        End Sub

        Protected Sub btnDownloadSelectedPopup_Click(sender As Object, e As EventArgs)
            Dim selectedFiles As New List(Of String)()
            Dim missingFiles As New List(Of String)()

            For Each item As ListItem In cblFileListPopup.Items
                If item.Selected Then
                    Dim filePath As String = "~/Attachments/" & item.Value
                    Dim serverFilePath As String = Server.MapPath(filePath)
                    If File.Exists(serverFilePath) Then
                        selectedFiles.Add(filePath)
                    Else
                        missingFiles.Add(item.Value)
                    End If
                End If
            Next

            If missingFiles.Count > 0 Then
                Dim missingFilesMessage As String = "The following files do not exist: " & String.Join(", ", missingFiles)
                Dim script As String = "alert('" & missingFilesMessage.Replace("'", "\'") & "');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "MissingFilesAlert", script, True)
                Dim showPopupScript As String = "document.getElementById('" & pnlFilePopup.ClientID & "').style.display = 'block';"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup", showPopupScript, True)
                Return
            End If

            If selectedFiles.Count > 0 Then
                Dim downloadOption As String = rblDownloadOption.SelectedValue
                If downloadOption = "Individual" Then
                    Dim fileUrls As String = String.Join(",", selectedFiles.Select(Function(file) ResolveUrl(file)))
                    Dim script As String = "setTimeout(function() { downloadFiles('" & fileUrls & "'); }, 0);"
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "downloadFiles", script, True)
                ElseIf downloadOption = "Zip" Then
                    Dim tempFolderPath As String = Server.MapPath("~/Temp")
                    Dim tempZipPath As String = Path.Combine(tempFolderPath, "SelectedFiles.zip")
                    If Not Directory.Exists(tempFolderPath) Then
                        Directory.CreateDirectory(tempFolderPath)
                    End If
                    If File.Exists(tempZipPath) Then
                        File.Delete(tempZipPath)
                    End If
                    Using zip As New Ionic.Zip.ZipFile(System.Text.Encoding.UTF8)
                        For Each fileName In selectedFiles
                            Dim filePath As String = Server.MapPath(fileName)
                            If File.Exists(filePath) Then
                                zip.AddFile(filePath, "").FileName = Path.GetFileName(fileName)
                            End If
                        Next
                        zip.Save(tempZipPath)
                    End Using
                    Response.Clear()
                    Response.ContentType = "application/zip"
                    Response.AddHeader("Content-Disposition", "attachment; filename=""" & HttpUtility.UrlPathEncode("SelectedFiles.zip") & """")
                    Response.TransmitFile(tempZipPath)
                    Response.End()
                End If
            Else
                Dim script As String = "alert('Please select at least one file to download.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NoFilesSelectedAlert", script, True)
                Dim showPopupScript As String = "document.getElementById('" & pnlFilePopup.ClientID & "').style.display = 'block';"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup", showPopupScript, True)
            End If
        End Sub

        Protected Sub btnDeleteSelectedPopup_Click(sender As Object, e As EventArgs)
            If String.IsNullOrEmpty(HiddenFieldRecordID.Value) Then
                Dim script As String = "alert('Please select a record to delete files.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NoRecordSelected", script, True)
                Return
            End If

            Dim selectedFiles As New List(Of String)()
            For Each item As ListItem In cblFileListPopup.Items
                If item.Selected Then
                    selectedFiles.Add(item.Value)
                End If
            Next

            If selectedFiles.Count = 0 Then
                Dim script As String = "alert('Please select at least one file to delete.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NoFilesSelected", script, True)
                Return
            End If

            Dim _connectionString As String = ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ToString()
            Dim currentAttach1Value As String = String.Empty
            Dim deletedFiles As New List(Of String)()

            Try
                Using connection As New SqlConnection(_connectionString)
                    connection.Open()
                    Dim cmdGet As New SqlCommand("SELECT Attach1 FROM Inventory WHERE ID = @ID", connection)
                    cmdGet.Parameters.AddWithValue("@ID", HiddenFieldRecordID.Value)
                    Dim result = cmdGet.ExecuteScalar()
                    If result IsNot DBNull.Value Then
                        currentAttach1Value = Convert.ToString(result)
                    End If
                End Using
            Catch ex As Exception
                Dim script As String = "alert('An error occurred while retrieving file data.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "DatabaseError", script, True)
                Return
            End Try

            If String.IsNullOrEmpty(currentAttach1Value) Then
                Dim script As String = "alert('No files are currently attached to delete.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NoFilesAttached", script, True)
                Return
            End If

            Dim currentFiles As New List(Of String)(currentAttach1Value.Split(","c))
            For Each file As String In selectedFiles
                If currentFiles.Contains(file.Trim()) Then
                    currentFiles.Remove(file.Trim())
                    Dim filePath As String = Server.MapPath("~/Attachments/") & file.Trim()
                    If System.IO.File.Exists(filePath) Then
                        Try
                            System.IO.File.Delete(filePath)
                            deletedFiles.Add(file.Trim())
                        Catch ex As Exception
                            Dim script As String = "alert('Error deleting file: " & file.Trim() & "');"
                            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "FileDeletionError", script, True)
                        End Try
                    End If
                End If
            Next

            Dim updatedAttach1Value As String = String.Join(",", currentFiles)
            Try
                Using connection As New SqlConnection(_connectionString)
                    connection.Open()
                    Dim cmdUpdate As New SqlCommand("UPDATE Inventory SET Attach1 = @Attach1 WHERE ID = @ID", connection)
                    cmdUpdate.Parameters.AddWithValue("@Attach1", updatedAttach1Value)
                    cmdUpdate.Parameters.AddWithValue("@ID", HiddenFieldRecordID.Value)
                    cmdUpdate.ExecuteNonQuery()
                End Using
                Dim scriptSuccess As String = "alert('Selected files have been deleted from the record.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "FilesDeleted", scriptSuccess, True)
                LoadFileListFromDatabase(HiddenFieldRecordID.Value)
                GridView1.DataBind()
            Catch ex As Exception
                Dim script As String = "alert('An error occurred while updating the file data.');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "UpdateError", script, True)
            End Try
        End Sub

        Private Sub LoadFileListFromDatabase(recordID As String)
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim cmd As New SqlCommand("SELECT Attach1 FROM Inventory WHERE ID = @ID", connection)
                cmd.Parameters.AddWithValue("@ID", recordID)
                Dim attach1Value As String = Convert.ToString(cmd.ExecuteScalar())
                cblFileListPopup.Items.Clear()
                If Not String.IsNullOrEmpty(attach1Value) Then
                    Dim files As String() = attach1Value.Split(","c)
                    For Each file As String In files
                        cblFileListPopup.Items.Add(New ListItem(file.Trim(), file.Trim()))
                    Next
                End If
            End Using
        End Sub

        Private Sub LoadFileList()
            Dim attachmentsFolder As String = Server.MapPath("~/Attachments/")
            Dim files As String() = Directory.GetFiles(attachmentsFolder)
            cblFileListPopup.Items.Clear()
            For Each file As String In files
                Dim fileName As String = Path.GetFileName(file)
                cblFileListPopup.Items.Add(New ListItem(fileName, fileName))
            Next
        End Sub

        Protected Sub ImageButton_Upload_Click(sender As Object, e As EventArgs)
            Dim btn As ImageButton = CType(sender, ImageButton)
            Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)
            Dim fileUpload As FileUpload = CType(row.FindControl("FileUpload1"), FileUpload)

            If fileUpload.HasFiles Then
                For Each file As HttpPostedFile In fileUpload.PostedFiles
                    If file.ContentLength > 0 Then
                        Dim fileName As String = Path.GetFileName(file.FileName)
                        Dim filePath As String = "~/Attachments/" & fileName
                        file.SaveAs(Server.MapPath(filePath))
                        Dim hiddenField As HiddenField = CType(row.FindControl("HiddenField1"), HiddenField)
                        hiddenField.Value = filePath
                        Dim label As Label = CType(row.FindControl("Label_Attach1"), Label)
                        label.Text = fileName
                        label.Visible = True
                    End If
                Next
            End If
        End Sub

        Private Sub UploadFiles(fileUploadControl As FileUpload, textBox As TextBox)
            Try
                Dim uploadFolder As String = Server.MapPath("~/Attachments/")
                If Not Directory.Exists(uploadFolder) Then
                    Directory.CreateDirectory(uploadFolder)
                End If

                textBox.Text = String.Empty

                If fileUploadControl.HasFile Then
                    For i As Integer = 0 To Request.Files.Count - 1
                        Dim file As HttpPostedFile = Request.Files(i)
                        If file.ContentLength > 0 Then
                            ' Validate file size (10MB limit)
                            If file.ContentLength > 10485760 Then
                                ClientScript.RegisterStartupScript(Me.GetType(), "FileTooLarge", 
                                    "alert('الملف كبير جداً. الحد الأقصى المسموح به هو 10 ميجابايت.');", True)
                                Continue For
                            End If

                            ' Validate file type
                            Dim extension As String = Path.GetExtension(file.FileName).ToLower()
                            Dim allowedExtensions As String() = {".pdf", ".doc", ".docx", ".xls", ".xlsx", ".txt", ".jpg", ".jpeg", ".png"}
                            If Not allowedExtensions.Contains(extension) Then
                                ClientScript.RegisterStartupScript(Me.GetType(), "InvalidFileType", 
                                    "alert('نوع الملف غير مسموح به. الأنواع المسموح بها هي: PDF, DOC, DOCX, XLS, XLSX, TXT, JPG, PNG');", True)
                                Continue For
                            End If

                            Dim originalFileName As String = Path.GetFileNameWithoutExtension(file.FileName)
                            Dim fileName As String = originalFileName & "_" & DateTime.Now.ToString("yyyyMMddHHmmss") & extension
                            Dim savePath As String = Path.Combine(uploadFolder, fileName)

                            file.SaveAs(savePath)
                            textBox.Text &= fileName & Environment.NewLine
                        End If
                    Next
                End If
            Catch ex As Exception
                Trace.Warn("Error in UploadFiles", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                ClientScript.RegisterStartupScript(Me.GetType(), "UploadError", 
                    "alert('حدث خطأ أثناء رفع الملفات. يرجى المحاولة مرة أخرى.');", True)
            End Try
        End Sub

        <WebMethod()>
        Public Shared Function CheckPasswordAndPermission(userPassword As String) As Boolean
            Dim isValid As Boolean = False
            Dim sessionPassword As String = TryCast(HttpContext.Current.Session("PWD"), String)
            Dim userPermission As Integer = If(HttpContext.Current.Session("PRMTION"), 0)
            Dim userID As String = TryCast(HttpContext.Current.Session("UsrID"), String)

            If String.IsNullOrEmpty(userID) Or userPermission <> 1 Then
                Return False
            End If

            If Not String.IsNullOrEmpty(sessionPassword) AndAlso sessionPassword.Trim() = userPassword.Trim() Then
                Return True
            End If

            Try
                Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    Dim query As String = "SELECT PWD FROM Users WHERE UsrID = @UserID"
                    Using cmd As New SqlCommand(query, con)
                        cmd.Parameters.AddWithValue("@UserID", userID)
                        con.Open()
                        Dim dbPassword As Object = cmd.ExecuteScalar()
                        con.Close()
                        If dbPassword IsNot Nothing AndAlso String.Equals(dbPassword.ToString().Trim(), userPassword.Trim(), StringComparison.OrdinalIgnoreCase) Then
                            isValid = True
                        End If
                    End Using
                End Using
            Catch ex As Exception
                HttpContext.Current.Trace.Warn("Database Error: " & ex.Message)
            End Try
            Return isValid
        End Function

        Private Sub HandleEditCommand(e As GridViewCommandEventArgs)
            Try
                ' Get the row index from the command argument
                Dim index As Integer = Convert.ToInt32(e.CommandArgument)
                Dim row As GridViewRow = GridView1.Rows(index)
                Dim recordId As String = GridView1.DataKeys(index).Value.ToString()
                
                ' Store the record ID for update
                hdnEditRecordID.Value = recordId

                ' Get the data from the database
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("SELECT * FROM Inventory WHERE ID = @ID", conn)
                        cmd.Parameters.AddWithValue("@ID", recordId)
                        Using dr As SqlDataReader = cmd.ExecuteReader()
                            If dr.Read() Then
                                Try
                                    ' Create a dictionary to store the row data
                                    Dim rowData As New Dictionary(Of String, String)()
                                    
                                    ' Add all fields from the reader to the dictionary
                                    For i As Integer = 0 To dr.FieldCount - 1
                                        rowData.Add(dr.GetName(i), GetSafeString(dr(i)))
                                    Next

                                    ' Convert the dictionary to JSON
                                    Dim jsonData As String = JsonConvert.SerializeObject(rowData)

                                    ' Show the popup and pass the data to JavaScript
                                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditPopup", 
                                        String.Format("openEditPopup({0});", jsonData), True)

                                Catch ex As Exception
                                    Throw New Exception("Error preparing data for edit: " & ex.Message, ex)
                                End Try
                            Else
                                Throw New Exception("Record not found")
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                ' Log the detailed error
                Trace.Warn("Error in HandleEditCommand", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                
                ' Show user-friendly error message
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "EditError", 
                    String.Format("alert('حدث خطأ أثناء تحميل البيانات للتعديل: {0}');", 
                    Server.HtmlEncode(ex.Message).Replace("'", "\'")), True)
            End Try
        End Sub

        Private Function GetSafeString(value As Object) As String
            If value Is Nothing OrElse value Is DBNull.Value Then
                Return String.Empty
            End If
            Return value.ToString()
        End Function

        Protected Sub btnSaveChanges_Click(sender As Object, e As EventArgs)
            Try
                ' Validate required fields
                If String.IsNullOrEmpty(Txt_Authority.Text) OrElse String.IsNullOrEmpty(Txt_Subject.Text) Then
                    Throw New Exception("برجاء ادخال البيانات الاساسيه")
                End If

                Dim recordId As String = hdnEditRecordID.Value
                
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql As String = "UPDATE Inventory SET " & _
                        "Response_emp = @Response_emp, " & _
                        "Incoming_Type = @Incoming_Type, " & _
                        "Postal_Code = @Postal_Code, " & _
                        "Authority = @Authority, " & _
                        "Emp_Number = @Emp_Number, " & _
                        "Emp_Name = @Emp_Name, " & _
                        "Subject = @Subject, " & _
                        "Subject_Content = @Subject_Content, " & _
                        "In_Tashira = @In_Tashira, " & _
                        "Out_Tashira = @Out_Tashira, " & _
                        "Aditional_Tashira = @Aditional_Tashira, " & _
                        "Followup3 = @Followup3, " & _
                        "Incoming_From = @Incoming_From, " & _
                        "Work_Area = @Work_Area " & _
                        "WHERE ID = @ID"

                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@ID", recordId)
                        cmd.Parameters.AddWithValue("@Response_emp", Drop_Responsible.SelectedValue)
                        cmd.Parameters.AddWithValue("@Incoming_Type", Drop_IncomType.SelectedValue)
                        cmd.Parameters.AddWithValue("@Postal_Code", Txt_PostalCode.Text)
                        cmd.Parameters.AddWithValue("@Authority", Txt_Authority.Text)
                        cmd.Parameters.AddWithValue("@Emp_Number", Txt_EmpNo.Text)
                        cmd.Parameters.AddWithValue("@Emp_Name", Txt_EmpName.Text)
                        cmd.Parameters.AddWithValue("@Subject", Drop_Subject.SelectedValue)
                        cmd.Parameters.AddWithValue("@Subject_Content", Txt_Subject.Text)
                        cmd.Parameters.AddWithValue("@In_Tashira", Txt_InTashira.Text)
                        cmd.Parameters.AddWithValue("@Out_Tashira", Txt_OutTashira.Text)
                        cmd.Parameters.AddWithValue("@Aditional_Tashira", Txt_Aditional_Tashira.Text)
                        cmd.Parameters.AddWithValue("@Followup3", Followup3.Text)
                        cmd.Parameters.AddWithValue("@Incoming_From", TXT_incoming_From.Text)
                        cmd.Parameters.AddWithValue("@Work_Area", Work_Area.SelectedValue)

                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                ' Handle file upload if a file was selected
                If FileUpload1.HasFile Then
                    UploadFiles(FileUpload1, Txt_Attach1)
                End If

                ' Refresh the grid
                GridView1.DataBind()
                
                ' Show success message and close popup
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "UpdateSuccess", 
                    "alert('تم تحديث البيانات بنجاح'); closeEditPopup();", True)

            Catch ex As Exception
                ' Log the error
                Trace.Warn("Error in btnSaveChanges_Click", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                
                ' Show error message to user
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "UpdateError", 
                    String.Format("alert('حدث خطأ أثناء تحديث البيانات: {0}');", 
                    Server.HtmlEncode(ex.Message).Replace("'", "\'")), True)
            End Try
        End Sub

        Protected Function GetRowData(id As Object, empName As Object, incomingType As Object, postalCode As Object, 
                                    outTashira As Object, subject As Object, additionalTashira As Object, 
                                    authority As Object, subjectContent As Object, notes As Object, 
                                    inTashira As Object, additionalActions As Object, actionTaken As Object, 
                                    subjectStatus As Object, incomingFrom As Object, requiredTime As Object) As String
            
            Dim rowData As New Dictionary(Of String, String)()
            rowData.Add("id", Convert.ToString(id))
            rowData.Add("empName", Convert.ToString(empName))
            rowData.Add("incomingType", Convert.ToString(incomingType))
            rowData.Add("postalCode", Convert.ToString(postalCode))
            rowData.Add("outTashira", Convert.ToString(outTashira))
            rowData.Add("subject", Convert.ToString(subject))
            rowData.Add("additionalTashira", Convert.ToString(additionalTashira))
            rowData.Add("authority", Convert.ToString(authority))
            rowData.Add("subjectContent", Convert.ToString(subjectContent))
            rowData.Add("notes", Convert.ToString(notes))
            rowData.Add("inTashira", Convert.ToString(inTashira))
            rowData.Add("additionalActions", Convert.ToString(additionalActions))
            rowData.Add("actionTaken", Convert.ToString(actionTaken))
            rowData.Add("subjectStatus", Convert.ToString(subjectStatus))
            rowData.Add("incomingFrom", Convert.ToString(incomingFrom))
            rowData.Add("requiredTime", Convert.ToString(requiredTime))
            
            Return JsonConvert.SerializeObject(rowData)
        End Function

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                InitializeEditControls()
            End If
        End Sub

        Private Sub InitializeEditControls()
            If Not Page.IsPostBack Then
                ' Populate Responsible dropdown from database
                ddlEditResponsible.DataSource = ResponsibleSqlDataSource
                ddlEditResponsible.DataTextField = "UsrName"
                ddlEditResponsible.DataValueField = "UsrName"
                ddlEditResponsible.DataBind()

                ' Populate Incoming Type dropdown
                ddlEditIncomingType.Items.Clear()
                ddlEditIncomingType.Items.Add(New ListItem("الايميل", "الايميل"))
                ddlEditIncomingType.Items.Add(New ListItem("البريد", "البريد"))
                ddlEditIncomingType.Items.Add(New ListItem("اليد", "اليد"))
                
                ' Populate Subject dropdown
                ddlEditSubject.Items.Clear()
                ddlEditSubject.Items.Add(New ListItem("مذكره", "مذكره"))
                ddlEditSubject.Items.Add(New ListItem("التماس", "التماس"))
                ddlEditSubject.Items.Add(New ListItem("مكاتبه", "مكاتبه"))
                ddlEditSubject.Items.Add(New ListItem("شكوي عميل", "شكوي عميل"))
                ddlEditSubject.Items.Add(New ListItem("تقرير مرور", "تقرير مرور"))
                ddlEditSubject.Items.Add(New ListItem("مقابله", "مقابله"))
                
                ' Populate Work Area dropdown from database
                ddlEditWorkArea.DataSource = Subject_RelateSqlDataSource
                ddlEditWorkArea.DataTextField = "Work_Area"
                ddlEditWorkArea.DataValueField = "Work_Area"
                ddlEditWorkArea.DataBind()

                ' Initialize Additional Actions dropdown
                Drop_Aditional_Actions0.Items.Clear()
                Drop_Aditional_Actions0.Items.Add(New ListItem("جاري المتابعه", "جاري المتابعه"))
                Drop_Aditional_Actions0.Items.Add(New ListItem("استعجال 1", "استعجال 1"))
                Drop_Aditional_Actions0.Items.Add(New ListItem("استعجال 2", "استعجال 2"))
                Drop_Aditional_Actions0.Items.Add(New ListItem("استعجال 3", "استعجال 3"))
                Drop_Aditional_Actions0.Items.Add(New ListItem("تم تحويله للتفتيش", "تم تحويله للتفتيش"))

                ' Initialize Subject Status dropdown
                Drop_Subject_Status0.Items.Clear()
                Drop_Subject_Status0.Items.Add(New ListItem("الموضوع مفتوح", "الموضوع مفتوح"))
                Drop_Subject_Status0.Items.Add(New ListItem("تم غلق الموضوع", "تم غلق الموضوع"))

                ' Initialize Time dropdown
                Drop_Time0.Items.Clear()
                Drop_Time0.Items.Add(New ListItem("1", "1"))
                Drop_Time0.Items.Add(New ListItem("2", "2"))
                Drop_Time0.Items.Add(New ListItem("3", "3"))
                Drop_Time0.Items.Add(New ListItem("7", "7"))
                Drop_Time0.Items.Add(New ListItem("10", "10"))
                Drop_Time0.Items.Add(New ListItem("بدون وقت", "بدون وقت"))
            End If
        End Sub

        Protected Function GetStatusClass(status As Object) As String
            If status Is Nothing OrElse status Is DBNull.Value Then
                Return "status-unknown"
            End If
            
            Dim statusStr As String = status.ToString().ToLower()
            Select Case statusStr
                Case "تم غلق الموضوع"
                    Return "status-closed"
                Case "الموضوع مفتوح"
                    Return "status-open"
                Case Else
                    Return "status-unknown"
            End Select
        End Function

        Protected Function SerializeObject(obj As Object) As String
            Return JsonConvert.SerializeObject(obj)
        End Function

        Protected Function DeserializeObject(Of T)(json As String) As T
            Return JsonConvert.DeserializeObject(Of T)(json)
        End Function
    End Class
End Namespace