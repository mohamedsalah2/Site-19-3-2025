Imports System
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Globalization

Namespace Site
    Public Class Search
        Inherits System.Web.UI.Page

        ' Control declarations
        Protected WithEvents txtSearch As TextBox
        Protected WithEvents ddlSearchType As DropDownList
        Protected WithEvents btnSearch As Button
        Protected WithEvents txtDateFrom As TextBox
        Protected WithEvents txtDateTo As TextBox
        Protected WithEvents ddlAuthority As DropDownList
        Protected WithEvents gvSearchResults As GridView
        Protected WithEvents litResultsCount As Literal

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Try
                If Not IsPostBack Then
                    LoadAuthorities()
                    
                    ' Set default date range
                    txtDateFrom.Text = DateTime.Now.AddMonths(-1).ToString("dd/MM/yyyy", CultureInfo.GetCultureInfo("ar-Eg"))
                    txtDateTo.Text = DateTime.Now.ToString("dd/MM/yyyy", CultureInfo.GetCultureInfo("ar-Eg"))
                    
                    ' Check if there's a search query from the home page
                    Dim quickSearch As String = Request.QueryString("q")
                    If Not String.IsNullOrEmpty(quickSearch) Then
                        txtSearch.Text = Server.HtmlEncode(quickSearch)
                        PerformSearch()
                    End If
                End If
            Catch ex As Exception
                Trace.Warn("Error in Page_Load", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PageLoadError", 
                    String.Format("showToast('error', 'خطأ في تحميل الصفحة', '{0}');", Server.HtmlEncode(ex.Message)), True)
            End Try
        End Sub

        Private Sub LoadAuthorities()
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("SELECT DISTINCT Authority FROM Inventory WHERE Authority IS NOT NULL ORDER BY Authority", conn)
                    
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        ddlAuthority.Items.Clear()
                        ddlAuthority.Items.Add(New ListItem("الكل", ""))
                        
                        While rdr.Read()
                            If Not rdr.IsDBNull(0) Then
                                ddlAuthority.Items.Add(New ListItem(rdr("Authority").ToString()))
                            End If
                        End While
                    End Using
                End Using
            Catch ex As Exception
                Trace.Warn("Error in LoadAuthorities", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "LoadError", 
                    String.Format("showToast('error', 'خطأ في تحميل الجهات', '{0}');", Server.HtmlEncode(ex.Message)), True)
            End Try
        End Sub

        Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
            PerformSearch()
        End Sub

        Private Sub PerformSearch()
            Try
                Dim searchQuery As String = Server.HtmlEncode(txtSearch.Text.Trim())
                Dim searchType As String = ddlSearchType.SelectedValue
                Dim authority As String = ddlAuthority.SelectedValue
                
                ' Parse dates using TryParse with Arabic culture
                Dim dateFrom As DateTime = Nothing
                Dim dateTo As DateTime = Nothing
                Dim hasDateFrom As Boolean = DateTime.TryParse(txtDateFrom.Text, CultureInfo.GetCultureInfo("ar-Eg"), DateTimeStyles.None, dateFrom)
                Dim hasDateTo As Boolean = DateTime.TryParse(txtDateTo.Text, CultureInfo.GetCultureInfo("ar-Eg"), DateTimeStyles.None, dateTo)

                ' Validate date range
                If hasDateFrom AndAlso hasDateTo AndAlso dateFrom > dateTo Then
                    Throw New Exception("تاريخ البداية يجب أن يكون قبل تاريخ النهاية")
                End If

                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql As String = GetSearchQuery(searchType, searchQuery, authority, If(hasDateFrom, dateFrom, Nothing), If(hasDateTo, dateTo, Nothing))

                    Using cmd As New SqlCommand(sql, conn)
                        If Not String.IsNullOrEmpty(searchQuery) Then
                            cmd.Parameters.AddWithValue("@SearchQuery", "%" & searchQuery & "%")
                        End If
                        If Not String.IsNullOrEmpty(authority) Then
                            cmd.Parameters.AddWithValue("@Authority", authority)
                        End If
                        If hasDateFrom Then
                            cmd.Parameters.AddWithValue("@DateFrom", dateFrom)
                        End If
                        If hasDateTo Then
                            cmd.Parameters.AddWithValue("@DateTo", dateTo)
                        End If

                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            gvSearchResults.DataSource = dt
                            gvSearchResults.DataBind()

                            litResultsCount.Text = String.Format("تم العثور على {0} نتيجة", dt.Rows.Count)
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Trace.Warn("Error in PerformSearch", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "SearchError", 
                    String.Format("showToast('error', 'خطأ في البحث', '{0}');", Server.HtmlEncode(ex.Message)), True)
                litResultsCount.Text = "حدث خطأ في البحث"
            End Try
        End Sub

        Private Function GetSearchQuery(searchType As String, searchQuery As String, authority As String, dateFrom As DateTime?, dateTo As DateTime?) As String
            Dim sql As String = ""

            Select Case searchType
                Case "inventory"
                    sql = "SELECT ID, Subject AS Title, N'مخزون' AS Type, Authority, Created_Date AS Date FROM Inventory WHERE 1=1"
                Case "documents"
                    sql = "SELECT ID, DocTitle AS Title, N'مستند' AS Type, Authority, DocDate AS Date FROM Documents WHERE 1=1"
                Case "reports"
                    sql = "SELECT ID, ReportTitle AS Title, N'تقرير' AS Type, Authority, ReportDate AS Date FROM Reports WHERE 1=1"
                Case Else
                    sql = "SELECT ID, Subject AS Title, N'مخزون' AS Type, Authority, Created_Date AS Date FROM Inventory WHERE 1=1 " & _
                          "UNION ALL " & _
                          "SELECT ID, DocTitle, N'مستند', Authority, DocDate FROM Documents WHERE 1=1 " & _
                          "UNION ALL " & _
                          "SELECT ID, ReportTitle, N'تقرير', Authority, ReportDate FROM Reports WHERE 1=1"
            End Select

            If Not String.IsNullOrEmpty(searchQuery) Then
                sql &= " AND (Title LIKE @SearchQuery OR Authority LIKE @SearchQuery)"
            End If

            If Not String.IsNullOrEmpty(authority) Then
                sql &= " AND Authority = @Authority"
            End If

            If dateFrom.HasValue Then
                sql &= " AND Date >= @DateFrom"
            End If

            If dateTo.HasValue Then
                sql &= " AND Date <= @DateTo"
            End If

            sql &= " ORDER BY Date DESC"

            Return sql
        End Function

        Protected Function GetItemIcon(itemType As String) As String
            Select Case itemType.ToLower()
                Case "مخزون"
                    Return "box"
                Case "مستند"
                    Return "file-alt"
                Case "تقرير"
                    Return "chart-bar"
                Case Else
                    Return "file"
            End Select
        End Function

        Protected Sub gvSearchResults_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSearchResults.PageIndexChanging
            gvSearchResults.PageIndex = e.NewPageIndex
            PerformSearch()
        End Sub

        Protected Sub gvSearchResults_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSearchResults.RowCommand
            If e.CommandName = "ViewItem" Then
                Dim itemId As String = e.CommandArgument.ToString()
                Dim row As GridViewRow = DirectCast((DirectCast(e.CommandSource, LinkButton)).NamingContainer, GridViewRow)
                Dim itemType As String = row.Cells(2).Text ' Assuming Type is in the third column

                Select Case itemType.ToLower()
                    Case "مخزون"
                        Response.Redirect($"ViewInventory.aspx?id={itemId}")
                    Case "مستند"
                        Response.Redirect($"ViewDocument.aspx?id={itemId}")
                    Case "تقرير"
                        Response.Redirect($"ViewReport.aspx?id={itemId}")
                End Select
            End If
        End Sub
    End Class
End Namespace 