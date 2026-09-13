# Rota

Rota é um plugin de skill para desenhar e conduzir execução já autorizada. A saída padrão é um desenho curto no chat com objetivo, dependências, executor, ownership, limite de escrita, resultado, consolidação e condição de parada.

Ele preserva execução direta para tarefas simples e usa recursos de delegação apenas quando eles reduzem risco ou tempo sem criar disputa de arquivos. O desenho não é um runtime e não amplia autorização para publicar, executar ações destrutivas ou sair do pedido.

## Conteúdo

```text
plugins/rota/
├── .codex-plugin/plugin.json
├── .claude-plugin/plugin.json
└── skills/rota/SKILL.md
```

Os dois marketplaces na raiz apontam para `./plugins/rota`. A distribuição inicial é local e está deliberadamente sem instalação, publicação remota ou dependências de outro plugin.

## Validação

Na raiz do repositório:

```bash
bash scripts/validate-all.sh
```

O gate verifica manifests, marketplaces, o único ponto de entrada da skill e a ausência dos artefatos aposentados que não pertencem ao plugin.

## Proveniência

Versão `0.1.0`, criada a partir da seção 6 do plano aprovado de simplificação do Superflow. A seção define a fronteira do Rota; este repositório não carrega runtime, contratos ou arquivos de execução daquela ferramenta.
