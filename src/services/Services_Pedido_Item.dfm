inherited ServicesPedidoItem: TServicesPedidoItem
  inherited FDConnection: TFDConnection
    Connected = True
  end
  inherited qryPesquisa: TFDQuery
    SQL.Strings = (
      'select i.id, i.id_produto, i.valor, '
      '       i.quantidade, p.nome as nome_produto '
      'from pedido_item i'
      'inner join produto p on p.id = i.id_produto'
      'where i.id_pedido = :pid_pedido')
    ParamData = <
      item
        Name = 'PID_PEDIDO'
        ParamType = ptInput
      end>
    object qryPesquisaid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryPesquisaid_produto: TLargeintField
      FieldName = 'id_produto'
      Origin = 'id_produto'
    end
    object qryPesquisavalor: TFMTBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Precision = 20
      Size = 4
    end
    object qryPesquisaquantidade: TFMTBCDField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 20
      Size = 4
    end
    object qryPesquisanome_produto: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_produto'
      Origin = 'nome_produto'
      Size = 60
    end
  end
  inherited qryRecordCount: TFDQuery
    SQL.Strings = (
      'select count(i.id) '
      'from pedido_item i'
      'inner join produto p on p.id = i.id_produto'
      'where i.id_pedido = :pid_pedido')
    ParamData = <
      item
        Name = 'PID_PEDIDO'
        ParamType = ptInput
      end>
  end
  inherited qryCadastro: TFDQuery
    SQL.Strings = (
      'select i.id, i.id_pedido, i.id_produto, '
      '       i.valor, i.quantidade, p.nome as nome_produto '
      'from pedido_item i'
      'inner join produto p on p.id = i.id_produto')
    object qryCadastroid: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryCadastroid_pedido: TLargeintField
      FieldName = 'id_pedido'
      Origin = 'id_pedido'
    end
    object qryCadastroid_produto: TLargeintField
      FieldName = 'id_produto'
      Origin = 'id_produto'
    end
    object qryCadastrovalor: TFMTBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Precision = 20
      Size = 4
    end
    object qryCadastroquantidade: TFMTBCDField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 20
      Size = 4
    end
    object qryCadastronome_produto: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_produto'
      Origin = 'nome_produto'
      Size = 60
    end
  end
end
