Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports Microsoft.Reporting.WebForms
Imports Microsoft.Reporting

Partial Class Month_Report
    Inherits System.Web.UI.Page
    Public SumClass1 As New SumClass
    Public err As String

    Public Sub Report1MT()
        Try

            Dim M As Date = Convert.ToDateTime(TxtDate.Text, System.Globalization.CultureInfo.GetCultureInfo("ar-Eg"))
            Dim rpDate As New ReportParameter("rpDate", M)

            RV_1MT.Reset()
            RV_1MT.LocalReport.DataSources.Clear()
            Dim ds As New ReportDataSource("DataSet1", InvMonthDataSource)
            ds.DataSourceId = "InvMonthDataSource"
            RV_1MT.LocalReport.DataSources.Add(ds)
            RV_1MT.LocalReport.ReportPath = "REPORTS\MonthReport.rdlc"
            RV_1MT.LocalReport.SetParameters(New ReportParameter() {rpDate})


            RV_1MT.LocalReport.Refresh()

        Catch ex As Exception

            err = "لا يوجد بيانات للعرض"

        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            'SumClass1.Session_logout()

            If Not Page.IsPostBack Then

                Report1MT()

            End If

        Catch ex As Exception
        End Try

        'SumClass1.Session_logout()
    End Sub

End Class
