Attribute VB_Name = "Resolution"
Option Explicit
 
Private Const CCDEVICENAME As Long = 32
Private Const CCFORMNAME As Long = 32
Private Const DM_BITSPERPEL As Long = &H40000
Private Const DM_PELSWIDTH As Long = &H80000
Private Const DM_PELSHEIGHT As Long = &H100000
Private Const DM_DISPLAYFREQUENCY As Long = &H400000
Private Const CDS_TEST As Long = &H4
Private Const ENUM_CURRENT_SETTINGS As Long = -1
 
Private Type typDevMODE
    dmDeviceName       As String * CCDEVICENAME
    dmSpecVersion      As Integer
    dmDriverVersion    As Integer
    dmSize             As Integer
    dmDriverExtra      As Integer
    dmFields           As Long
    dmOrientation      As Integer
    dmPaperSize        As Integer
    dmPaperLength      As Integer
    dmPaperWidth       As Integer
    dmScale            As Integer
    dmCopies           As Integer
    dmDefaultSource    As Integer
    dmPrintQuality     As Integer
    dmColor            As Integer
    dmDuplex           As Integer
    dmYResolution      As Integer
    dmTTOption         As Integer
    dmCollate          As Integer
    dmFormName         As String * CCFORMNAME
    dmUnusedPadding    As Integer
    dmBitsPerPel       As Integer
    dmPelsWidth        As Long
    dmPelsHeight       As Long
    dmDisplayFlags     As Long
    dmDisplayFrequency As Long
End Type
 
Private oldResHeight As Long
Private oldResWidth As Long
Private oldDepth As Integer
Private oldFrequency As Long
Private bNoResChange As Boolean
 
 
Private Declare Function EnumDisplaySettings Lib "user32" Alias "EnumDisplaySettingsA" (ByVal lpszDeviceName As Long, ByVal iModeNum As Long, lptypDevMode As Any) As Boolean
Private Declare Function ChangeDisplaySettings Lib "user32" Alias "ChangeDisplaySettingsA" (lptypDevMode As Any, ByVal dwFlags As Long) As Long
 
 Public Sub SetResolution()
 
    Dim lRes As Long
    Dim MidevM As typDevMODE
    Dim CambiarResolucion As Boolean
   
    lRes = EnumDisplaySettings(0, ENUM_CURRENT_SETTINGS, MidevM)
   
    oldResWidth = Screen.width \ Screen.TwipsPerPixelX
    oldResHeight = Screen.height \ Screen.TwipsPerPixelY
   
    If NoRes Then
        CambiarResolucion = (oldResWidth < 800 Or oldResHeight < 600)
    Else
        CambiarResolucion = (oldResWidth <> 800 Or oldResHeight <> 600)
    End If
   
    If CambiarResolucion Then
       frmMain.WindowState = vbMaximized
        With MidevM
            oldDepth = .dmBitsPerPel
            oldFrequency = .dmDisplayFrequency
           
            .dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
            .dmPelsWidth = 800
            .dmPelsHeight = 600
            .dmBitsPerPel = 16
        End With
       
        lRes = ChangeDisplaySettings(MidevM, CDS_TEST)
    Else
        bNoResChange = True
        MidevM.dmFields = DM_BITSPERPEL
        MidevM.dmBitsPerPel = 16
        lRes = ChangeDisplaySettings(MidevM, CDS_TEST)
        frmMain.WindowState = vbNormal
 End If
End Sub
 
Public Sub ResetResolution()
 
    Dim typDevM As typDevMODE
    Dim lRes As Long
   
    If Not bNoResChange Then
   
        lRes = EnumDisplaySettings(0, ENUM_CURRENT_SETTINGS, typDevM)
       
        With typDevM
            .dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
            .dmPelsWidth = oldResWidth
            .dmPelsHeight = oldResHeight
            .dmBitsPerPel = oldDepth
            .dmDisplayFrequency = oldFrequency
        End With
       
        lRes = ChangeDisplaySettings(typDevM, CDS_TEST)
    Else
        lRes = EnumDisplaySettings(0, ENUM_CURRENT_SETTINGS, typDevM)
       
        With typDevM
            .dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
            .dmPelsWidth = oldResWidth
            .dmPelsHeight = oldResHeight
            .dmBitsPerPel = oldDepth
            .dmDisplayFrequency = oldFrequency
        End With
       
        lRes = ChangeDisplaySettings(typDevM, CDS_TEST)
    End If
End Sub
 
