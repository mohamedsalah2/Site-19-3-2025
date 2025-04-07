Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Namespace Site
    Public Class ViewInventory
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dim itemId = Request.QueryString("id")
                If String.IsNullOrEmpty(itemId) Then
                    Response.Redirect("~/Inventory.aspx")
                    Return
                End If

                LoadInventoryDetails(Convert.ToInt32(itemId))
            End If
        End Sub

        Private Sub LoadInventoryDetails(itemId As Integer)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("DefaultConnection").ConnectionString)
                    Using cmd As New SqlCommand("SELECT * FROM Inventory WHERE ID = @id", conn)
                        cmd.Parameters.AddWithValue("@id", itemId)
                        conn.Open()
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                ' Load basic information
                                lblSubjectID.Text = GetSafeString(reader("ID"))
                                lblCreatedDate.Text = Convert.ToDateTime(reader("Created_Date")).ToString("dd/MM/yyyy")
                                lblResponsible.Text = GetSafeString(reader("Response_emp"))
                                lblAuthority.Text = GetSafeString(reader("Authority"))
                                
                                ' Set status with appropriate CSS class
                                Dim status = GetSafeString(reader("Status"))
                                lblStatus.Text = status
                                lblStatus.CssClass = "detail-value status-badge " & GetStatusClass(status)

                                ' Load subject information
                                lblIncomingType.Text = GetSafeString(reader("Incoming_Type"))
                                lblPostalCode.Text = GetSafeString(reader("Postal_Code"))
                                lblSubject.Text = GetSafeString(reader("Subject"))
                                lblSubjectContent.Text = GetSafeString(reader("Subject_Content"))

                                ' Load additional information
                                lblInTashira.Text = GetSafeString(reader("In_Tashira"))
                                lblOutTashira.Text = GetSafeString(reader("Out_Tashira"))
                                lblAdditionalTashira.Text = GetSafeString(reader("Aditional_Tashira"))
                                lblAdditionalActions.Text = GetSafeString(reader("Aditional_Actions"))
                                lblRequiredTime.Text = GetSafeString(reader("Required_Time"))
                                lblNotes.Text = GetSafeString(reader("Notes"))

                                ' Load attachments
                                LoadAttachments(GetSafeString(reader("Attach1")))
                            Else
                                ShowError("العنصر غير موجود")
                                Response.Redirect("~/Inventory.aspx")
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                ShowError("حدث خطأ أثناء تحميل البيانات")
                Trace.Warn("Error in LoadInventoryDetails", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
            End Try
        End Sub

        Private Sub LoadAttachments(attachments As String)
            If String.IsNullOrEmpty(attachments) Then
                pnlAttachments.Visible = False
                Return
            End If

            Dim fileList As New List(Of AttachmentInfo)
            Dim files As String() = attachments.Split(","c)

            For Each file As String In files
                If Not String.IsNullOrEmpty(file.Trim()) Then
                    fileList.Add(New AttachmentInfo() With {
                        .FileName = Path.GetFileName(file.Trim()),
                        .FilePath = "~/Attachments/" & file.Trim()
                    })
                End If
            Next

            If fileList.Count > 0 Then
                rptAttachments.DataSource = fileList
                rptAttachments.DataBind()
                pnlAttachments.Visible = True
            Else
                pnlAttachments.Visible = False
            End If
        End Sub

        Protected Function GetFileIcon(fileName As Object) As String
            If fileName Is Nothing Then Return "file-alt"
            
            Dim extension = Path.GetExtension(fileName.ToString()).ToLower()
            Select Case extension
                Case ".pdf"
                    Return "file-pdf"
                Case ".doc", ".docx"
                    Return "file-word"
                Case ".xls", ".xlsx"
                    Return "file-excel"
                Case ".jpg", ".jpeg", ".png", ".gif"
                    Return "file-image"
                Case Else
                    Return "file-alt"
            End Select
        End Function

        Protected Function GetStatusClass(status As String) As String
            If String.IsNullOrEmpty(status) Then Return "status-active"
            
            Select Case status.ToLower()
                Case "نشط"
                    Return "status-active"
                Case "مكتمل"
                    Return "status-completed"
                Case "ملغي"
                    Return "status-cancelled"
                Case Else
                    Return "status-active"
            End Select
        End Function

        Private Function GetSafeString(value As Object) As String
            If value Is Nothing OrElse value Is DBNull.Value Then
                Return String.Empty
            End If
            Return value.ToString()
        End Function

        Protected Sub btnEdit_Click(sender As Object, e As EventArgs) Handles btnEdit.Click
            Dim itemId = Request.QueryString("id")
            If Not String.IsNullOrEmpty(itemId) Then
                Response.Redirect($"~/Inventory.aspx?mode=edit&id={itemId}")
            End If
        End Sub

        Protected Sub rptAttachments_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
            If e.CommandName = "Download" Then
                Try
                    Dim filePath As String = Server.MapPath(e.CommandArgument.ToString())
                    If File.Exists(filePath) Then
                        Response.Clear()
                        Response.ContentType = GetContentType(Path.GetExtension(filePath))
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" & Path.GetFileName(filePath))
                        Response.TransmitFile(filePath)
                        Response.End()
                    Else
                        ShowError("الملف غير موجود")
                    End If
                Catch ex As Exception
                    ShowError("حدث خطأ أثناء تحميل الملف")
                    Trace.Warn("Error in Download", "Error: " & ex.Message)
                End Try
            End If
        End Sub

        Private Function GetContentType(extension As String) As String
            Select Case extension.ToLower()
                Case ".pdf"
                    Return "application/pdf"
                Case ".doc", ".docx"
                    Return "application/msword"
                Case ".xls", ".xlsx"
                    Return "application/vnd.ms-excel"
                Case ".jpg", ".jpeg"
                    Return "image/jpeg"
                Case ".png"
                    Return "image/png"
                Case ".gif"
                    Return "image/gif"
                Case Else
                    Return "application/octet-stream"
            End Select
        End Function

        Private Sub ShowError(message As String)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "error", 
                $"if (typeof SiteUtils !== 'undefined') {{ SiteUtils.showToast('{message}', 'error'); }}" & 
                $"else {{ alert('{message}'); }}", True)
        End Sub
    End Class

    Public Class AttachmentInfo
        Public Property FileName As String
        Public Property FilePath As String
    End Class
End Namespace 