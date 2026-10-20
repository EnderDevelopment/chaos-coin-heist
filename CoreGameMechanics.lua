-- CoreGameMechanics.lua

-- Services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ChaosCoinsModule = require(ServerStorage:WaitForChild("ChaosCoinsModule"))
local BaseModule = require(ServerStorage:WaitForChild("BaseModule"))
local DisasterModule = require(ServerStorage:WaitForChild("DisasterModule"))
local ShopModule = require(ServerStorage:WaitForChild("ShopModule"))
local LeaderboardModule = require(ServerStorage:WaitForChild("LeaderboardModule"))

-- Variables
local chaosCoins = {}
local bases = {}
local disasters = {}
local shopItems = {}
local leaderboard = {}

-- Player Added
Players.PlayerAdded:Connect(function(player)
    -- Initialize player data
    chaosCoins[player] = ChaosCoinsModule.new(player)
    bases[player] = BaseModule.new(player)
    
    -- Player Removing
    player.CharacterRemoving:Connect(function()
        -- Clean up player data
        chaosCoins[player] = nil
        bases[player] = nil
    end)
end)

-- Start disasters
DisasterModule.startDisasters(disasters)

-- Initialize shop
ShopModule.initializeShop(shopItems)

-- Initialize leaderboard
LeaderboardModule.initializeLeaderboard(leaderboard)

-- Remote Events
local remoteEvents = Instance.new("Folder", ReplicatedStorage)
remoteEvents.Name = "RemoteEvents"

local buyItemEvent = Instance.new("RemoteEvent", remoteEvents)
buyItemEvent.Name = "BuyItemEvent"

buyItemEvent.OnServerEvent:Connect(function(player, itemId)
    ShopModule.buyItem(player, itemId, chaosCoins, shopItems)
end)

local updateLeaderboardEvent = Instance.new("RemoteEvent", remoteEvents)
updateLeaderboardEvent.Name = "UpdateLeaderboardEvent"

updateLeaderboardEvent.OnServerEvent:Connect(function(player, score)
    LeaderboardModule.updateLeaderboard(player, score, leaderboard)
end)