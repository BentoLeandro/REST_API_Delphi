inherited ProvidersCadastro: TProvidersCadastro
  Height = 280
  Width = 476
  object qryPesquisa: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 352
    Top = 40
  end
  object qryRecordCount: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 352
    Top = 104
    object qryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
  object qryCadastro: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 352
    Top = 168
  end
end
