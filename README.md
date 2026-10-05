# Breeding Tracker · Poke Idle World

Site gratuito para anotar e acompanhar tentativas de breeding no Poke Idle World:
quanto você gastou, quanto a qualidade subiu e o que está compensando.

> Projeto de fã, feito para a comunidade. Não é afiliado ao Poke Idle World, à Nintendo ou à Game Freak.

## Funcionalidades
- Registro de cada breed: Pokémon inicial, food, método (Grátis ou Feromônio) e Double Stone.
- Controle de gastos em $: food, stones, feromônio e custo fixo.
- Stone fixa por Pokémon (até 2 tipos).
- Qualidade e IV inicial x atual, com raridade e ganho de cada breed.
- Linha do tempo com breeds em andamento sempre visíveis.
- Painel geral e página por Pokémon com gráficos clicáveis.
- Preço mínimo, médio e máximo pago em stones e foods.
- Login com nick + PIN de 4 dígitos (sem e-mail), dados salvos na nuvem.
- Exportar e importar backup (.json).
- Modo claro e escuro.

## Como usar
1. Entre com o nick do jogo (ou outro nick que queira usar) e um PIN de 4 dígitos (nick novo cria a conta).
2. Clique em "+ Novo Pokémon" e escolha a stone que ele usa.
3. Em cada Pokémon, use "+ Novo breed", e depois "Resultado" quando o breed terminar.
4. Use Exportar de vez em quando para guardar um backup.

O site não se conecta ao jogo: ele só guarda o que você digita.

## Estrutura
| Arquivo | Função |
|---|---|
| `index.html` | O site inteiro (HTML, CSS e JS) |
| `config.js` | URL e chave pública do Supabase, links do rodapé, imagens de fundo |
| `supabase_setup.sql` | Cria a tabela e as funções no banco |
| `ICO.png`, `BG_DARK.jpg`, `BG_LIGHT.jpg` | Ícone e imagens de fundo |

## Publicar sua própria cópia
1. Crie um projeto no [Supabase](https://supabase.com) e rode `supabase_setup.sql` no SQL Editor.
2. Preencha `SB_URL` e `SB_KEY` (chave pública) no `config.js`.
3. Importe este repositório no [Vercel](https://vercel.com) (Framework Preset: Other).

## Segurança
- O PIN de 4 dígitos é uma proteção simples. Não use um PIN que você usa em outros lugares.
- A conta bloqueia por 15 minutos após 8 PINs errados seguidos.
- Não há recuperação automática de PIN.
- Não armazenamos dados sensíveis 

## Créditos
- Desenvolvido por Niroo
- Sprites e dados de nomes: [PokeAPI](https://pokeapi.co)
- Imagens de fundo: (Pinterest/Reddit)