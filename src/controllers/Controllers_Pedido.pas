unit Controllers_Pedido;

interface

uses Horse;

procedure Registry;

implementation

uses Services_Pedido, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService : TServicesPedido;
begin
  LService := TServicesPedido.Create;
  try
    LRetorno := TJSONObject.Create;
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido : string;
  LService : TServicesPedido;
begin
  LService := TServicesPedido.Create;
  try
    LIdPedido := Req.Params['id'];
    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Pedido não Encontrado!');

    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LPedido : TJSONObject;
  LService : TServicesPedido;
begin
  LService := TServicesPedido.Create;
  try
    LPedido := Req.Body<TJSONObject>;
    if LService.Append(LPedido) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido : string;
  LPedido : TJSONObject;
  LService : TServicesPedido;
begin
  LService := TServicesPedido.Create;
  try
    LIdPedido := Req.Params['id'];
    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Pedido não Encontrado!');

    LPedido := Req.Body<TJSONObject>;
    if LService.Update(LPedido) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido : string;
  LService : TServicesPedido;
begin
  LService := TServicesPedido.Create;
  try
    LIdPedido := Req.Params['id'];
    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Pedido não Encontrado!');

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/pedidos', ListarPedidos);
  THorse.Get('/pedidos/:id', ObterPedido);
  THorse.Post('/pedidos', CadastrarPedido);
  THorse.Put('/pedidos/:id', AlterarPedido);
  THorse.Delete('/pedidos/:id', DeletarPedido);
end;

end.
