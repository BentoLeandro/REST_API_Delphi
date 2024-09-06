# API REST Delphi para CRUD com Postgres
Este projeto foi desenvolvido para realizar operações CRUD (Create, Read, Update, Delete) em um banco de dados Postgres, 
utilizando Delphi como a linguagem de programação. A API segue o padrão REST e emprega tecnologias modernas, como Horse, 
JWT para autenticação, e várias bibliotecas auxiliares para otimizar a manipulação de dados e tratamento de exceções.

## Tecnologias Utilizadas
- Horse: Framework minimalista para a construção de APIs RESTful em Delphi.
- Horse-JWT: Middleware JWT para autenticação de usuários via tokens seguros.
- Jhonson: Biblioteca para manipulação de dados JSON em Delphi.
- Horse-octet-stream: Extensão para Horse, que permite o uso de octet-streams como tipo de conteúdo.
- Handle-exception: Middleware para tratamento centralizado de exceções.
- Dataset-serialize: Permite a serialização e desserialização de datasets em JSON.

## Funcionalidades
- CRUD Completo: Operações de criação, leitura, atualização e exclusão no banco de dados Postgres.
- Autenticação JWT: Utilização de JSON Web Tokens para garantir a segurança nas rotas que exigem autenticação.
- Serialização de Datasets: Conversão de datasets Delphi para JSON e vice-versa, facilitando a integração e manipulação de dados.
- Upload/Download de Arquivos: Suporte para octet-stream, permitindo o envio e recepção de arquivos binários.
- Tratamento Centralizado de Exceções: Gerenciamento eficaz de erros e respostas amigáveis ao usuário final.   
