Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports Microsoft.Reporting.WebForms
Imports Microsoft.Reporting
Imports System.IO
Imports OfficeOpenXml
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.Globalization

Namespace Site
    Public Class Reports
        Inherits System.Web.UI.Page
        Public SumClass1 As New SumClass
        Public err As String

        ' Legacy Report Controls
        Protected WithEvents TxtDate As TextBox
        Protected WithEvents TxtSubjectID As TextBox
        Protected WithEvents DropReport As DropDownList
        Protected WithEvents DropSubjectID As DropDownList
        Protected WithEvents DropSubject_Year As DropDownList
        Protected WithEvents Txt_Work_area As TextBox
        Protected WithEvents Drop_Responsible As DropDownList
        Protected WithEvents Button1 As Button
        Protected WithEvents BtnMAIN As Button
        Protected WithEvents RV_1MT As ReportViewer
        Protected WithEvents Panel_Date As Panel
        Protected WithEvents Panel_Responsible As Panel
        Protected WithEvents Panel_Subject As Panel
        Protected WithEvents Panel_Subject_Status As Panel

        ' SqlDataSource Controls
        Protected WithEvents Inv_DailyDataSource As SqlDataSource
        Protected WithEvents InvMonthDataSource As SqlDataSource
        Protected WithEvents Head_MonthDataSource As SqlDataSource
        Protected WithEvents Files_MonthDataSource As SqlDataSource
        Protected WithEvents InvDetailDataSource As SqlDataSource

        ' Modern Report Controls
        Protected WithEvents ddlReportType As DropDownList
        Protected WithEvents ddlAuthority As DropDownList
        Protected WithEvents txtDateFrom As TextBox
        Protected WithEvents txtDateTo As TextBox
        Protected WithEvents btnGenerateReport As Button
        Protected WithEvents btnExportExcel As Button
        Protected WithEvents btnExportPdf As Button
        Protected WithEvents mvReports As MultiView
        Protected WithEvents vwInventory As View
        Protected WithEvents vwDocuments As View
        Protected WithEvents vwActivity As View
        Protected WithEvents gvInventory As GridView
        Protected WithEvents gvDocuments As GridView
        Protected WithEvents gvActivity As GridView
        Protected WithEvents litTotalItems As Literal
        Protected WithEvents litActiveItems As Literal
        Protected WithEvents litCompletedItems As Literal
        Protected WithEvents litAverageTime As Literal
        Protected WithEvents reportSummary As HtmlGenericControl

        Public Sub Report1MT()
            Try
                If String.IsNullOrEmpty(TxtDate.Text) Then
                    Throw New Exception("التاريخ مطلوب")
                End If

                Dim M As Date = Convert.ToDateTime(TxtDate.Text, CultureInfo.GetCultureInfo("ar-Eg"))
                Dim rpDate As New ReportParameter("rpDate", M)
                Dim rpSubject_ID As New ReportParameter("rpSubject_ID", TxtSubjectID.Text)

                RV_1MT.LocalReport.DataSources.Clear()
                RV_1MT.Reset()

                Select Case DropReport.SelectedValue
                    Case "1" ' تقرير يومي
                        Panel_Date.Visible = True
                        Panel_Responsible.Visible = True
                        Panel_Subject_Status.Visible = True
                        Panel_Subject.Visible = False

                        RV_1MT.LocalReport.ReportPath = "REPORTS\Inventory_Daily_RPT.rdlc"
                        Dim ds As New ReportDataSource("DataSet1", Inv_DailyDataSource)
                        ds.DataSourceId = "Inv_DailyDataSource"
                        RV_1MT.LocalReport.DataSources.Add(ds)
                        RV_1MT.LocalReport.SetParameters(New ReportParameter() {rpDate})

                    Case "2" ' تقرير شهري
                        Panel_Date.Visible = True
                        Panel_Responsible.Visible = True
                        Panel_Subject_Status.Visible = True
                        Panel_Subject.Visible = False

                        RV_1MT.LocalReport.ReportPath = "REPORTS\Inventory_Month_RPT.rdlc"
                        Dim ds As New ReportDataSource("DataSet1", InvMonthDataSource)
                        ds.DataSourceId = "InvMonthDataSource"
                        RV_1MT.LocalReport.DataSources.Add(ds)
                        RV_1MT.LocalReport.SetParameters(New ReportParameter() {rpDate})

                    Case "3" ' تقرير بالموضوع
                        If String.IsNullOrEmpty(TxtSubjectID.Text) Then
                            Throw New Exception("رقم الموضوع مطلوب")
                        End If

                        Panel_Date.Visible = False
                        Panel_Responsible.Visible = False
                        Panel_Subject_Status.Visible = False
                        Panel_Subject.Visible = True

                        RV_1MT.LocalReport.ReportPath = "REPORTS\Report_Detail.rdlc"
                        Dim ds As New ReportDataSource("DataSet1", InvDetailDataSource)
                        ds.DataSourceId = "InvDetailDataSource"
                        RV_1MT.LocalReport.DataSources.Add(ds)
                        RV_1MT.LocalReport.SetParameters(New ReportParameter() {rpSubject_ID})

                    Case "4" ' تقرير مرور رئيس القطاع
                        Panel_Date.Visible = True
                        Panel_Responsible.Visible = False
                        Panel_Subject_Status.Visible = False
                        Panel_Subject.Visible = False

                        RV_1MT.LocalReport.ReportPath = "REPORTS\Head_Sector_RPT.rdlc"
                        Dim ds As New ReportDataSource("DataSet1", Head_MonthDataSource)
                        ds.DataSourceId = "Head_MonthDataSource"
                        RV_1MT.LocalReport.DataSources.Add(ds)
                        RV_1MT.LocalReport.SetParameters(New ReportParameter() {rpDate})

                    Case "5" ' تقرير ملفات القطاع
                        Panel_Date.Visible = True
                        Panel_Responsible.Visible = False
                        Panel_Subject_Status.Visible = False
                        Panel_Subject.Visible = False

                        RV_1MT.LocalReport.ReportPath = "REPORTS\Files_Month_RPT.rdlc"
                        Dim ds As New ReportDataSource("DataSet1", Files_MonthDataSource)
                        ds.DataSourceId = "Files_MonthDataSource"
                        RV_1MT.LocalReport.DataSources.Add(ds)
                        RV_1MT.LocalReport.SetParameters(New ReportParameter() {rpDate})

                    Case Else
                        Throw New Exception("نوع التقرير غير صحيح")
                End Select

                RV_1MT.DataBind()
                RV_1MT.LocalReport.Refresh()

            Catch ex As Exception
                err = If(ex.Message = "لا يوجد بيانات للعرض", ex.Message, "حدث خطأ أثناء إنشاء التقرير: " & ex.Message)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ReportError", 
                    String.Format("showToast('error', 'خطأ في التقرير', '{0}');", Server.HtmlEncode(err)), True)
            End Try
        End Sub

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Try
                If Not Page.IsPostBack Then
                    TxtDate.Text = DateTime.Now.ToString("dd/MM/yyyy", CultureInfo.GetCultureInfo("ar-Eg"))
                    Txt_Work_area.Text = If(Session("Work_area") IsNot Nothing, Session("Work_area").ToString(), String.Empty)
                    DropSubject_Year.DataBind()
                    TxtSubjectID.Text = If(DropSubjectID.SelectedValue IsNot Nothing, DropSubjectID.SelectedValue, String.Empty)
                    Report1MT()

                    Drop_Responsible.DataBind()
                    Drop_Responsible.Items.Insert(0, New ListItem("All", "%"))

                    ' Initialize page
                    SetDefaultDates()
                    LoadAuthorities()
                End If
            Catch ex As Exception
                Trace.Warn("Error in Page_Load", "Error: " & ex.Message & vbCrLf & "Stack Trace: " & ex.StackTrace)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PageLoadError", 
                    String.Format("showToast('error', 'خطأ في تحميل الصفحة', '{0}');", Server.HtmlEncode(ex.Message)), True)
            End Try

            SumClass1.Session_logout()
        End Sub

        Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
            Report1MT()
        End Sub

        Protected Sub BtnMAIN_Click(sender As Object, e As System.EventArgs) Handles BtnMAIN.Click
            Response.Redirect("MAIN.aspx")
        End Sub

        Protected Sub DropReport_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropReport.SelectedIndexChanged
            Report1MT()
        End Sub

        Protected Sub DropSubjectID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropSubjectID.SelectedIndexChanged
            TxtSubjectID.Text = DropSubjectID.SelectedValue
            Report1MT()
        End Sub

        Protected Sub Drop_Responsible_Init(sender As Object, e As EventArgs) Handles Drop_Responsible.Init
            Drop_Responsible.DataBind()
            Drop_Responsible.Items.Insert(0, New ListItem("All", "%"))
        End Sub

        Private Sub LoadAuthorities()
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("SELECT DISTINCT Authority FROM Inventory ORDER BY Authority", conn)
                    
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
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "LoadError", 
                    "showToast('error', 'خطأ في تحميل الجهات', '" & Server.HtmlEncode(ex.Message) & "');", True)
            End Try
        End Sub

        Private Sub SetDefaultDates()
            ' Set default date range to last month
            txtDateFrom.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd")
            txtDateTo.Text = DateTime.Now.ToString("yyyy-MM-dd")
        End Sub

        Protected Sub ddlReportType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlReportType.SelectedIndexChanged
            mvReports.ActiveViewIndex = ddlReportType.SelectedIndex
            GenerateReport()
        End Sub

        Protected Sub btnGenerateReport_Click(sender As Object, e As EventArgs) Handles btnGenerateReport.Click
            GenerateReport()
        End Sub

        Private Sub GenerateReport()
            Try
                Dim dateFrom As DateTime = DateTime.Parse(txtDateFrom.Text)
                Dim dateTo As DateTime = DateTime.Parse(txtDateTo.Text)
                Dim authority As String = ddlAuthority.SelectedValue

                Select Case ddlReportType.SelectedValue
                    Case "inventory"
                        GenerateInventoryReport(dateFrom, dateTo, authority)
                    Case "documents"
                        GenerateDocumentsReport(dateFrom, dateTo, authority)
                    Case "activity"
                        GenerateActivityReport(dateFrom, dateTo, authority)
                End Select

                reportSummary.Visible = True
            Catch ex As Exception
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ReportError", 
                    "showToast('error', 'خطأ في إنشاء التقرير', '" & Server.HtmlEncode(ex.Message) & "');", True)
            End Try
        End Sub

        Private Sub GenerateInventoryReport(dateFrom As DateTime, dateTo As DateTime, authority As String)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql As String = "SELECT * FROM Inventory WHERE Created_Date BETWEEN @DateFrom AND @DateTo"
                    If Not String.IsNullOrEmpty(authority) Then
                        sql &= " AND Authority = @Authority"
                    End If
                    sql &= " ORDER BY Created_Date DESC"

                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@DateFrom", dateFrom)
                        cmd.Parameters.AddWithValue("@DateTo", dateTo)
                        If Not String.IsNullOrEmpty(authority) Then
                            cmd.Parameters.AddWithValue("@Authority", authority)
                        End If

                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            gvInventory.DataSource = dt
                            gvInventory.DataBind()

                            ' Update summary
                            litTotalItems.Text = dt.Rows.Count.ToString()
                            litActiveItems.Text = dt.Select("Status = 'نشط'").Length.ToString()
                            litCompletedItems.Text = dt.Select("Status = 'مكتمل'").Length.ToString()
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Throw New Exception("خطأ في إنشاء تقرير المخزون: " & ex.Message)
            End Try
        End Sub

        Private Sub GenerateDocumentsReport(dateFrom As DateTime, dateTo As DateTime, authority As String)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql As String = "SELECT * FROM Documents WHERE DocDate BETWEEN @DateFrom AND @DateTo"
                    If Not String.IsNullOrEmpty(authority) Then
                        sql &= " AND Authority = @Authority"
                    End If
                    sql &= " ORDER BY DocDate DESC"

                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@DateFrom", dateFrom)
                        cmd.Parameters.AddWithValue("@DateTo", dateTo)
                        If Not String.IsNullOrEmpty(authority) Then
                            cmd.Parameters.AddWithValue("@Authority", authority)
                        End If

                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            gvDocuments.DataSource = dt
                            gvDocuments.DataBind()
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Throw New Exception("خطأ في إنشاء تقرير المستندات: " & ex.Message)
            End Try
        End Sub

        Private Sub GenerateActivityReport(dateFrom As DateTime, dateTo As DateTime, authority As String)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Post_DBConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql As String = "SELECT * FROM ActivityLog WHERE ActivityDate BETWEEN @DateFrom AND @DateTo"
                    If Not String.IsNullOrEmpty(authority) Then
                        sql &= " AND Authority = @Authority"
                    End If
                    sql &= " ORDER BY ActivityDate DESC"

                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@DateFrom", dateFrom)
                        cmd.Parameters.AddWithValue("@DateTo", dateTo)
                        If Not String.IsNullOrEmpty(authority) Then
                            cmd.Parameters.AddWithValue("@Authority", authority)
                        End If

                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            gvActivity.DataSource = dt
                            gvActivity.DataBind()
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Throw New Exception("خطأ في إنشاء تقرير النشاط: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnExportExcel_Click(sender As Object, e As EventArgs) Handles btnExportExcel.Click
            Try
                Using package As New ExcelPackage()
                    Dim worksheet = package.Workbook.Worksheets.Add("Report")
                    Dim gridView As GridView = Nothing

                    Select Case ddlReportType.SelectedValue
                        Case "inventory"
                            gridView = gvInventory
                        Case "documents"
                            gridView = gvDocuments
                        Case "activity"
                            gridView = gvActivity
                    End Select

                    If gridView IsNot Nothing AndAlso gridView.Rows.Count > 0 Then
                        ' Add headers
                        For col As Integer = 0 To gridView.HeaderRow.Cells.Count - 1
                            worksheet.Cells(1, col + 1).Value = gridView.HeaderRow.Cells(col).Text
                        Next

                        ' Add data
                        For row As Integer = 0 To gridView.Rows.Count - 1
                            For col As Integer = 0 To gridView.HeaderRow.Cells.Count - 1
                                worksheet.Cells(row + 2, col + 1).Value = gridView.Rows(row).Cells(col).Text
                            Next
                        Next

                        ' Auto-fit columns
                        worksheet.Cells(worksheet.Dimension.Address).AutoFitColumns()

                        ' Set response headers
                        Response.Clear()
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                        Response.AddHeader("content-disposition", "attachment;filename=Report.xlsx")

                        ' Write to response
                        Using ms As New MemoryStream()
                            package.SaveAs(ms)
                            ms.WriteTo(Response.OutputStream)
                        End Using
                        Response.End()
                    End If
                End Using
            Catch ex As Exception
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ExportError", 
                    String.Format("showToast('error', 'خطأ في تصدير البيانات', '{0}');", Server.HtmlEncode(ex.Message)), True)
            End Try
        End Sub

        Protected Sub btnExportPdf_Click(sender As Object, e As EventArgs) Handles btnExportPdf.Click
            Try
                Using ms As New MemoryStream()
                    Using doc As New Document(PageSize.A4, 50, 50, 50, 50)
                        Using writer As PdfWriter = PdfWriter.GetInstance(doc, ms)
                            doc.Open()

                            ' Add title
                            Dim titleFont As New Font(Font.FontFamily.HELVETICA, 18, Font.BOLD)
                            doc.Add(New Paragraph("تقرير " & ddlReportType.SelectedItem.Text, titleFont))
                            doc.Add(New Paragraph(vbCrLf))

                            ' Add table
                            Dim gridView As GridView = Nothing
                            Select Case ddlReportType.SelectedValue
                                Case "inventory"
                                    gridView = gvInventory
                                Case "documents"
                                    gridView = gvDocuments
                                Case "activity"
                                    gridView = gvActivity
                            End Select

                            If gridView IsNot Nothing AndAlso gridView.Rows.Count > 0 Then
                                Dim table As New PdfPTable(gridView.HeaderRow.Cells.Count)
                                table.WidthPercentage = 100

                                ' Add headers
                                For Each cell As TableCell In gridView.HeaderRow.Cells
                                    table.AddCell(New PdfPCell(New Phrase(cell.Text)))
                                Next

                                ' Add data
                                For Each row As GridViewRow In gridView.Rows
                                    For Each cell As TableCell In row.Cells
                                        table.AddCell(New PdfPCell(New Phrase(cell.Text)))
                                    Next
                                Next

                                doc.Add(table)
                            End If

                            doc.Close()
                        End Using
                    End Using

                    ' Set response headers
                    Response.Clear()
                    Response.ContentType = "application/pdf"
                    Response.AddHeader("content-disposition", "attachment;filename=Report.pdf")
                    Response.BinaryWrite(ms.ToArray())
                    Response.End()
                End Using
            Catch ex As Exception
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ExportError", 
                    String.Format("showToast('error', 'خطأ في تصدير البيانات', '{0}');", Server.HtmlEncode(ex.Message)), True)
            End Try
        End Sub
    End Class
End Namespace
