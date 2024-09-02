unit Controllers_Pedido_Item;

interface

uses Horse;

procedure Registry;

implementation

uses Services_Pedido_Item, Services_Pedido, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarItensPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService : TServicesPedidoItem;
  LIdPedido : string;
begin
  LService := TServicesPedidoItem.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];

    LRetorno := TJSONObject.Create;
    LRetorno.AddPair('data', LService.ListAllByPedido(Req.Query.Dictionary, LIdPedido).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterItemPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesPedidoItem;
  LIdPedido : string;
  LIdItem : string;
begin
  LService := TServicesPedidoItem.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];
    LIdItem := Req.Params.Items['id_item'];

    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Item do pedido não Encontrado!');

    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarItemPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesPedidoItem;
  LServicePedido : TServicesPedido;
  LIdPedido : string;
  LItem : TJSONObject;
begin
  LService := TServicesPedidoItem.Create;
  LServicePedido := TServicesPedido.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];
    if LServicePedido.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Pedido não Encontrado!');

    LItem := Req.Body<TJSONObject>;
    LItem.RemovePair('id_pedido').Free;
    LItem.AddPair('id_pedido', TJSONNumber.Create(LIdPedido));
    if LService.Append(LItem) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
    LServicePedido.Free;
  end;
end;

procedure AlterarItemPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesPedidoItem;
  LIdPedido, LIdItem : string;
  LItem : TJSONObject;
begin
  LService := TServicesPedidoItem.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];
    LIdItem := Req.Params.Items['id_item'];

    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Item não Encontrado no Pedido.:'+LIdPedido);

    LItem := Req.Body<TJSONObject>;
    LItem.RemovePair('id_pedido').Free; //Retira o IdPedido pq ele não será alterado!
    if LService.Update(LItem) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarItemPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesPedidoItem;
  LIdPedido, LIdItem : string;
begin
  LService := TServicesPedidoItem.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];
    LIdItem := Req.Params.Items['id_item'];

    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Item não Encontrado no Pedido.: '+LIdPedido);

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;

end;

procedure Registry;
begin
  THorse.Get('/pedidos/:id_pedido/itens', ListarItensPedido);
  THorse.Get('/pedidos/:id_pedido/itens/:id_item', ObterItemPedido);
  THorse.Post('/pedidos/:id_pedido/itens', CadastrarItemPedido);
  THorse.Put('/pedidos/:id_pedido/itens/:id_item', AlterarItemPedido);
  THorse.Delete('/pedidos/:id_pedido/itens/:id_item', DeletarItemPedido);
end;

end.
