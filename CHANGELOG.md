# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/). Versionamento semântico:
**major** = rota removida ou campo obrigatório mudou de forma incompatível; **minor** = rota ou
campo novo (aditivo); **patch** = descrição/exemplo/correção sem mudar formato.

## [0.2.0] - 2026-09-10

Schemas de resposta completos — na v0.1.0, só 3 de ~43 respostas declaravam `schema` (o resto só
validava status HTTP via `run_test!`, sem capturar a forma no contrato), o que fazia o Kubb gerar
`unknown` pra maioria dos endpoints de escrita/detalhe. Adicionado `schema` a todas as respostas
que faltavam, com validação real (rswag valida a resposta de verdade contra o schema declarado —
não é documentação solta). Minor porque é conteúdo novo no contrato (campos que já existiam na API
real, só não estavam documentados), não muda nenhum formato já documentado.

## [0.1.0] - 2026-09-09

Primeira versão. Contrato gerado a partir da suíte de request specs (rswag) do `dita_core`
existente até esta data — 21 rotas, 12 controllers (Auth, Companies, Products, Customers, Orders,
Installments, ContractTemplates, OrderContracts, Whatsapp, Reports, Conversations).
