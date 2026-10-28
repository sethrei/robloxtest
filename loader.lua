-- Menu hospedado em sethrei/robloxtest.
local URL = "https://raw.githubusercontent.com/sethrei/robloxtest/main/menu.lua"

-- HttpGet e loadstring dependem do ambiente executor; nao sao uma
-- integracao com Roblox e nao existem no Lua Desk local.
if game == nil or type(loadstring) ~= "function" then
    error("Este loader requer um ambiente Roblox com HttpGet e loadstring. Lua local nao possui essas APIs.", 0)
end

local fetched, source = pcall(function()
    return game:HttpGet(URL)
end)
if not fetched then
    error("Falha ao baixar o menu: " .. tostring(source), 0)
end
if type(source) ~= "string" or source == "" then
    error("O endereco retornou um conteudo vazio ou invalido.", 0)
end

local chunk, compileError = loadstring(source, "@menu-remoto")
if not chunk then
    error("Erro de sintaxe no menu: " .. tostring(compileError), 0)
end
local executed, runtimeError = pcall(chunk)
if not executed then
    error("Erro ao abrir o menu: " .. tostring(runtimeError), 0)
end
