unit Controllers_Produto;

interface

uses Horse;

procedure Registry;

implementation

uses Services_Produto, System.JSON, DataSet.Serialize, System.SysUtils, Data.DB;

procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService : TServicesProduto;
begin
  LService := TServicesProduto.Create();
  try
    LRetorno := TJSONObject.Create();
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records',  TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
    //Não é necessario destruir o LRetorno pq o proprio Horse vai ser isso
    //quando é chamado a função Res.Send.
  end;
end;

procedure ObterProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto : string;
  LService : TServicesProduto;
begin
  LService := TServicesProduto.Create();
  try
    LIdProduto := Req.Params['id'];
    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Produto não encontrado!');

    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LProduto : TJSONObject;
  LService : TServicesProduto;
begin
  LService := TServicesProduto.Create();
  try
    LProduto := Req.Body<TJSONObject>;
    if LService.Append(LProduto) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto : string;
  LProduto : TJSONObject;
  LService : TServicesProduto;
begin
  LService := TServicesProduto.Create();
  try
    LIdProduto := Req.Params['id'];
    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Produto não encontrado!');

    LProduto := Req.Body<TJSONObject>;
    if LService.Update(LProduto) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto : string;
  LService : TServicesProduto;
begin
  LService := TServicesProduto.Create();
  try
    LIdProduto := Req.Params['id'];
    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Produto não encontrado!');

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure Teste(Req: THorseRequest; Res: THorseResponse);
begin
    Res.Send('Teste do Api!');
end;


procedure Registry;
begin
  THorse.Get('/produtos', ListarProdutos);
  THorse.Get('/produtos/:id', ObterProduto);
  THorse.Post('/produtos', CadastrarProduto);
  THorse.Put('/produtos/:id', AlterarProduto);
  THorse.Delete('/produtos/:id', DeletarProduto);

  THorse.Get('/teste', Teste);
end;

end.
