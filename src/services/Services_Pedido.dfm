inherited ServicesPedido: TServicesPedido
  inherited FDConnection: TFDConnection
    Connected = True
  end
  inherited qryPesquisa: TFDQuery
    SQL.Strings = (
      'select p.id, p.id_cliente, p.id_usuario, p.data,'
      '       c.nome as nome_cliente'
      'from pedido p'
      'inner join cliente c on c.id = p.id_cliente'
      'where 1 = 1')
    object qryPesquisaid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryPesquisaid_cliente: TLargeintField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object qryPesquisaid_usuario: TLargeintField
      FieldName = 'id_usuario'
      Origin = 'id_usuario'
    end
    object qryPesquisadata: TSQLTimeStampField
      FieldName = 'data'
      Origin = 'data'
      ProviderFlags = [pfInUpdate]
    end
    object qryPesquisanome_cliente: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_cliente'
      Origin = 'nome_cliente'
      Size = 60
    end
  end
  inherited qryRecordCount: TFDQuery
    SQL.Strings = (
      'select count(p.id) '
      'from pedido p'
      'inner join cliente c on c.id = p.id_cliente'
      'where 1 = 1')
  end
  inherited qryCadastro: TFDQuery
    AfterInsert = qryCadastroAfterInsert
    SQL.Strings = (
      'select p.id, p.id_cliente, p.id_usuario, p.data,'
      '       c.nome as nome_cliente'
      'from pedido p'
      'inner join cliente c on c.id = p.id_cliente'
      '')
    object qryCadastroid: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryCadastroid_cliente: TLargeintField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object qryCadastroid_usuario: TLargeintField
      FieldName = 'id_usuario'
      Origin = 'id_usuario'
    end
    object qryCadastrodata: TSQLTimeStampField
      FieldName = 'data'
      Origin = 'data'
      ProviderFlags = [pfInUpdate]
    end
    object qryCadastronome_cliente: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_cliente'
      Origin = 'nome_cliente'
      Size = 60
    end
  end
end
