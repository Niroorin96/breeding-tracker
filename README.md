# Breeding Tracker · Poke Idle World

Site gratuito para anotar cada breed do Poke Idle World e ver, em números, o que está compensando: quanto você gastou, quanto a qualidade subiu e qual método rende mais.

🔗 **Acesse:** https://piw-breeding.vercel.app/

🔒 **O site não se conecta ao jogo**
Ele não lê nem altera nada da sua conta no jogo. Só guarda o que você digita. Não pede e-mail, e o nick não precisa ser o mesmo do jogo. O código está todo aqui pra você conferir.

## O que é
Uma planilha de breeding pronta. Você cadastra o Pokémon, registra cada breed com os gastos e, quando termina, informa o resultado. O site soma tudo sozinho e mostra totais, médias, preços pagos e a evolução da qualidade em gráficos.

## Como usar
1. Entre com um nick e um PIN de 4 dígitos. Nick novo cria a conta na hora.
2. Clique em **+ Novo Pokémon**, informe o IV e a qualidade atuais e escolha a stone dele.
3. Antes de chocar, clique em **+ Novo breed**. Quando terminar, clique em **Resultado**.
4. De vez em quando, use **Exportar** pra guardar um backup.

## O que ele faz
- Registra cada breed: método (Grátis ou Feromônio), food, Double Stone e o que você comprou.
- Calcula o custo de cada breed: custo fixo ($2.000.000) + feromônio + food + stones. Só entra o que foi comprado.
- Mostra qualidade e IV inicial x atual, com a raridade (Fraca até Divina) e o ganho de cada breed.
- Gráficos clicáveis no painel geral e na página de cada Pokémon: custo por breed, gastos com food e stones, ganhos de qualidade, evolução da qualidade e Grátis vs Feromônio.
- Custo por +0,001 de qualidade, pra saber quanto cada pedacinho está saindo.
- Preço mínimo, médio, máximo e último pago em stones e foods.
- Linha do tempo com os breeds em andamento sempre no topo.
- Tabela de chances de cada método sempre à mão.
- Salva sozinho na nuvem e funciona em mais de um aparelho. Sem internet, guarda no aparelho e envia quando a conexão volta.
- Exportar e importar backup (.json).
- Modo claro e escuro, no PC, tablet e celular.

## Segurança
- O site guarda só o nick e os dados de breeding que você digita.
- O PIN de 4 dígitos é uma proteção simples. Não use um PIN que você usa em outros lugares.
- Depois de 8 PINs errados seguidos, a conta bloqueia por 15 minutos.
- Não existe recuperação automática de PIN. Se esquecer, o botão **Esqueceu o PIN?** no login explica como pedir um PIN temporário.
- O backup exportado não contém o seu PIN.

## Por dentro
O site inteiro é um único `index.html` (HTML, CSS e JavaScript puro, sem framework e sem build). Os dados ficam no Supabase, acessado só por funções (`piw_login`, `piw_register`, `piw_load`, `piw_save`) com a chave pública. Os gráficos são SVG desenhados no próprio código, sem biblioteca.

| Arquivo | Função |
|---|---|
| `index.html` | O site inteiro |
| `config.js` | URL e chave pública do Supabase, links do rodapé, imagens de fundo |
| `supabase_setup.sql` | Cria a tabela e as funções do banco |
| `ICO.png`, `BG_DARK.jpg`, `BG_LIGHT.jpg` | Ícone e imagens de fundo |

## Créditos
Desenvolvido por **Niroo**. Imagens e nomes dos Pokémon: [PokeAPI](https://pokeapi.co). Ícones das stones: site do Poke Idle World. Imagens de fundo: Pinterest/Reddit.

Projeto de fã e independente, sem ligação com o Poke Idle World, a Nintendo, a Game Freak ou a The Pokémon Company.

## Licença
MIT. A licença vale para o código; imagens de fundo, sprites e ícones pertencem aos seus donos.
