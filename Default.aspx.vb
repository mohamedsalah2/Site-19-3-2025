Imports System
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Data
Imports System.Data.SqlClient

Namespace Site
    Public Class _Default
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                LoadRecentActivity()
            End If
        End Sub

        Private Sub LoadRecentActivity()
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("DefaultConnection").ConnectionString)
                    Using cmd As New SqlCommand("SELECT TOP 5 ActivityDate, ActivityType, Description, [User] FROM ActivityLog ORDER BY ActivityDate DESC", conn)
                        conn.Open()
                        Dim dt As New DataTable()
                        dt.Load(cmd.ExecuteReader())
                        gvRecentActivity.DataSource = dt
                        gvRecentActivity.DataBind()
                    End Using
                End Using
            Catch ex As Exception
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "error", "SiteUtils.showToast('حدث خطأ أثناء تحميل النشاط الأخير', 'error');", True)
            End Try
        End Sub

        Protected Sub btnQuickSearch_Click(sender As Object, e As EventArgs) Handles btnQuickSearch.Click
            Try
                If String.IsNullOrWhiteSpace(txtQuickSearch.Text) Then
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "warning", "SiteUtils.showToast('الرجاء إدخال نص للبحث', 'warning');", True)
                    Return
                End If

                ' Redirect to search results page with search term
                Response.Redirect($"~/Search.aspx?q={Server.UrlEncode(txtQuickSearch.Text)}")
            Catch ex As Exception
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "error", "SiteUtils.showToast('حدث خطأ أثناء تنفيذ البحث', 'error');", True)
            End Try
        End Sub

        Protected Sub gvRecentActivity_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvRecentActivity.PageIndexChanging
            gvRecentActivity.PageIndex = e.NewPageIndex
            LoadRecentActivity()
        End Sub
    End Class
End Namespace 