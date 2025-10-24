-- GameState Module
-- Manages persistent game data, save/load operations, and player progress
-- Handles multiple save files with JSON serialization

local gamestate = {}
local json = require('source.json')

-- Current save file path
local currentSaveFile = nil

-- Default game state structure
gamestate.data = {
    lastSaveTime = 0,           -- Last auto-save timestamp
    timeSinceLastSave = 0,      -- Time since last save (for auto-save timer)
    playtime = 0,               -- Total time played across all sessions
    gameStarted = false,        -- Whether main game is active
    lastClosedTime = nil,       -- Timestamp when game was last closed
    timeSinceClosed = nil,      -- Calculated offline time
    showTimeSinceClosed = false,-- Whether to show offline time notification
    showTimeSinceClosedTimer = 0, -- Timer for hiding notification
    gachaSpeed = 1.0,          -- Animation playback speed multiplier
    firstRun = nil,            -- Timestamp of first game launch
    saveName = "Player",       -- Player's chosen save name
    animationFrame = 1,        -- Current animation frame position
    sessionTime = 0,           -- Time played in current session
    characters = {},           -- Character counts indexed by ID
    inventory = {}             -- Inventory items indexed by ID
}

-- ============================================================================
-- SAVE FILE MANAGEMENT
-- ============================================================================

-- Generate save file path from player name
-- Sanitizes player name to prevent file system issues
local function getSaveFileName(playerName)
    return 'SaveGames/savegame-' .. (playerName or 'Player'):gsub('[^%w%-_]', '') .. '.json'
end

-- Save current game state to JSON file
-- Creates SaveGames directory if needed, handles file renaming
function gamestate.save()
    -- Ensure save directory exists
    if not love.filesystem.getInfo('SaveGames') then
        love.filesystem.createDirectory('SaveGames')
    end
    
    -- Update close time for offline calculation
    gamestate.data.lastClosedTime = os.time()
    local newSaveFile = getSaveFileName(gamestate.data.saveName)
    
    -- Handle save file renaming if player changed name
    if currentSaveFile and currentSaveFile ~= newSaveFile and love.filesystem.getInfo(currentSaveFile) then
        local oldData = love.filesystem.read(currentSaveFile)
        love.filesystem.write(newSaveFile, oldData)
        love.filesystem.remove(currentSaveFile)
    end
    
    -- Update inventory in game state before saving
    local inventory = require('source.inventory')
    inventory.updateGameState(gamestate.data)
    
    -- Write game data to file (exclude calculated fields)
    currentSaveFile = newSaveFile
    local dataToSave = {}
    for k, v in pairs(gamestate.data) do
        if k ~= 'timeSinceClosed' and k ~= 'showTimeSinceClosed' and k ~= 'showTimeSinceClosedTimer' then
            dataToSave[k] = v
        end
    end
    local saveData = json.encode(dataToSave)
    love.filesystem.write(currentSaveFile, saveData)
    gamestate.data.lastSaveTime = love.timer.getTime()
    
    -- Update settings with current player name
    local settings = require('source.settings')
    settings.settings.lastPlayerName = gamestate.data.saveName
    settings.save()
    
    print("Game saved to: " .. currentSaveFile)
end

function gamestate.updateSaveName(newName)
    if newName and newName ~= "" then
        gamestate.data.saveName = newName
        gamestate.save()
    end
end

local function findLatestSaveFile()
    if not love.filesystem.getInfo('SaveGames') then
        love.filesystem.createDirectory('SaveGames')
    end
    
    local files = love.filesystem.getDirectoryItems('SaveGames')
    local saveFiles = {}
    
    for _, file in ipairs(files) do
        if file:match('.*%.json$') and file:match('savegame') then
            local info = love.filesystem.getInfo('SaveGames/' .. file)
            if info then
                table.insert(saveFiles, {name = 'SaveGames/' .. file, modtime = info.modtime})
            end
        end
    end
    
    if #saveFiles == 0 then return nil end
    
    table.sort(saveFiles, function(a, b) return a.modtime > b.modtime end)
    return saveFiles[1].name
end

function gamestate.resetSessionTime()
    gamestate.data.sessionTime = 0
end

function gamestate.createNewWithName(saveName)
    -- Reset to default state
    gamestate.data = {
        lastSaveTime = 0,
        timeSinceLastSave = 0,
        playtime = 0,
        gameStarted = false,
        lastClosedTime = nil,
        timeSinceClosed = nil,
        showTimeSinceClosed = false,
        showTimeSinceClosedTimer = 0,
        showSettings = false,
        gachaSpeed = 1.0,
        firstRun = os.time(),
        saveName = saveName,
        animationFrame = 1,
        sessionTime = 0,
        characters = {}
    }
    currentSaveFile = nil
    
    -- Update settings to use new save
    local settings = require('source.settings')
    settings.settings.lastPlayerName = saveName
    settings.save()
end

function gamestate.createNew()
    -- Find unique save name
    local saveName = "Unnamed"
    local counter = 1
    while love.filesystem.getInfo(getSaveFileName(saveName)) do
        saveName = "Unnamed" .. counter
        counter = counter + 1
    end
    
    -- Reset to default state
    gamestate.data = {
        lastSaveTime = 0,
        timeSinceLastSave = 0,
        playtime = 0,
        gameStarted = false,
        lastClosedTime = nil,
        timeSinceClosed = nil,
        showTimeSinceClosed = false,
        showTimeSinceClosedTimer = 0,
        showSettings = false,
        gachaSpeed = 1.0,
        firstRun = os.time(),
        saveName = saveName,
        animationFrame = 1,
        sessionTime = 0,
        characters = {}
    }
    currentSaveFile = nil
    
    -- Update settings to use new save
    local settings = require('source.settings')
    settings.settings.lastPlayerName = saveName
    settings.save()
end

function gamestate.load()
    local settings = require('source.settings').settings
    local saveFile = getSaveFileName(settings.lastPlayerName)
    
    -- If the preferred save doesn't exist, find the latest one
    if not love.filesystem.getInfo(saveFile) then
        saveFile = findLatestSaveFile() or saveFile
    end
    
    currentSaveFile = saveFile
    
    if not love.filesystem.getInfo(saveFile) then
        gamestate.data.firstRun = os.time()
    end
    
    if love.filesystem.getInfo(saveFile) then
        local saveData = love.filesystem.read(saveFile)
        local success, loadedState = pcall(function()
            return json.decode(saveData)
        end)
        if success then
            for k, v in pairs(loadedState) do
                gamestate.data[k] = v
            end
            -- Ensure saveName has a default if not in save file
            if not gamestate.data.saveName then
                gamestate.data.saveName = "Player"
            end
            -- Initialize characters table if missing
            if not gamestate.data.characters then
                gamestate.data.characters = {}
            end
            -- Initialize inventory table if missing
            if not gamestate.data.inventory then
                gamestate.data.inventory = {}
            end
            if gamestate.data.lastClosedTime then
                local now = os.time()
                gamestate.data.timeSinceClosed = now - gamestate.data.lastClosedTime
            else
                gamestate.data.timeSinceClosed = nil
            end
            print("Game loaded from: " .. saveFile)
        end
    end
end

-- ============================================================================
-- OFFLINE PROGRESSION
-- ============================================================================

-- Calculate and execute offline summons based on time away
-- Called before switching to playing state
function gamestate.processOfflineTime()
    if not gamestate.data.timeSinceClosed or gamestate.data.timeSinceClosed <= 0 then
        return 0
    end
    
    print("Time offline: " .. gamestate.data.timeSinceClosed .. " seconds")
    
    -- Calculate summons based on animation loop time (half speed offline)
    local frameRate = 1/29.5  -- Base frame rate (29.5 FPS)
    local maxFrames = 4047    -- Total frames per loop
    local loopTime = frameRate * maxFrames / gamestate.data.gachaSpeed * 2  -- Half speed offline
    local offlineSummons = math.floor(gamestate.data.timeSinceClosed / loopTime)
    
    print("Loop time: " .. loopTime .. " seconds, Offline summons: " .. offlineSummons)
    
    if offlineSummons > 0 then
        local charactersModule = require('source.characters')
        print("Processing " .. offlineSummons .. " offline summons...")
        
        -- Only add duplicates of existing characters with rarity weighting
        for i = 1, offlineSummons do
            local rarityRoll = love.math.random(1, 1000000)
            local selectedRarity
            if rarityRoll <= 400000 then
                selectedRarity = 1
            elseif rarityRoll <= 650000 then
                selectedRarity = 2
            elseif rarityRoll <= 800000 then
                selectedRarity = 3
            elseif rarityRoll <= 900000 then
                selectedRarity = 4
            elseif rarityRoll <= 960000 then
                selectedRarity = 5
            elseif rarityRoll <= 990000 then
                selectedRarity = 6
            elseif rarityRoll <= 998000 then
                selectedRarity = 7
            elseif rarityRoll <= 999500 then
                selectedRarity = 8
            elseif rarityRoll <= 999900 then
                selectedRarity = 9
            else
                selectedRarity = 10
            end
            
            local ownedOfRarity = {}
            for charId, count in pairs(gamestate.data.characters) do
                if count > 0 then
                    local characterInfo = charactersModule.getCharacterInfo(tonumber(charId))
                    if characterInfo and characterInfo.rarity == selectedRarity then
                        table.insert(ownedOfRarity, charId)
                    end
                end
            end
            
            if #ownedOfRarity > 0 then
                local randomOwnedId = ownedOfRarity[love.math.random(1, #ownedOfRarity)]
                gamestate.data.characters[randomOwnedId] = gamestate.data.characters[randomOwnedId] + 1
                
                if i <= 10 then
                    local characterInfo = charactersModule.getCharacterInfo(tonumber(randomOwnedId))
                    local characterName = characterInfo and characterInfo.name or "Unknown"
                    print("Offline duplicate " .. i .. ": " .. characterName .. " (ID: " .. randomOwnedId .. ")")
                elseif i == 11 then
                    print("... (" .. (offlineSummons - 10) .. " more duplicates processed silently)")
                end
            else
                print("No owned characters of rarity " .. selectedRarity .. " found")
            end
        end
    end
    
    return offlineSummons
end

-- ============================================================================
-- GAME STATE UPDATE
-- ============================================================================

-- Update game state timers and handle auto-save
-- Called every frame by main.lua during active gameplay
function gamestate.update(dt)
    if gamestate.data.gameStarted then
        -- Update time tracking
        gamestate.data.playtime = gamestate.data.playtime + dt
        gamestate.data.timeSinceLastSave = gamestate.data.timeSinceLastSave + dt
        gamestate.data.sessionTime = gamestate.data.sessionTime + dt
        
        -- Handle offline time notification timer
        if gamestate.data.showTimeSinceClosed then
            gamestate.data.showTimeSinceClosedTimer = gamestate.data.showTimeSinceClosedTimer - dt
            if gamestate.data.showTimeSinceClosedTimer <= 0 then
                gamestate.data.showTimeSinceClosed = false
            end
        end
        
        -- Removed interval-based auto-save (now only autosave on summon)
    end
end

return gamestate