object ProvidersConnection: TProvidersConnection
  Height = 366
  Width = 550
  object FDConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=Curso_Pooled')
    LoginPrompt = False
    Left = 88
    Top = 72
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorHome = 
      'C:\Users\leandro\Documents\repos\Treinamento_Api_Delphi\ProjetoC' +
      'urso'
    Left = 216
    Top = 80
  end
end
