---
name: rota
description: Desenha e conduz execução autorizada com dependências, ownership, limites de escrita e consolidação verificável. Use quando a tarefa realmente se beneficia de coordenação entre agentes.
---

# Rota

Use Rota somente depois de o pedido autorizar a execução. Ele organiza trabalho que precisa de coordenação; uma tarefa simples continua direta, sem agentes extras.

## Desenho no chat

Antes de delegar, responda no chat com um diagrama curto e legível. Inclua:

- objetivo e critério verificável de pronto;
- nós, dependências e executor de cada nó;
- ownership e limite exato de escrita de cada executor;
- entrada, resultado esperado e validação de cada nó;
- responsável pela consolidação e condição de parada.

O diagrama é comunicação, não um arquivo executável. Não crie arquivos de run, logs ou briefings por padrão. Persista contexto somente quando a continuidade da entrega ou a convenção do projeto justificar.

```text
Objetivo: <resultado autorizado e verificável>

N1 — <executor>: <ação> → <resultado>
     escrita: <paths ou sem escrita>
N2 — <executor>, depende de N1: <ação> → <resultado>
     escrita: <paths ou sem escrita>
Consolidação — <executor>: <o que será inspecionado e validado>
Parada: <quando devolver ao operador>
```

Escolha modelos pelas capacidades reais expostas no ambiente e pelo custo e risco da tarefa. Não invente modelos, tabelas pessoais ou equivalências fixas. Se não houver escolha disponível, use a configuração vigente e diga essa limitação no desenho.

## Execução

Use as ferramentas de delegação nativas disponíveis. Execute em série quando não houver subagentes, quando um nó depende do anterior, quando as escritas se sobrepõem ou quando a coordenação não reduz risco. Paralelize apenas nós independentes, com ownership disjunto e quando as políticas locais permitirem.

Cada executor recebe objetivo, fontes necessárias, paths sob sua responsabilidade, permissões já concedidas, resultado esperado e critério terminal. Um executor pode editar um arquivo existente ou retornar uma conclusão sem escrever arquivo.

Falha rotineira pertence ao executor: investigar, corrigir dentro do escopo e repetir a validação aplicável. Escale somente mudança material de escopo, conflito real de ownership, acesso ausente, decisão de produto/arquitetura ou ação externa/destrutiva sem autorização.

Se uma ferramenta ou subagente estiver indisponível, adapte a sequência para execução serial e registre a limitação. Se a disponibilidade de modelos mudar, reavalie os nós ainda não iniciados; não reatribua trabalho em andamento sem preservar ownership e contexto.

## Consolidação e parada

Uma mensagem de conclusão não prova entrega. O consolidador inspeciona o resultado prometido e a validação exigida: arquivo e diff quando houve escrita, saída de teste quando ela é o critério, ou evidência da fonte quando o nó é somente leitura. Também confirma dependências, ownership respeitado e falhas parciais resolvidas ou explicitamente devolvidas.

Pare imediatamente se o operador pedir parada. Pare e peça direção quando a continuação exigir nova autorização, criar conflito de ownership ou ultrapassar o limite de escrita. O desenho nunca amplia permissão para publicar, executar ação destrutiva ou agir fora do pedido.

## Exemplos compactos

### Editar um arquivo existente

```text
Objetivo: corrigir o README já existente e validar links locais.

N1 — agente de docs: atualizar docs/README.md → diff focado e links corrigidos
     escrita: docs/README.md
Consolidação — coordenador: inspecionar diff e rodar o verificador de links
Parada: links válidos e diff sem mudanças fora do arquivo
```

### Responder sem criar arquivo

```text
Objetivo: decidir se duas APIs têm o mesmo contrato.

N1 — analista: comparar as fontes primárias → conclusão citada no chat
     escrita: sem escrita
Consolidação — coordenador: conferir fontes citadas e responder a decisão
Parada: conclusão suficiente para a próxima decisão humana
```

### Dependência serial

```text
Objetivo: corrigir um teste que depende de entender o contrato atual.

N1 — analista: localizar o contrato e o caso mínimo → retorno citado
     escrita: sem escrita
N2 — implementador, depende de N1: corrigir teste e código → teste verde
     escrita: src/parser.ts, src/parser.test.ts
Consolidação — coordenador: revisar diff e executar o teste afetado
Parada: teste passa e o contrato de N1 continua atendido
```

### Paralelo permitido

```text
Objetivo: concluir documentação e validação independentes.

N1 — docs: atualizar README.md → texto revisado
     escrita: README.md
N2 — validação: executar a suíte indicada → resultado reproduzível
     escrita: sem escrita
Consolidação — coordenador: inspecionar README e resultado da suíte
Parada: ambos os resultados atendem os critérios sem sobreposição de arquivos
```
