Imports System
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Namespace Site
    Public Class SiteMaster
        Inherits MasterPage

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                ' Initialize any master page specific logic here
            End If
        End Sub

        Protected Function GetCurrentYear() As Integer
            Return DateTime.Now.Year
        End Function

        ''' <summary>
        ''' Resolves the URL for script and style references
        ''' </summary>
        Protected Function ResolveUrl(virtualPath As String) As String
            If virtualPath.StartsWith("~/") Then
                virtualPath = virtualPath.Substring(2)
                Return Page.ResolveUrl("~/" & virtualPath)
            End If
            Return virtualPath
        End Function
    End Class
End Namespace 