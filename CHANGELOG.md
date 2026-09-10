# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/). Versionamento semântico:
**major** = rota removida ou campo obrigatório mudou de forma incompatível; **minor** = rota ou
campo novo (aditivo); **patch** = descrição/exemplo/correção sem mudar formato.

## [0.3.3] - 2026-09-10

Patch: `role`/`content`/`created_at` das mensagens (dentro de Conversation) passam de opcionais e
`role`/`content` de nullable pra `required` e não-nulos, e `role` ganha `enum` (`user`/`assistant`).
A coluna no banco permite null, mas todo caminho de criação de mensagem no código sempre define os
três campos — o contrato estava mais frouxo do que o comportamento real da aplicação.

## [0.3.2] - 2026-09-10

Patch: `customer` (em Order e Conversation, quando incluído) e `installments` (em Order, quando
incluído) passam de opcionais pra `required` — ambas as associações são `belongs_to`/`has_many`
não-nulas no schema real (`orders.customer_id`/`conversations.customer_id` são `null: false`), e
sempre vêm presentes na serialização, então o contrato estava mais frouxo do que a API de verdade.

## [0.3.1] - 2026-09-10

Patch: `whatsapp_status` nas respostas de `connect`/`status`/`disconnect` do WhatsApp também ganha
`enum` (o mesmo campo já tinha ganhado em Company na v0.2.1, mas essas três respostas específicas
ficaram de fora). `qrcode.base64`/`qrcode.code` passam a ser `required` dentro do objeto (sempre
vêm juntos na resposta real da Evolution API).

## [0.3.0] - 2026-09-10

Schemas de **request body** completos — mesmo problema da v0.2.0, mas do lado do que a API aceita:
vários `parameter :body` só declaravam os campos que aquele teste específico mandava, não todos os
campos que o controller realmente aceita (`strong_parameters#permit`). Ex.: `PATCH /companies/:id`
só documentava `name`, mas o controller aceita `document/phone/active/evolution_instance_name/
default_late_interest_rate/default_interest_period` também. Completado em Companies, Products,
Customers, ContractTemplates, Orders e OrderContracts. Minor: só torna aceitável no contrato o que
a API já aceitava de verdade.

## [0.2.1] - 2026-09-10

Patch: `whatsapp_status`, `default_interest_period` (Company) e `interest_period` (Order) ganham
`enum` no schema — antes eram `string` genérico, agora viram union type de verdade nos tipos
gerados (`'not_connected' | 'connecting' | 'connected'` etc.), igual o que os DTOs escritos à mão
já tinham. Nenhum formato de rota mudou.

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
