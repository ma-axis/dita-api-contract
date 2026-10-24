# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/). Versionamento semântico:
**major** = rota removida ou campo obrigatório mudou de forma incompatível; **minor** = rota ou
campo novo (aditivo); **patch** = descrição/exemplo/correção sem mudar formato.

## [0.12.0] - 2026-10-25

Minor: perguntas do produto genéricas. Novo `POST /products/{id}/own_questions` (separa as perguntas para o produto,
criando um conjunto só dele quando estavam compartilhadas) e documentação de `POST /products/{id}/duplicate` e
`PATCH /products/bulk`, que já existiam desde a 0.11.0 sem estar no contrato. O tipo de produto no detalhe do produto ganha
`shared_with` e `shared_count`. Os modelos globais (Pizza, Bebida com sabor etc.) deixaram de existir: `system` continua no
formato, mas vem sempre `false`. `/presets` devolve só as perguntas e listas que servem ao ramo da empresa.

## [0.11.0] - 2026-10-25

Minor: "pronto em minutos". Novos endpoints de kits (`/presets`, `/presets/kits/{kit}`, `/presets/questions/{question}`,
`/presets/neighborhoods`), onboarding (`/onboarding`), importação de lista (`/imports`, `/imports/commit`) e de produto
(`/products/{id}/duplicate`, `/products/bulk`). `Product` ganha `status` (`active`/`draft`), `source` e `sold_out_until`
("acabou hoje"); `Company` ganha `business_template` e `city`. Os endpoints novos ainda são consumidos por chamadas
escritas à mão nos frontends. Também: `POST /orders/{id}/confirm_delivery` (o atendente confirma a entrega e o valor, ou passa
para retirada, de um pedido pré-solicitado) e `Conversation.pending_delivery_order`.

## [0.10.0] - 2026-10-25

Minor: motor de vendas. Novos endpoints de tipos de produto (`/companies/{id}/product_types`, `/fields`,
`/duplicate`), conjuntos de campos (`/field_sets`) e simulador (`/simulator`, `/simulator/messages`).
`Product` ganha `product_type_id`, `unit`, `aliases`, `stock_quantity`, `extra_field_set_ids` e
`specifications`; o detalhe do produto devolve `product_type` com os campos. `Order` ganha `order_items` e
`checkout`; `Company` ganha `checkout_settings` e o recurso `sales_engine` em `settings.features`.
Os endpoints novos ainda são consumidos por chamadas escritas à mão nos frontends.

## [0.9.0] - 2026-10-24

Minor: novo `DELETE /conversations/{id}` — exclui a conversa do Dita com as mensagens e os orçamentos que não
viraram pedido (204). Conversa que gerou pedido não pode ser excluída (422 com `error`). Não afeta o WhatsApp
nem o cadastro do cliente.

## [0.8.0] - 2026-10-17

Minor (com remoção): `POST /auth/signup` foi removido; contas passam a ser criadas por outro painel, fora do
Dita. Novo `POST /support_requests` (autenticado, 5 por hora por usuário) para abrir chamado de suporte;
devolve `id` e `protocol`. `Company.settings.notifications` aceita `quota_email`, `whatsapp_disconnected_email`
e `new_order_email`, além de `handoff_email` (que agora vale `true` por padrão quando ausente).

## [0.7.0] - 2026-10-11

Minor: campos novos para LGPD, plano e privacidade. `POST /auth/signup` exige `accept_terms`; o usuário
(`user`) das respostas de auth ganha `terms_outdated`; `Company` ganha `plan` e `period_ends_at`;
`Customer` (detalhe) ganha `anonymized_at`, `reminders_opted_out_at` e `conversations`; o `role` das
mensagens ganha o valor `human` (mensagem enviada pelo dono). Os endpoints novos (`/account`, `faq_items`,
`requirements`, `cancel`, `take_over`, `resume_bot`, `messages`, `export`, `anonymize`, `reminders`) ainda
não estão documentados no contrato — são consumidos por chamadas escritas à mão nos frontends.

## [0.6.0] - 2026-09-27

Minor: `Company` ganha `description` (nullable) — contexto livre da empresa usado como base pro
prompt de sistema da IA (`GenerateResponseService`), além do nome. `PATCH /companies/{id}` aceita
`description` no corpo.

## [0.5.0] - 2026-09-18

Minor: `Company.settings` ganha forma real — antes era `{ nullable: true }` solto (jsonb sem
tipagem nenhuma no contrato), agora documenta `settings.features` (`ai_response`,
`reminders_due_soon`, `collections_overdue`, todos boolean/nullable) — os três subprodutos
ativáveis por empresa (responder automaticamente, lembrete de vencimento próximo, cobrança de
atraso). `PATCH /companies/{id}` aceita `settings.features` no corpo.

## [0.4.1] - 2026-09-15

Minor: `GET /companies/{company_id}/orders` (index/listagem) passa a incluir `contract` também —
antes só o `show` de um pedido trazia isso. Necessário pra tela de pedidos mostrar/anexar o
contrato assinado sem uma chamada extra por pedido.

## [0.4.0] - 2026-09-11

Minor: anexos (Active Storage) em Contract e Installment, e rota nova de "atrasos do dia".

- Contract ganha `file_url`/`file_filename`/`file_content_type` (o PDF/imagem assinado); `content`
  deixa de ser obrigatório (`required`) — agora é válido ter só o arquivo, sem texto digitado.
- Installment ganha `receipt_url`/`receipt_filename`/`receipt_content_type` (comprovante de
  pagamento).
- Rota nova `GET /companies/{company_id}/reports/overdue_installments`: lista as parcelas
  vencidas (pending ou overdue com due_date no passado) ordenadas por vencimento, cada uma com o
  pedido e o cliente embutidos — alimenta a seção "Atrasos do dia" do dashboard.
- Upload dos arquivos em si é multipart (`POST .../contract` e `PATCH .../installments/:id/pay`
  aceitam `file`/`receipt` opcionais) e continua fora deste contrato, mesmo motivo de sempre
  (rswag não documenta corpo multipart).

## [0.3.7] - 2026-09-10

Patch: `status` de Conversation deixa de ser `nullable` — a state machine (AASM) sempre define um
estado inicial (`unassigned`) na criação, nunca fica null de verdade.

## [0.3.6] - 2026-09-10

Patch: request bodies de Auth (sign_in, signup, password forgot/reset) tinham todos os campos
opcionais — nenhum tinha `required`, então o Kubb gerava `user?: {email?: string; ...}` mesmo
sendo campos obrigatórios de verdade nos controllers. Completado `required` em todos os quatro.

## [0.3.5] - 2026-09-10

Patch: dois problemas achados ao migrar o frontend pros tipos gerados (dita_web). (1)
`created_at`/`updated_at` viravam `unknown`/opcional em quase todo model (Order, Installment,
Contract, ContractTemplate, ProductRequirement, Product, Company, Conversation) — as colunas são
`null: false` no banco (timestamps padrão do Rails), agora `required` em todos os schemas. (2) O
relatório de adimplência (`GET .../reports/delinquency`) tinha `total_receivable`/`total_overdue`/
`total_paid` sem tipo nenhum (`schema` vazio, gerava `unknown`) — são `BigDecimal` de um `.sum(...)`
que o Rails serializa como string no JSON (confirmado rodando o service de verdade), agora
`type: string`. `paid_installments_count`/`paid_on_time_count` também viram `required` (sempre
presentes, só não estavam declarados).

## [0.3.4] - 2026-09-10

Patch: `created_at` do Customer (index/show/create/update) passa de opcional pra `required` —
`customers.created_at` é `null: false` no banco, sempre presente na resposta.

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
