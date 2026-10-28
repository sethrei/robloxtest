# Menu de ajustes locais

Menu em Lua/Luau com campo de visão, sombras, restauração e opção de fechar.

## Arquivos

- [menu.lua](menu.lua): interface e controles locais.
- [loader.lua](loader.lua): baixa o menu deste repositório, com tratamento de erros.

URLs Raw:

- https://raw.githubusercontent.com/sethrei/robloxtest/main/menu.lua
- https://raw.githubusercontent.com/sethrei/robloxtest/main/loader.lua

## Ambiente necessário

O menu depende das APIs cliente do Roblox, incluindo `game`, `Instance` e `PlayerGui`. Para testá-lo no Roblox Studio, use o conteúdo de `menu.lua` em um LocalScript em StarterPlayer > StarterPlayerScripts.

O loader depende adicionalmente de `game:HttpGet` e `loadstring`, que são específicos do ambiente de execução e não estão disponíveis em todos os contextos Roblox. Um interpretador Lua local, como Lua Desk, não fornece essas APIs nem integração com o cliente Roblox.

## Validação

Sintaxe dos arquivos verificada. Loader testado com respostas simuladas, incluindo sucesso e erros. A interface do menu ainda não foi testada dentro do Roblox.
