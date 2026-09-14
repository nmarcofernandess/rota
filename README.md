# Rota

Rota é um plugin de skill para desenhar no chat uma execução multiagente antes
de rodá-la. A saída mostra objetivo, nós, dependências, executor/modelo,
ownership, limite de escrita, retorno, pior caso, consolidação e parada; depois
espera a aprovação explícita do operador.

Ele preserva execução direta para tarefas simples e usa recursos de delegação apenas quando eles reduzem risco ou tempo sem criar disputa de arquivos. O desenho não é runtime, não exige arquivo e não amplia autorização para publicar, executar ações destrutivas ou sair do pedido.

## Conteúdo

```text
plugins/rota/
├── .codex-plugin/plugin.json
├── .claude-plugin/plugin.json
└── skills/rota/SKILL.md
```

Os dois marketplaces na raiz apontam para `./plugins/rota`. O plugin não depende de Superflow, pstack ou um runtime de workflows.

## Instalação e atualização

Codex:

```bash
codex plugin marketplace add nmarcofernandess/rota --ref v0.1.0
codex plugin add rota@rota
```

Claude Code:

```bash
claude plugin marketplace add nmarcofernandess/rota@v0.1.0
claude plugin install rota@rota
```

Para releases posteriores, atualize a referência de tag do marketplace no host, atualize seu catálogo e reinstale/atualize `rota@rota`. Abra uma nova task para recarregar as skills. Instalar Rota não converte instruções ou projetos automaticamente.

## Validação

Na raiz do repositório:

```bash
bash scripts/validate-all.sh
```

O gate verifica manifests, marketplaces, o único ponto de entrada da skill e a ausência dos artefatos aposentados que não pertencem ao plugin.

## Proveniência

Versão `0.1.0`, publicada sob licença MIT. Rota concentra o protocolo de coordenação em uma única skill, independente de ferramenta, modelo ou projeto específico.
