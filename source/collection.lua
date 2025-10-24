local collection = {}

local mysteryTexture = nil
local scrollOffset = 0
local isDragging = false
local dragStartY = 0
local dragStartOffset = 0
local selectedCharacterId = nil
local selectedTileX = 0
local selectedTileY = 0
local popoutX = 0
local popoutY = 0
local scrollVelocity = 0
local lastMouseY = 0
local textureCache = {}
local currentPanelWidth = 0
local currentPanelHeight = 0

function collection.init()
    if love.filesystem.getInfo("assets/mystery_character-1.png (13).png") then
        mysteryTexture = love.graphics.newImage("assets/mystery_character-1.png (13).png")
    end
    lastMouseY = nil  -- Initialize as nil to detect first mouse movement
end

function collection.draw(panelX, panelY, panelWidth, panelHeight)
    -- Store panel dimensions for use in other functions
    currentPanelWidth = panelWidth
    currentPanelHeight = panelHeight
    
    local tileSize = 80
    local padding = 10
    local tilesPerRow = math.floor((panelWidth - padding * 2) / (tileSize + padding))
    
    local charactersModule = require('source.characters')
    local sortedChars = charactersModule.getSortedCharacters()
    local totalTiles = #sortedChars
    
    local totalRows = math.ceil(totalTiles / tilesPerRow)
    
    -- Calculate centering offset
    local gridWidth = tilesPerRow * tileSize + (tilesPerRow - 1) * padding
    local centerOffset = (panelWidth - gridWidth) / 2
    
    love.graphics.setScissor(panelX, panelY, panelWidth, panelHeight)
    
    for i = 1, totalTiles do
        local col = (i - 1) % tilesPerRow
        local row = math.floor((i - 1) / tilesPerRow)
        local x = panelX + centerOffset + col * (tileSize + padding)
        local y = panelY + padding + row * (tileSize + padding) + scrollOffset
        
        if y + tileSize > panelY and y < panelY + panelHeight then
            local charId = sortedChars[i].id
            local texturePath = charactersModule.getCharacterTexture(charId)
            local texture = textureCache[texturePath]
            
            if not texture and love.filesystem.getInfo(texturePath) then
                texture = love.graphics.newImage(texturePath)
                textureCache[texturePath] = texture
            end
            
            if texture then
                -- Check if character is discovered (owned) or not
                local gamestate = require('source.gamestate')
                local isDiscovered = gamestate.data.characters and gamestate.data.characters[tostring(charId)] and gamestate.data.characters[tostring(charId)] > 0
                
                if isDiscovered then
                    -- Draw discovered character: rarity-specific character tile + basic character texture overlay
                    local charactersModule = require('source.characters')
                    local charInfo = charactersModule.getCharacterInfo(charId)
                    
                    if charInfo then
                        -- Get the appropriate rarity character tile image (for discovered characters)
                        local rarityName = charactersModule.getRarityName(charInfo.rarity):lower()
                        local characterTilePath = "assets/collectionsTiles/" .. rarityName .. "_tile.png"
                        
                        local characterTile = textureCache[characterTilePath]
                        if not characterTile and love.filesystem.getInfo(characterTilePath) then
                            characterTile = love.graphics.newImage(characterTilePath)
                            textureCache[characterTilePath] = characterTile
                        end
                        
                        if characterTile then
                            love.graphics.setColor(1, 1, 1, 1)
                            love.graphics.draw(characterTile, x, y, 0, tileSize/characterTile:getWidth(), tileSize/characterTile:getHeight())
                        end
                        
                        -- Draw the basic character texture overlay
                        love.graphics.setColor(1, 1, 1, 1) -- Fully opaque
                        love.graphics.draw(texture, x, y, 0, tileSize/texture:getWidth(), tileSize/texture:getHeight())
                    else
                        -- Fallback if character info not found
                        love.graphics.setColor(1, 1, 1, 1)
                        love.graphics.draw(texture, x, y, 0, tileSize/texture:getWidth(), tileSize/texture:getHeight())
                    end
                else
                    -- Draw undiscovered character: rarity-specific background
                    local charactersModule = require('source.characters')
                    local charInfo = charactersModule.getCharacterInfo(charId)
                    
                    if charInfo then
                        -- Get the appropriate rarity background image
                        local rarityName = charactersModule.getRarityName(charInfo.rarity):lower()
                        local rarityTexturePath = "assets/collectionsTiles/" .. rarityName .. "_mystery_character_tile.png"
                        
                        local rarityTexture = textureCache[rarityTexturePath]
                        if not rarityTexture and love.filesystem.getInfo(rarityTexturePath) then
                            rarityTexture = love.graphics.newImage(rarityTexturePath)
                            textureCache[rarityTexturePath] = rarityTexture
                        end
                        
                        if rarityTexture then
                            love.graphics.setColor(1, 1, 1, 1)
                            love.graphics.draw(rarityTexture, x, y, 0, tileSize/rarityTexture:getWidth(), tileSize/rarityTexture:getHeight())

                        end

                    end
                end
            else
                love.graphics.setColor(0.3, 0.3, 0.3, 1)
                love.graphics.rectangle("fill", x, y, tileSize, tileSize)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.rectangle("line", x, y, tileSize, tileSize)
                love.graphics.print(tostring(charId), x + tileSize/2 - 5, y + tileSize/2 - 6)
            end
        end
    end
    
    love.graphics.setScissor()
end

function collection.mousepressed(x, y, button, panelX, panelY, panelWidth, panelHeight)
    if button == 1 and x >= panelX and x <= panelX + panelWidth and y >= panelY and y <= panelY + panelHeight then
        -- Check if clicking on a tile
        local tileSize = 80
        local padding = 10
        local tilesPerRow = math.floor((panelWidth - padding * 2) / (tileSize + padding))
        
        local charactersModule = require('source.characters')
        local sortedChars = charactersModule.getSortedCharacters()
        local totalTiles = #sortedChars
        
        -- Calculate centering offset
        local gridWidth = tilesPerRow * tileSize + (tilesPerRow - 1) * padding
        local centerOffset = (panelWidth - gridWidth) / 2
        
        for i = 1, totalTiles do
            local col = (i - 1) % tilesPerRow
            local row = math.floor((i - 1) / tilesPerRow)
            local tileX = panelX + centerOffset + col * (tileSize + padding)
            local tileY = panelY + padding + row * (tileSize + padding) + scrollOffset
            
            if x >= tileX and x <= tileX + tileSize and y >= tileY and y <= tileY + tileSize and
               tileY + tileSize > panelY and tileY < panelY + panelHeight then
                selectedCharacterId = sortedChars[i].id
                selectedTileX = tileX
                selectedTileY = tileY
            end
        end
        
        -- Always start dragging on click
        isDragging = true
        dragStartY = y
        dragStartOffset = scrollOffset
        scrollVelocity = 0  -- Reset velocity when starting drag to prevent interference
        return true
    end
    return false
end

function collection.mousemoved(x, y, dx, dy, panelX, panelY, panelWidth, panelHeight)
    if isDragging then
        -- Calculate new scroll offset based on drag (increased sensitivity by 50%)
        local newScrollOffset = dragStartOffset + (y - dragStartY) * 1.5  -- 50% more sensitive for faster scrolling
        
        -- Calculate velocity based on mouse movement with increased sensitivity
        if lastMouseY ~= nil then
            scrollVelocity = (y - lastMouseY) * 1.5  -- Increased sensitivity by 50% for faster scrolling
        end
        
        scrollOffset = newScrollOffset
        collection.clampScroll(panelWidth, panelHeight)
    end
    lastMouseY = y
    
    -- Hide popout if mouse moves too far away
    if selectedCharacterId then
        local popoutCenterX = popoutX + 150
        local popoutCenterY = popoutY + 100
        local distance = math.sqrt((x - popoutCenterX)^2 + (y - popoutCenterY)^2)
        if distance > 262.5 then
            selectedCharacterId = nil
        end
    end
end

function collection.mousereleased(x, y, button)
    if button == 1 then
        isDragging = false
        -- Don't reset scrollVelocity here to maintain momentum after drag stops
    end
end

function collection.update(dt)
    if not isDragging and math.abs(scrollVelocity) > 0.1 then
        scrollOffset = scrollOffset + scrollVelocity * dt * 120
        scrollVelocity = scrollVelocity * 0.98
        collection.clampScroll(currentPanelWidth, currentPanelHeight)
    end
end

function collection.wheelmoved(x, y, panelX, panelY, panelWidth, panelHeight, mouseX, mouseY)
    if mouseX >= panelX and mouseX <= panelX + panelWidth and mouseY >= panelY and mouseY <= panelY + panelHeight then
        -- Add momentum to mouse wheel scrolling (positive y = scroll down, negative y = scroll up)
        scrollVelocity = scrollVelocity + y * 27  -- Apply wheel movement to velocity (reduced by 10% from 30 to 27)
        collection.clampScroll(panelWidth, panelHeight)
        return true
    end
    return false
end

function collection.clampScroll(panelWidth, panelHeight)
    local tileSize = 80
    local padding = 10
    local tilesPerRow = math.floor((panelWidth - padding * 2) / (tileSize + padding))
    
    local charactersModule = require('source.characters')
    local sortedChars = charactersModule.getSortedCharacters()
    local totalTiles = #sortedChars
    
    local totalRows = math.ceil(totalTiles / tilesPerRow)
    local contentHeight = totalRows * (tileSize + padding) + padding  -- Include extra padding at the bottom
    local maxScroll = math.max(0, contentHeight - panelHeight)
    scrollOffset = math.max(-maxScroll, math.min(0, scrollOffset))
end

function collection.drawCharacterStats(panelX, panelY, panelWidth, panelHeight)
    local statsWidth = 300
    local statsHeight = 200
    
    -- Position near the clicked tile
    local statsX = selectedTileX + 90
    local statsY = selectedTileY
    
    -- Keep popout within screen bounds
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    
    -- Horizontal bounds checking
    if statsX + statsWidth > screenW then
        statsX = selectedTileX - statsWidth - 10
    end
    if statsX < 0 then
        statsX = 10
    end
    
    -- Vertical bounds checking
    if statsY + statsHeight > screenH then
        statsY = screenH - statsHeight - 10
    end
    if statsY < 0 then
        statsY = 10
    end
    
    -- Store popout position for distance calculation
    popoutX = statsX
    popoutY = statsY
    
    -- Background
    love.graphics.setColor(0.2, 0.2, 0.2, 0.95)
    love.graphics.rectangle("fill", statsX, statsY, statsWidth, statsHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", statsX, statsY, statsWidth, statsHeight)
    
    -- Character stats
    local yOffset = statsY + 15
    local gamestate = require('source.gamestate')
    local charactersModule = require('source.characters')
    local info = charactersModule.getCharacterInfo(selectedCharacterId)
    
    if info then
        local count = (gamestate.data.characters and gamestate.data.characters[tostring(selectedCharacterId)]) or 0
        if count > 0 then
            love.graphics.print(info.name, statsX + 15, yOffset)
            yOffset = yOffset + 25
            love.graphics.print("Rarity: " .. charactersModule.getRarityName(info.rarity), statsX + 15, yOffset)
            yOffset = yOffset + 20
            love.graphics.print("Faction: " .. info.faction:gsub("^%l", string.upper), statsX + 15, yOffset)
            yOffset = yOffset + 25
            love.graphics.print("Owned: " .. count, statsX + 15, yOffset)
        else
            love.graphics.print("???", statsX + 15, yOffset)
            yOffset = yOffset + 25
            love.graphics.print("Not discovered yet", statsX + 15, yOffset)
        end
    else
        love.graphics.print("Unknown Character", statsX + 15, yOffset)
        yOffset = yOffset + 25
        love.graphics.print("Not discovered yet", statsX + 15, yOffset)
    end
end

function collection.drawPopout()
    if selectedCharacterId then
        collection.drawCharacterStats(0, 0, 0, 0)
    end
end

return collection