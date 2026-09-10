#!/usr/bin/env bash
# Copia o swagger.yaml gerado no dita_core (a partir de request specs reais, rswag) pra este
# repo. Assume o layout padrão do projeto: dita_core e dita-api-contract são pastas irmãs.
#
# Uso:
#   1. No dita_core: RAILS_ENV=test bundle exec rspec spec/requests && \
#      RAILS_ENV=test bundle exec rake rswag:specs:swaggerize
#   2. Aqui: ./scripts/sync-from-dita-core.sh
#   3. Revisar o diff em git, decidir o bump de versão (major/minor/patch conforme o que mudou),
#      atualizar package.json + CHANGELOG.md, e taggear (ver README.md).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$REPO_ROOT/../dita_core/swagger/v1/swagger.yaml"

if [ ! -f "$SOURCE" ]; then
  echo "Não achei $SOURCE — rode 'bundle exec rake rswag:specs:swaggerize' no dita_core primeiro." >&2
  exit 1
fi

cp "$SOURCE" "$REPO_ROOT/openapi.yaml"
echo "Copiado de $SOURCE"
echo "Confira o diff: git -C '$REPO_ROOT' diff openapi.yaml"
