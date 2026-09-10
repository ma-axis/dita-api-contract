# dita-api-contract

Contrato OpenAPI da API do Dita (`openapi.yaml`) — **não é escrito à mão**. É gerado no `dita_core`
a partir de request specs reais (rswag): o contrato só existe se o spec correspondente realmente
passar contra o banco de teste. Ver `dita_core/.claude/AGENTS.md` seção 8.9 para como esses specs
são escritos e rodados.

Este repo existe só pra dar a esse spec uma **versão e um ciclo de publicação independentes** dos
três apps que o consomem (`dita_core` o produz, `dita_web`/`dita_mobile` o consomem via
[Kubb](https://kubb.dev)) — sem isso, cada app teria que sincronizar o spec manualmente e não
haveria como saber, olhando só o número da versão, se uma mudança de API é aditiva ou quebra algo.

## Como atualizar o contrato

1. No `dita_core`, depois de mudar algum controller/spec:
   ```bash
   RAILS_ENV=test bundle exec rspec spec/requests
   RAILS_ENV=test bundle exec rake rswag:specs:swaggerize
   ```
2. Aqui: `./scripts/sync-from-dita-core.sh` (copia o `swagger.yaml` gerado pra `openapi.yaml`).
3. Revise o diff (`git diff openapi.yaml`) e decida o bump de versão:
   - **patch** (`0.1.0` → `0.1.1`): descrição/exemplo mudou, formato da API igual.
   - **minor** (`0.1.0` → `0.2.0`): rota ou campo novo, nada quebrou pra quem já consome.
   - **major** (`0.1.0` → `1.0.0`): rota removida, campo obrigatório mudou de tipo/sumiu — quem
     consome via Kubb vai ver erro de TypeScript ao atualizar a dependência, de propósito.
4. Atualize `version` no `package.json`, adicione uma entrada no `CHANGELOG.md`, commit, e crie
   uma tag `git tag vX.Y.Z && git push --tags` (depois de publicado no GitHub — ver abaixo).

## Como consumir (dita_web / dita_mobile)

**Estado atual (dev local, sem remoto no GitHub ainda)**: dependência local por caminho relativo.
```json
"@dita/api-contract": "file:../dita-api-contract"
```
`npm install` cria um symlink — mudanças aqui refletem imediatamente nos apps sem precisar
republicar nada. Bom pra desenvolvimento, mas **não é uma versão real fixada**: qualquer um que
clone os frontends sem ter este repo na mesma pasta não consegue instalar.

**Próximo passo (pendente — precisa de `gh` autenticado ou acesso manual ao GitHub, não disponível
neste ambiente)**: publicar como `github:ma-axis/dita-api-contract` e trocar a dependência nos dois
frontends para apontar numa tag específica:
```json
"@dita/api-contract": "github:ma-axis/dita-api-contract#v0.1.0"
```
Isso é o que torna o "versionado" de verdade — cada frontend escolhe quando atualizar, e o bump é
uma ação deliberada (`npm install @dita/api-contract@github:ma-axis/dita-api-contract#v0.2.0`), não
algo que muda sozinho.

Depois de instalado (de qualquer uma das duas formas), cada frontend roda `npm run generate:api`
(script do Kubb, ver `kubb.config.ts` em cada app) apontando pro `openapi.yaml` deste pacote.
