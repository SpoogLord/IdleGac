-- Inventory module for IdleGacha
-- Handles acquisition, storage, and display of items in the inventory system

local inventory = {}

-- Define material data with varying rarities
local materials = {
    -- Common materials (rarity 1)
    { id = "iron_ore", name = "Iron Ore", rarity = 1, description = "Basic metal ore used for crafting", icon = "assets/inventory/iron_ore.png" },
    { id = "copper_ore", name = "Copper Ore", rarity = 1, description = "Soft metal ore used in alloys", icon = "assets/inventory/copper_ore.png" },
    { id = "wood", name = "Wood", rarity = 1, description = "Basic crafting material", icon = "assets/inventory/wood.png" },
    { id = "stone", name = "Stone", rarity = 1, description = "Common building material", icon = "assets/inventory/stone.png" },
    { id = "coal", name = "Coal", rarity = 1, description = "Fuel for smelting and crafting", icon = "assets/inventory/coal.png" },
    
    -- Uncommon materials (rarity 2)
    { id = "silver_ore", name = "Silver Ore", rarity = 2, description = "Precious metal with special properties", icon = "assets/inventory/silver_ore.png" },
    { id = "gold_ore", name = "Gold Ore", rarity = 2, description = "Valuable metal for high-tier crafting", icon = "assets/inventory/gold_ore.png" },
    { id = "cotton", name = "Cotton", rarity = 2, description = "Soft fabric material", icon = "assets/inventory/cotton.png" },
    { id = "clay", name = "Clay", rarity = 2, description = "Moldable material for pottery", icon = "assets/inventory/clay.png" },
    { id = "leather", name = "Leather", rarity = 2, description = "Treated animal hide", icon = "assets/inventory/leather.png" },
    
    -- Rare materials (rarity 3)
    { id = "platinum_ore", name = "Platinum Ore", rarity = 3, description = "Rare precious metal", icon = "assets/inventory/platinum_ore.png" },
    { id = "diamond", name = "Diamond", rarity = 3, description = "Hard crystalline material", icon = "assets/inventory/diamond.png" },
    { id = "silk", name = "Silk", rarity = 3, description = "Luxurious fabric material", icon = "assets/inventory/silk.png" },
    { id = "obsidian", name = "Obsidian", rarity = 3, description = "Volcanic glass material", icon = "assets/inventory/obsidian.png" },
    { id = "mystic_crystal", name = "Mystic Crystal", rarity = 3, description = "Magical crystalline substance", icon = "assets/inventory/mystic_crystal.png" },
    
    -- Epic materials (rarity 4)
    { id = "mythril", name = "Mythril", rarity = 4, description = "Legendary light metal", icon = "assets/inventory/mythril.png" },
    { id = "dragon_scale", name = "Dragon Scale", rarity = 4, description = "Reinforced with dragon essence", icon = "assets/inventory/dragon_scale.png" },
    { id = "phoenix_feather", name = "Phoenix Feather", rarity = 4, description = "Burns with eternal flame", icon = "assets/inventory/phoenix_feather.png" },
    { id = "void_crystal", name = "Void Crystal", rarity = 4, description = "Crystallized essence of void", icon = "assets/inventory/void_crystal.png" },
    { id = "star_dust", name = "Star Dust", rarity = 4, description = "Particles from fallen stars", icon = "assets/inventory/star_dust.png" }
}

-- Player's inventory - will be populated from game state
local playerInventory = {}

-- Initialize the inventory module with game state
function inventory.init(gameState)
    if gameState and gameState.inventory then
        playerInventory = gameState.inventory
    else
        -- Initialize with empty inventory if not loaded
        playerInventory = {}
    end
end

-- Update the game state with current inventory
function inventory.getRarityColor(rarity)
    -- Define rarity colors based on the game's rarity system
    local rarityColors = {
        [1] = {r = 0.7, g = 0.7, b = 0.7},  -- Common: light gray
        [2] = {r = 0.5, g = 0.8, b = 0.5},  -- Uncommon: green
        [3] = {r = 0.5, g = 0.5, b = 1.0},  -- Rare: blue
        [4] = {r = 0.8, g = 0.5, b = 0.8},  -- Epic: purple
        [5] = {r = 1.0, g = 0.8, b = 0.2},  -- Legendary: yellow
        [6] = {r = 1.0, g = 0.5, b = 0.0},  -- Mythic: orange
        [7] = {r = 1.0, g = 0.0, b = 1.0},  -- Ascendant: pink
        [8] = {r = 0.0, g = 1.0, b = 1.0},  -- Superior: cyan
        [9] = {r = 1.0, g = 1.0, b = 0.0},  -- Ultimate: yellow
        [10] = {r = 1.0, g = 1.0, b = 1.0}  -- Deific: white
    }
    
    return rarityColors[rarity] or {r = 0.5, g = 0.5, b = 0.5}  -- Default to gray if rarity not found
end

function inventory.updateGameState(gameState)
    gameState.inventory = playerInventory
end

-- Add an item to the inventory
function inventory.addItem(itemId, quantity)
    quantity = quantity or 1
    if playerInventory[itemId] then
        playerInventory[itemId] = playerInventory[itemId] + quantity
    else
        playerInventory[itemId] = quantity
    end
end

-- Remove an item from the inventory
function inventory.removeItem(itemId, quantity)
    quantity = quantity or 1
    if playerInventory[itemId] then
        playerInventory[itemId] = playerInventory[itemId] - quantity
        if playerInventory[itemId] <= 0 then
            playerInventory[itemId] = nil
        end
    end
end

-- Get the quantity of an item in the inventory
function inventory.getItemQuantity(itemId)
    return playerInventory[itemId] or 0
end

-- Get all materials data
function inventory.getMaterials()
    return materials
end

-- Get material info by ID
function inventory.getMaterialInfo(materialId)
    for _, material in ipairs(materials) do
        if material.id == materialId then
            return material
        end
    end
    return nil
end

-- Get all materials in the player's inventory with their quantities
function inventory.getInventoryItems()
    local inventoryItems = {}
    for itemId, quantity in pairs(playerInventory) do
        local materialInfo = inventory.getMaterialInfo(itemId)
        if materialInfo then
            table.insert(inventoryItems, {
                id = itemId,
                name = materialInfo.name,
                quantity = quantity,
                rarity = materialInfo.rarity,
                description = materialInfo.description,
                icon = materialInfo.icon
            })
        end
    end
    return inventoryItems
end

-- Get material by rarity
function inventory.getMaterialsByRarity(rarity)
    local result = {}
    for _, material in ipairs(materials) do
        if material.rarity == rarity then
            table.insert(result, material)
        end
    end
    return result
end

-- Get materials sorted by rarity (descending)
function inventory.getSortedMaterials()
    local sorted = {}
    for _, material in ipairs(materials) do
        table.insert(sorted, material)
    end
    table.sort(sorted, function(a, b)
        return a.rarity > b.rarity
    end)
    return sorted
end

-- Draw the inventory UI
function inventory.draw(panelX, panelY, panelWidth, panelHeight)
    local tileSize = 80
    local padding = 10
    local itemsPerRow = math.floor((panelWidth - padding * 2) / (tileSize + padding))
    
    local inventoryItems = inventory.getInventoryItems()
    local totalItems = #inventoryItems
    
    -- Calculate centering offset
    local gridWidth = itemsPerRow * tileSize + (itemsPerRow - 1) * padding
    local centerOffset = (panelWidth - gridWidth) / 2
    
    love.graphics.setScissor(panelX, panelY, panelWidth, panelHeight)
    
    for i = 1, totalItems do
        local col = (i - 1) % itemsPerRow
        local row = math.floor((i - 1) / itemsPerRow)
        local x = panelX + centerOffset + col * (tileSize + padding)
        local y = panelY + padding + row * (tileSize + padding)
        
        if y + tileSize > panelY and y < panelY + panelHeight then
            local item = inventoryItems[i]
            local materialInfo = inventory.getMaterialInfo(item.id)
            
            if materialInfo then
                -- Get the appropriate rarity tile image
                local charactersModule = require('source.characters')
                local rarityName = charactersModule.getRarityName(materialInfo.rarity):lower()
                local rarityTilePath = "assets/collectionsTiles/" .. rarityName .. "_tile.png"
                
                -- Draw rarity tile background
                local rarityTile = nil
                if love.filesystem.getInfo(rarityTilePath) then
                    rarityTile = love.graphics.newImage(rarityTilePath)
                end
                
                if rarityTile then
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.draw(rarityTile, x, y, 0, tileSize/rarityTile:getWidth(), tileSize/rarityTile:getHeight())
                else

                end
                
                -- Draw item texture overlay
                local iconPath = materialInfo.icon
                if love.filesystem.getInfo(iconPath) then
                    local icon = love.graphics.newImage(iconPath)
                    if icon then
                        love.graphics.setColor(1, 1, 1, 1)
                        -- Draw the item texture overlay at 80% size to fit nicely on the tile
                        local overlaySize = tileSize * 0.8
                        local offset = (tileSize - overlaySize) / 2
                        love.graphics.draw(icon, x + offset, y + offset, 0, overlaySize/icon:getWidth(), overlaySize/icon:getHeight())
                    end
                else

                    love.graphics.setColor(1, 1, 1, 1)
                    
                    -- Draw the item name on the tile
                    local font = love.graphics.getFont()
                    local name = materialInfo.name
                    local textWidth = font:getWidth(name)
                    local textHeight = font:getHeight()
                    
                    -- Scale down the text if it's too wide for the tile
                    local scale = math.min(1.0, tileSize / textWidth) * 0.8  -- 80% of max to add padding
                    if scale < 0.5 then scale = 0.5 end  -- Minimum scale
                    
                    love.graphics.push()
                    love.graphics.translate(x + tileSize/2, y + tileSize/2)
                    love.graphics.scale(scale)
                    love.graphics.print(name, -textWidth*scale/2, -textHeight*scale/2)
                    love.graphics.pop()
                end
                
                -- Draw quantity
                love.graphics.setColor(1, 1, 1, 1)
                local quantityText = tostring(item.quantity)
                local textWidth = love.graphics.getFont():getWidth(quantityText)
                love.graphics.print(quantityText, x + tileSize - textWidth - 2, y + tileSize - 12)
            end
        end
    end
    
    love.graphics.setScissor()
end

-- Handle mouse press events in the inventory
function inventory.mousepressed(x, y, button, panelX, panelY, panelWidth, panelHeight)
    -- For now, just return false to indicate no specific action was taken
    -- This can be expanded to handle item selection, usage, etc.
    return false
end

-- Handle mouse move events in the inventory
function inventory.mousemoved(x, y, dx, dy, panelX, panelY, panelWidth, panelHeight)
    -- For now, just return false
    -- This can be expanded for hover effects or drag operations
    return false
end

-- Handle mouse wheel events in the inventory
function inventory.wheelmoved(x, y, panelX, panelY, panelWidth, panelHeight, mouseX, mouseY)
    -- For now, just return false
    -- This can be expanded for scrolling functionality
    return false
end

-- Update function for any animations or time-based effects
function inventory.update(dt)
    -- Currently no update logic needed
end

-- Handle mouse release events in the inventory
function inventory.mousereleased(x, y, button)
    -- Currently no specific handling needed
    -- This can be expanded for drag operations or other interactions
end

-- Save the current inventory state
function inventory.save()
    return playerInventory
end

return inventory