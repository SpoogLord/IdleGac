-- UI Module
-- Handles all user interface rendering and interaction
-- Manages startup screens, game panels, modals, and input handling

local ui = {}

-- Color constants
local whiteColor = {1, 1, 1, 1}
local blackColor = {0, 0, 0, 1}



-- Input state variables
local namePromptText = ""
local keyHoldTime = 0
local keyRepeatDelay = 0.5
local keyRepeatRate = 0.05
local lastKey = nil
local namePromptActive = false
local sliderDragging = false



-- Callback storage
local logoutCallback = nil

-- ============================================================================
-- GAME PANEL RENDERING
-- ============================================================================

-- Draw the right panel containing animation and progress bar
-- Used by main.lua to render gacha animation and progress
function ui.drawGamePanels(screenW, screenH, currentFrame, progress, rightPanelX, rightPanelWidth, animationHeight)
    -- Use the provided animationHeight or default to half screen height
    local animHeight = animationHeight or (screenH / 2)
    
    -- Draw animation frame in top portion of right panel
    if currentFrame then
        local settings = require('source.settings').settings
        local brightness = settings.reduceFlashing and 0.5 or 1.0
        love.graphics.setColor(brightness, brightness, brightness, 1)
        local fw, fh = currentFrame:getWidth(), currentFrame:getHeight()
        local scale = math.max(rightPanelWidth/fw, animHeight/fh)
        
        love.graphics.setScissor(rightPanelX, 0, rightPanelWidth, animHeight)
        love.graphics.draw(currentFrame, 
            rightPanelX + (rightPanelWidth-fw*scale)/2, 
            (animHeight-fh*scale)/2, 
            0, scale, scale)
        love.graphics.setScissor()
    end
    
    -- Draw progress bar in bottom portion of right panel
    if progress then
        local barWidth = rightPanelWidth
        local barHeight = 7.5
        local barX = rightPanelX
        local barY = animHeight - barHeight
        
        -- Background
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)
        
        -- Progress fill
        love.graphics.setColor(0.68, 0.85, 1, 1)
        love.graphics.rectangle("fill", barX, barY, barWidth * progress, barHeight)
        
        -- Border
        love.graphics.setColor(blackColor)
        love.graphics.rectangle("line", barX, barY, barWidth, barHeight)
    end
end

function ui.handleStartupClick(x, y, screenW, screenH)
    local buttonWidth = 120
    local buttonHeight = 30
    local buttonX = (screenW - buttonWidth) / 2
    local buttonY = screenH / 2 + 50
    
    return ui.pointInRect(x, y, buttonX, buttonY, buttonWidth, buttonHeight)
end

function ui.getSaveFiles()
    if not love.filesystem.getInfo('SaveGames') then
        love.filesystem.createDirectory('SaveGames')
    end
    
    local files = love.filesystem.getDirectoryItems('SaveGames')
    local saveFiles = {}
    
    for _, file in ipairs(files) do
        if file:match('.*%.json$') and file:match('savegame') then
            local playerName = file:match('savegame%-(.+)%.json')
            if playerName then
                local info = love.filesystem.getInfo('SaveGames/' .. file)
                local saveData = love.filesystem.read('SaveGames/' .. file)
                local success, data = pcall(function() return require('source.json').decode(saveData) end)
                local lastPlayed = success and data.lastClosedTime or info.modtime
                
                local playtime = success and data.playtime or 0
                
                table.insert(saveFiles, {
                    file = 'SaveGames/' .. file,
                    name = playerName,
                    lastPlayed = lastPlayed or 0,
                    playtime = playtime
                })
            end
        end
    end
    
    table.sort(saveFiles, function(a, b) return a.lastPlayed > b.lastPlayed end)
    return saveFiles
end

function ui.drawSaveSelectionModal(screenW, screenH)
    local modalWidth = math.min(400, screenW * 0.8)
    local modalHeight = math.min(500, screenH * 0.8)
    local modalX = (screenW - modalWidth) / 2
    local modalY = (screenH - modalHeight) / 2
    
    -- Modal background
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", modalX, modalY, modalWidth, modalHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", modalX, modalY, modalWidth, modalHeight)
    
    -- Title
    local title = "Select Save File"
    local titleWidth = love.graphics.getFont():getWidth(title)
    love.graphics.print(title, modalX + (modalWidth - titleWidth) / 2, modalY + 10)
    
    -- Close button
    local closeSize = 20
    love.graphics.print("X", modalX + modalWidth - closeSize - 5, modalY + 5)
    
    -- Save list
    local saveFiles = ui.getSaveFiles()
    local itemHeight = 45
    local startY = modalY + 40
    
    for i, save in ipairs(saveFiles) do
        local itemY = startY + (i - 1) * itemHeight
        if itemY + itemHeight > modalY + modalHeight - 10 then break end
        
        -- Highlight current save
        if save.name == require('source.settings').settings.lastPlayerName then
            love.graphics.setColor(0.3, 0.3, 0.6, 1)
            love.graphics.rectangle("fill", modalX + 5, itemY, modalWidth - 10, itemHeight - 2)
        end
        
        -- Draw border box around each save item
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", modalX + 5, itemY, modalWidth - 10, itemHeight - 2)
        
        local hours = math.floor(save.playtime / 3600)
        local minutes = math.floor((save.playtime % 3600) / 60)
        local seconds = math.floor(save.playtime % 60)
        local playtimeText = string.format("Time Played: %02d:%02d:%02d", hours, minutes, seconds)
        local textY = itemY + (itemHeight - love.graphics.getFont():getHeight()) / 2
        love.graphics.print(save.name, modalX + 10, textY)
        love.graphics.print(playtimeText, modalX + modalWidth - 160, textY)
        
        -- Delete button (outside the save box)
        love.graphics.setColor(0.8, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", modalX + modalWidth - 5, itemY, 20, itemHeight - 2)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", modalX + modalWidth - 5, itemY, 20, itemHeight - 2)
        local xTextY = itemY + (itemHeight - love.graphics.getFont():getHeight()) / 2
        love.graphics.print("X", modalX + modalWidth + 2, xTextY)
    end
    
    -- New Save button (only show if less than 5 saves)
    if #saveFiles < 5 then
        local newSaveY = modalY + modalHeight - 50
        love.graphics.setColor(0.2, 0.6, 0.2, 1)
        love.graphics.rectangle("fill", modalX + 10, newSaveY, modalWidth - 20, 35)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", modalX + 10, newSaveY, modalWidth - 20, 35)
        
        local newSaveText = "New Save"
        local newSaveTextWidth = love.graphics.getFont():getWidth(newSaveText)
        love.graphics.print(newSaveText, modalX + (modalWidth - newSaveTextWidth) / 2, newSaveY + 10)
    end
end

function ui.handleSaveSelectionClick(x, y, screenW, screenH)
    local modalWidth = math.min(400, screenW * 0.8)
    local modalHeight = math.min(500, screenH * 0.8)
    local modalX = (screenW - modalWidth) / 2
    local modalY = (screenH - modalHeight) / 2
    
    -- Close button
    local closeSize = 20
    if ui.pointInRect(x, y, modalX + modalWidth - closeSize - 5, modalY + 5, closeSize, closeSize) then
        return "close"
    end
    
    -- Save selection
    local saveFiles = ui.getSaveFiles()
    local itemHeight = 45
    local startY = modalY + 40
    
    for i, save in ipairs(saveFiles) do
        local itemY = startY + (i - 1) * itemHeight
        if itemY + itemHeight > modalY + modalHeight - 10 then break end
        
        -- Delete button check
        if ui.pointInRect(x, y, modalX + modalWidth - 5, itemY, 20, itemHeight - 2) then
            love.filesystem.remove(save.file)
            return "refresh"
        end
        
        if ui.pointInRect(x, y, modalX + 5, itemY, modalWidth - 10, itemHeight - 2) then
            -- Load selected save
            require('source.settings').settings.lastPlayerName = save.name
            require('source.settings').save()
            require('source.gamestate').load()
            require('source.gamestate').resetSessionTime()
            
            if gameState.animationFrame then
                require('source.gacha').setFrame(gameState.animationFrame)
            end
            
            return save.name
        end
    end
    
    -- New Save button (only allow if less than 5 saves)
    if #saveFiles < 5 then
        local newSaveY = modalY + modalHeight - 50
        if ui.pointInRect(x, y, modalX + 10, newSaveY, modalWidth - 20, 35) then
            return "prompt_name"
        end
    end
    
    return nil
end

function ui.drawStartupScreen(screenW, screenH, startupImage)
    if startupImage then
        local imgW, imgH = startupImage:getWidth(), startupImage:getHeight()
        local scale = math.min(screenW / imgW, screenH / imgH, 1)
        love.graphics.setColor(whiteColor)
        love.graphics.draw(startupImage, (screenW - imgW * scale) / 2, (screenH - imgH * scale) / 2, 0, scale, scale)
    end
    
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    love.graphics.setColor(whiteColor)
    
    local font = love.graphics.getFont()
    
    -- Welcome text at top middle
    local welcomeText = "Welcome"
    love.graphics.print(welcomeText, (screenW - font:getWidth(welcomeText)) / 2, 50)
    
    -- Player name below welcome text
    local playerName = gameState and gameState.saveName or "Player"
    love.graphics.print(playerName, (screenW - font:getWidth(playerName)) / 2, 80)
    
    local title, clickText = "Idle Gacha", "Click anywhere to start"
    love.graphics.print(title, (screenW - font:getWidth(title)) / 2, screenH / 2 - 30)
    love.graphics.print(clickText, (screenW - font:getWidth(clickText)) / 2, screenH / 2 + 10)
    
    -- Select Save button
    local buttonWidth = 120
    local buttonHeight = 30
    local buttonX = (screenW - buttonWidth) / 2
    local buttonY = screenH / 2 + 50
    
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
    
    local selectText = "Select Save"
    local textWidth = font:getWidth(selectText)
    love.graphics.print(selectText, buttonX + (buttonWidth - textWidth) / 2, buttonY + (buttonHeight - font:getHeight()) / 2)
end



function ui.drawMiddlePanel(panelX, panelY, panelWidth, panelHeight, currentTab, settings, gachaSpeed, assets)
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", panelX, panelY, panelWidth, panelHeight)
    
    if currentTab == "Player" then
        ui.drawPlayerPanel(panelX, panelY, panelWidth, panelHeight)
    elseif currentTab == "Settings" then
        ui.drawSettingsPanel(panelX, panelY, panelWidth, panelHeight, settings, gachaSpeed, assets)
    elseif currentTab == "Collection" then
        require('source.collection').draw(panelX, panelY, panelWidth, panelHeight)
    elseif currentTab == "Inventory" then
        require('source.inventory').draw(panelX, panelY, panelWidth, panelHeight)
    elseif currentTab == "Hoops" then
        local basketball = require('source.basketball')
        basketball:draw(panelX, panelY, panelWidth, panelHeight)
    else
        love.graphics.setColor(whiteColor)
        local text = currentTab .. " Panel"
        local textWidth = love.graphics.getFont():getWidth(text)
        love.graphics.print(text, panelX + (panelWidth - textWidth) / 2, panelY + panelHeight / 2)
    end
end

function ui.drawSettingsPanel(panelX, panelY, panelWidth, panelHeight, settings, gachaSpeed, assets)
    if not settings then
        settings = require('source.settings').settings
    end
    if not gachaSpeed then
        gachaSpeed = gameState.gachaSpeed or 1.0
    end
    if not assets then
        assets = require('source.assets')
    end
    
    local padding = 20
    local y = panelY + padding
    local checkboxSize = 24
    
    love.graphics.setColor(whiteColor)
    
    -- Intro animation checkbox
    local checkboxImg = settings.showIntroAnimation and assets.images.checkboxEnabled or assets.images.checkboxDisabled
    if checkboxImg then
        love.graphics.draw(checkboxImg, panelX + padding, y, 0, checkboxSize/checkboxImg:getWidth(), checkboxSize/checkboxImg:getHeight())
    end
    love.graphics.print("Show intro animation", panelX + padding + checkboxSize + 10, y + 4)
    y = y + 40
    
    -- Reduce flashing checkbox
    local flashingCheckboxImg = settings.reduceFlashing and assets.images.checkboxEnabled or assets.images.checkboxDisabled
    if flashingCheckboxImg then
        love.graphics.draw(flashingCheckboxImg, panelX + padding, y, 0, checkboxSize/flashingCheckboxImg:getWidth(), checkboxSize/flashingCheckboxImg:getHeight())
    end
    love.graphics.print("Reduce flashing", panelX + padding + checkboxSize + 10, y + 4)
    y = y + 40
    
    -- Show FPS checkbox
    local fpsCheckboxImg = settings.showFPS and assets.images.checkboxEnabled or assets.images.checkboxDisabled
    if fpsCheckboxImg then
        love.graphics.draw(fpsCheckboxImg, panelX + padding, y, 0, checkboxSize/fpsCheckboxImg:getWidth(), checkboxSize/fpsCheckboxImg:getHeight())
    end
    love.graphics.print("Show FPS counter", panelX + padding + checkboxSize + 10, y + 4)
    y = y + 50
    
    -- Gacha speed slider
    love.graphics.print("Gacha Speed: " .. string.format("%.1f", gachaSpeed), panelX + padding, y)
    y = y + 25
    
    local sliderW = panelWidth - padding * 2
    local sliderH = 20
    
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", panelX + padding, y, sliderW, sliderH)
    
    local handlePos = (gachaSpeed - 0.1) / (50.0 - 0.1) * sliderW
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("fill", panelX + padding + handlePos - 5, y - 2, 10, sliderH + 4)
    
    -- Reset button above gacha speed slider
    local resetButtonW = 40
    local resetButtonH = 20
    local resetButtonX = panelX + padding + sliderW - resetButtonW
    local resetButtonY = y - 25
    

    
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle("fill", resetButtonX, resetButtonY, resetButtonW, resetButtonH)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", resetButtonX, resetButtonY, resetButtonW, resetButtonH)
    
    local resetText = "Reset"
    local textWidth = love.graphics.getFont():getWidth(resetText)
    local textHeight = love.graphics.getFont():getHeight()
    love.graphics.print(resetText, resetButtonX + (resetButtonW - textWidth) / 2, resetButtonY + (resetButtonH - textHeight) / 2)

    -- Debug menu toggle
    y = y + 50
    love.graphics.setColor(whiteColor)
    love.graphics.print("Debug Menu", panelX + padding, y)
    y = y + 25
    
    -- Get debug mode state from debug module
    local debugModule = require('source.debug')
    local debugMenuEnabled = debugModule.isEnabled()
    
    -- Debug menu toggle button
    local debugButtonW = 80
    local debugButtonH = 25
    local debugButtonX = panelX + padding
    local debugButtonY = y
    
    love.graphics.setColor(debugMenuEnabled and {0.3, 0.6, 0.3} or {0.6, 0.3, 0.3})
    love.graphics.rectangle("fill", debugButtonX, debugButtonY, debugButtonW, debugButtonH)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", debugButtonX, debugButtonY, debugButtonW, debugButtonH)
    
    local debugText = debugMenuEnabled and "ON" or "OFF"
    local debugTextWidth = love.graphics.getFont():getWidth(debugText)
    local debugTextHeight = love.graphics.getFont():getHeight()
    love.graphics.print(debugText, debugButtonX + (debugButtonW - debugTextWidth) / 2, debugButtonY + (debugButtonH - debugTextHeight) / 2)
    
    if debugMenuEnabled then
        y = y + 35
        
        -- Character dropdown
        local dropdownW = 200
        local dropdownH = 30
        local dropdownX = panelX + padding
        local dropdownY = y
        
        -- Get all characters
        local charactersModule = require('source.characters')
        local allCharacters = charactersModule.getSortedCharacters()
        
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", dropdownX, dropdownY, dropdownW, dropdownH)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", dropdownX, dropdownY, dropdownW, dropdownH)
        
        if allCharacters[debugCharacterDropdown.selected] then
            local selectedChar = allCharacters[debugCharacterDropdown.selected]
            local charInfo = charactersModule.getCharacterInfo(selectedChar.id)
            local charDisplay = charInfo and charInfo.name or "Unknown"
            love.graphics.print(charDisplay, dropdownX + 5, dropdownY + 8)
        end
        
        -- Dropdown arrow
        love.graphics.print("▼", dropdownX + dropdownW - 20, dropdownY + 8)
        
        y = y + 40
        
        -- Material dropdown
        local materialDropdownX = panelX + padding
        local materialDropdownY = y
        
        -- Get all materials
        local inventoryModule = require('source.inventory')
        local allMaterials = inventoryModule.getMaterials()
        
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", materialDropdownX, materialDropdownY, dropdownW, dropdownH)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", materialDropdownX, materialDropdownY, dropdownW, dropdownH)
        
        if allMaterials[debugMaterialDropdown.selected] then
            local selectedMaterial = allMaterials[debugMaterialDropdown.selected]
            love.graphics.print(selectedMaterial.name, materialDropdownX + 5, materialDropdownY + 8)
        end
        
        -- Dropdown arrow
        love.graphics.print("▼", materialDropdownX + dropdownW - 20, materialDropdownY + 8)
        
        y = y + 40
        
        -- Quantity input
        local inputX = panelX + padding
        local inputY = y
        local inputW = 100
        local inputH = 30
        
        love.graphics.setColor(debugInputActive and {0.3, 0.3, 0.5} or {0.2, 0.2, 0.3})
        love.graphics.rectangle("fill", inputX, inputY, inputW, inputH)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", inputX, inputY, inputW, inputH)
        
        love.graphics.print(debugQuantityInput, inputX + 5, inputY + 8)
        
        y = y + 40
        
        -- Add character button
        local addCharButtonX = panelX + padding
        local addCharButtonY = y
        local addCharButtonW = 120
        local addCharButtonH = 30
        
        love.graphics.setColor(0.3, 0.5, 0.3, 1)
        love.graphics.rectangle("fill", addCharButtonX, addCharButtonY, addCharButtonW, addCharButtonH)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", addCharButtonX, addCharButtonY, addCharButtonW, addCharButtonH)
        
        love.graphics.print("Add Character", addCharButtonX + 10, addCharButtonY + 8)
        
        -- Add material button
        local addMatButtonX = panelX + padding + 130
        local addMatButtonY = y
        local addMatButtonW = 120
        local addMatButtonH = 30
        
        love.graphics.setColor(0.3, 0.5, 0.3, 1)
        love.graphics.rectangle("fill", addMatButtonX, addMatButtonY, addMatButtonW, addMatButtonH)
        love.graphics.setColor(whiteColor)
        love.graphics.rectangle("line", addMatButtonX, addMatButtonY, addMatButtonW, addMatButtonH)
        
        love.graphics.print("Add Material", addMatButtonX + 10, addMatButtonY + 8)
    end

end



function ui.handleSettingsClick(x, y, panelX, panelY, panelWidth, panelHeight, gameState, settings, assets)
    local padding = 20
    local checkboxSize = 24
    
    if not settings then
        settings = require('source.settings').settings
    end
    
    -- Intro animation checkbox click
    if ui.pointInRect(x, y, panelX + padding, panelY + padding, checkboxSize + 100, checkboxSize) then
        settings.showIntroAnimation = not settings.showIntroAnimation
        require('source.settings').save()
        return true
    end
    
    -- Reduce flashing checkbox click
    if ui.pointInRect(x, y, panelX + padding, panelY + padding + 40, checkboxSize + 100, checkboxSize) then
        settings.reduceFlashing = not settings.reduceFlashing
        require('source.settings').save()
        return true
    end
    
    -- Show FPS checkbox click
    if ui.pointInRect(x, y, panelX + padding, panelY + padding + 80, checkboxSize + 100, checkboxSize) then
        settings.showFPS = not settings.showFPS
        require('source.settings').save()
        return true
    end
    
    -- Reset button click
    local sliderY = panelY + padding + 115
    local sliderW = panelWidth - padding * 2
    local resetButtonW = 40
    local resetButtonH = 20
    local resetButtonX = panelX + padding + sliderW - resetButtonW
    local resetButtonY = sliderY - 25
    
    if ui.pointInRect(x, y, resetButtonX, resetButtonY, resetButtonW, resetButtonH) then
        gameState.gachaSpeed = 1.0
        return true
    end
    
    -- Gacha speed slider click
    if ui.pointInRect(x, y, panelX + padding, sliderY - 2, sliderW, 24) then
        sliderDragging = true
        local newSpeed = 0.1 + ((x - panelX - padding) / sliderW) * (50.0 - 0.1)
        newSpeed = math.max(0.1, math.min(50.0, newSpeed))
        newSpeed = math.floor(newSpeed * 10 + 0.5) / 10
        gameState.gachaSpeed = newSpeed
        return true
    end
    

    
    return false
end

function ui.drawPlayerPanel(panelX, panelY, panelWidth, panelHeight)
    local padding = 20
    local y = panelY + padding
    
    love.graphics.setColor(whiteColor)
    
    -- Save name input
    love.graphics.print("Save Name:", panelX + padding, y)
    y = y + 25
    
    local inputWidth = panelWidth - padding * 2
    local inputHeight = 25
    local isActive = ui.isTextInputActive and ui.isTextInputActive()
    
    love.graphics.setColor(isActive and {0.4, 0.4, 0.6, 1} or {0.3, 0.3, 0.3, 1})
    love.graphics.rectangle("fill", panelX + padding, y, inputWidth, inputHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", panelX + padding, y, inputWidth, inputHeight)
    
    local displayText = gameState.saveName or "Unnamed"
    if isActive and math.floor(love.timer.getTime() * 2) % 2 == 0 then
        displayText = displayText .. "|"
    end
    love.graphics.print(displayText, panelX + padding + 5, y + 5)
    y = y + 40
    
    -- First run date
    if gameState.firstRun then
        local firstRunText = "First Run: " .. os.date("%Y-%m-%d %H:%M:%S", gameState.firstRun)
        love.graphics.print(firstRunText, panelX + padding, y)
        y = y + 30
    end
    
    -- Total playtime
    local hours = math.floor(gameState.playtime / 3600)
    local minutes = math.floor((gameState.playtime % 3600) / 60)
    local seconds = math.floor(gameState.playtime % 60)
    local playtimeText = string.format("Total Playtime: %02d:%02d:%02d", hours, minutes, seconds)
    love.graphics.print(playtimeText, panelX + padding, y)
    y = y + 30
    
    -- Current session time
    local sessionTime = gameState.sessionTime or 0
    local sessionMinutes = math.floor(sessionTime / 60)
    local sessionSeconds = math.floor(sessionTime % 60)
    local sessionText = string.format("Session Time: %02d:%02d", sessionMinutes, sessionSeconds)
    love.graphics.print(sessionText, panelX + padding, y)
    y = y + 30
    
    -- Summon time calculation
    local frameRate = 1/29.5
    local maxFrames = 4047
    local summonTime = (frameRate * maxFrames) / gameState.gachaSpeed
    local minutes = math.floor(summonTime / 60)
    local seconds = math.floor(summonTime % 60)
    love.graphics.print(string.format("Summon Time: %02d:%02d", minutes, seconds), panelX + padding, y)
    y = y + 30
    
    -- Collection totals
    local charactersModule = require('source.characters')
    local stats = charactersModule.getCollectionStats()
    love.graphics.print("Collection: " .. stats.totalOwned .. "/" .. stats.totalPossible, panelX + padding, y)
    y = y + 20
    love.graphics.print("Total Characters: " .. stats.totalCopies, panelX + padding, y)
    y = y + 30
    
    -- Collection by rarity
    for i = 1, 10 do
        local rarityName = charactersModule.getRarityName(i)
        love.graphics.print(rarityName .. ": " .. stats.rarityOwned[i] .. "/" .. stats.rarityPossible[i], panelX + padding, y)
        y = y + 18
    end
    
    -- Logout button
    local buttonWidth = 100
    local buttonHeight = 30
    local buttonX = panelX + padding
    local buttonY = panelY + panelHeight - buttonHeight - padding
    
    love.graphics.setColor(0.6, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
    
    local logoutText = "Log Out"
    local textWidth = love.graphics.getFont():getWidth(logoutText)
    love.graphics.print(logoutText, buttonX + (buttonWidth - textWidth) / 2, buttonY + (buttonHeight - love.graphics.getFont():getHeight()) / 2)
end

function ui.handlePlayerClick(x, y, panelX, panelY, panelWidth, panelHeight)
    local padding = 20
    local inputY = panelY + padding + 25
    local inputWidth = panelWidth - padding * 2
    local inputHeight = 25
    
    -- Check logout button
    local buttonWidth = 100
    local buttonHeight = 30
    local buttonX = panelX + padding
    local buttonY = panelY + panelHeight - buttonHeight - padding
    
    if ui.pointInRect(x, y, buttonX, buttonY, buttonWidth, buttonHeight) then
        ui.logout()
        return true
    end
    
    -- Check text input
    if ui.pointInRect(x, y, panelX + padding, inputY, inputWidth, inputHeight) then
        ui.setTextInputActive(true)
        return true
    else
        ui.setTextInputActive(false)
    end
    return false
end



-- ============================================================================
-- LOGOUT SYSTEM
-- ============================================================================

-- Set callback function to execute when user logs out
-- Used by main.lua to return to intro screen after logout
function ui.setLogoutCallback(callback)
    logoutCallback = callback
end

-- Handle user logout - saves game and returns to startup
-- Called when logout button is clicked in player panel
function ui.logout()
    require('source.gamestate').save()
    gameState.gameStarted = false
    if logoutCallback then
        logoutCallback()
    end
end

function ui.setTextInputActive(active)
    ui.textInputActive = active
end

function ui.isTextInputActive()
    return ui.textInputActive
end

function ui.handleTextInput(text)
    if ui.textInputActive and gameState.saveName and #gameState.saveName < 21 then
        gameState.saveName = gameState.saveName .. text
        require('source.gamestate').updateSaveName(gameState.saveName)
    end
end

function ui.update(dt)
    if lastKey == "backspace" and love.keyboard.isDown("backspace") then
        keyHoldTime = keyHoldTime + dt
        if keyHoldTime > keyRepeatDelay and keyHoldTime % keyRepeatRate < dt then
            if ui.textInputActive and gameState.saveName and #gameState.saveName > 0 then
                gameState.saveName = gameState.saveName:sub(1, -2)
                require('source.gamestate').updateSaveName(gameState.saveName)
            elseif namePromptActive and #namePromptText > 0 then
                namePromptText = namePromptText:sub(1, -2)
            end
        end
    else
        keyHoldTime = 0
        lastKey = nil
    end
end

function ui.handleKeyPressed(key)
    if ui.textInputActive then
        if key == "backspace" and gameState.saveName and #gameState.saveName > 0 then
            gameState.saveName = gameState.saveName:sub(1, -2)
            require('source.gamestate').updateSaveName(gameState.saveName)
            lastKey = key
            keyHoldTime = 0
        elseif key == "return" or key == "escape" then
            ui.setTextInputActive(false)
        end
    end
end

function ui.drawNamePromptModal(screenW, screenH)
    local modalWidth = 300
    local modalHeight = 150
    local modalX = (screenW - modalWidth) / 2
    local modalY = (screenH - modalHeight) / 2
    
    -- Modal background
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", modalX, modalY, modalWidth, modalHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", modalX, modalY, modalWidth, modalHeight)
    
    -- Title
    local title = "Enter Save Name"
    local titleWidth = love.graphics.getFont():getWidth(title)
    love.graphics.print(title, modalX + (modalWidth - titleWidth) / 2, modalY + 15)
    
    -- Character limit info
    local limitText = "(Max 21 characters)"
    local limitWidth = love.graphics.getFont():getWidth(limitText)
    love.graphics.print(limitText, modalX + (modalWidth - limitWidth) / 2, modalY + 35)
    
    -- Input field
    local inputWidth = modalWidth - 40
    local inputHeight = 25
    local inputX = modalX + 20
    local inputY = modalY + 60
    
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", inputX, inputY, inputWidth, inputHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", inputX, inputY, inputWidth, inputHeight)
    
    local displayText = namePromptText
    if math.floor(love.timer.getTime() * 2) % 2 == 0 then
        displayText = displayText .. "|"
    end
    love.graphics.print(displayText, inputX + 5, inputY + 5)
    
    -- OK button
    local buttonWidth = 60
    local buttonHeight = 25
    local buttonX = modalX + (modalWidth - buttonWidth) / 2
    local buttonY = modalY + 100
    
    love.graphics.setColor(0.2, 0.6, 0.2, 1)
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.setColor(whiteColor)
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.print("OK", buttonX + 22, buttonY + 6)
end

function ui.handleNamePromptClick(x, y, screenW, screenH)
    local modalWidth = 300
    local modalHeight = 150
    local modalX = (screenW - modalWidth) / 2
    local modalY = (screenH - modalHeight) / 2
    
    -- OK button
    local buttonWidth = 60
    local buttonHeight = 25
    local buttonX = modalX + (modalWidth - buttonWidth) / 2
    local buttonY = modalY + 100
    
    if ui.pointInRect(x, y, buttonX, buttonY, buttonWidth, buttonHeight) then
        local saveName = namePromptText ~= "" and namePromptText or "Unnamed"
        namePromptText = ""
        require('source.gamestate').createNewWithName(saveName)
        require('source.gamestate').save()
        require('source.gamestate').load()
        require('source.gamestate').resetSessionTime()
        require('source.gacha').setFrame(1)
        require('source.tabs').setCurrentTab("Player")
        gameState.gameStarted = true
        return "new"
    end
    
    return nil
end

function ui.handleNamePromptTextInput(text)
    if #namePromptText < 21 then
        namePromptText = namePromptText .. text
    end
end

function ui.handleNamePromptKeyPressed(key)
    if key == "backspace" and #namePromptText > 0 then
        namePromptText = namePromptText:sub(1, -2)
        lastKey = key
        keyHoldTime = 0
    end
end

function ui.setNamePromptActive(active)
    namePromptActive = active
end

-- ============================================================================
-- SLIDER DRAG HANDLING
-- ============================================================================

-- Handle mouse movement for slider dragging
-- Called by main.lua during mouse movement to update slider values
function ui.handleSettingsMouseMoved(x, y, panelX, panelY, panelWidth, panelHeight)
    if sliderDragging then
        local padding = 20
        local sliderW = panelWidth - padding * 2
        local newSpeed = 0.1 + ((x - panelX - padding) / sliderW) * (50.0 - 0.1)
        newSpeed = math.max(0.1, math.min(50.0, newSpeed))
        newSpeed = math.floor(newSpeed * 10 + 0.5) / 10
        gameState.gachaSpeed = newSpeed
    end
end

-- Stop slider dragging on mouse release
-- Called by main.lua when mouse button is released
function ui.handleSettingsMouseReleased()
    sliderDragging = false
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Check if point is inside rectangle bounds
-- Used throughout UI system for click detection
function ui.handleTextInput(text)
    if debugInputActive then
        -- Only allow numbers for quantity input
        if tonumber(text) or text == "" then
            debugQuantityInput = debugQuantityInput .. text
            -- Limit to reasonable length
            if string.len(debugQuantityInput) > 10 then
                debugQuantityInput = string.sub(debugQuantityInput, 1, 10)
            end
        end
    end
end

function ui.handleKeyPressed(key)
    if debugInputActive and key == "backspace" then
        -- Remove last character
        debugQuantityInput = string.sub(debugQuantityInput, 1, -2)
    end
end

function ui.pointInRect(x, y, rx, ry, rw, rh)
    return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

return ui