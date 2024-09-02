program business;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.OctetStream,
  Horse.JWT,
  Providers_Connection in 'src\providers\Providers_Connection.pas' {ProvidersConnection: TDataModule},
  Providers_Cadastro in 'src\providers\Providers_Cadastro.pas' {ProvidersCadastro: TDataModule},
  Services_Produto in 'src\services\Services_Produto.pas' {ServicesProduto: TDataModule},
  Controllers_Produto in 'src\controllers\Controllers_Produto.pas',
  Services_Cliente in 'src\services\Services_Cliente.pas' {ServicesCliente: TDataModule},
  Controllers_Cliente in 'src\controllers\Controllers_Cliente.pas',
  Services_Pedido in 'src\services\Services_Pedido.pas' {ServicesPedido: TDataModule},
  Controllers_Pedido in 'src\controllers\Controllers_Pedido.pas',
  Services_Pedido_Item in 'src\services\Services_Pedido_Item.pas' {ServicesPedidoItem: TDataModule},
  Controllers_Pedido_Item in 'src\controllers\Controllers_Pedido_Item.pas',
  Services_Usuario in 'src\services\Services_Usuario.pas' {ServicesUsuario: TDataModule},
  Controllers_Usuario in 'src\controllers\Controllers_Usuario.pas';

begin
  THorse
    .Use(Jhonson())
    .Use(HandleException)
    .Use(OctetStream)
    .Use(HorseJWT('curso-rest-horse'));

  Controllers_Produto.Registry;
  Controllers_Cliente.Registry;
  Controllers_Pedido.Registry;
  Controllers_Pedido_Item.Registry;
  Controllers_Usuario.Registry;

  THorse.Listen(9000);
end.
