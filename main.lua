-- IdleGacha Main Entry Point
-- Handles game initialization, main loop, and LÖVE2D event callbacks

-- Module imports
local GameState = require('source.gamestate')
local Animation = require('source.gacha')
local Assets = require('source.assets')
local UI = require('source.ui')
local Settings = require('source.settings')
local Tabs = require('source.tabs')
local Collection = require('source.collection')
local Panels = require('source.panels')
local EventLog = require('source.eventlog')

-- Global function for adding log entries (for compatibility with other modules)
function addLogEntry(message)
    EventLog.addEntry(message)
end

-- Debug state variables


-- Global state reference for module compatibility
gameState = GameState.data

-- Application state variables
local introVideo = nil
local showIntroVideo = true
local escapeHoldTime = 0
local cleanupTimer = 0
local cleanupInterval = 60
local showSaveSelection = false
local showNamePrompt = false

-- Track previous tab for tab change detection
local previousTab = nil

-- Initialize game on startup
-- Loads all modules, sets up window, and prepares initial state
function love.load()
    -- Load configuration and set up window
    Settings.load()
    love.window.setMode(Settings.settings.windowWidth, Settings.settings.windowHeight, {
        resizable = true, 
        vsync = false, 
        minwidth = 640, 
        minheight = 360
    })
    
    -- Initialize game state and assets
    GameState.load()
    GameState.resetSessionTime()
    gameState.gameStarted = false
    Assets.load()
    Animation.init()
    Collection.init()
    require('source.inventory').init(gameState)
    
    -- Restore animation progress from save
    if gameState.animationFrame then
        Animation.setFrame(gameState.animationFrame)
    end
    
    -- Set up UI logout callback to return to intro
    UI.setLogoutCallback(function()
        if Settings.settings.showIntroAnimation then
            introVideo = Assets.loadIntroVideo()
            showIntroVideo = true
        end
    end)
    
    -- Show intro video if enabled
    if Settings.settings.showIntroAnimation then
        introVideo = Assets.loadIntroVideo()
        showIntroVideo = true
    else
        showIntroVideo = false
    end
    
    -- Initialize debug module
    local debugModule = require('source.debug')
    debugModule.init()
end



-- Main game loop - called every frame
-- Updates all game systems and handles continuous input
function love.update(dt)
    -- Update core systems
    GameState.update(dt)
    gameState = GameState.data  -- Sync global reference
    UI.update(dt)
    Animation.update(dt, gameState.gachaSpeed)
    Collection.update(dt)
    require('source.inventory').update(dt)
    
    -- Check for tab changes and activate appropriate modules
    local currentTab = Tabs.getCurrentTab()
    if currentTab ~= previousTab then
        -- Tab has changed, handle exit/enter for modules that need it
        if previousTab == "Hoops" then
            require('source.basketball'):exit()
        end
        if currentTab == "Hoops" then
            require('source.basketball'):enter()
        end
        previousTab = currentTab
    end
    
    -- Update basketball game if active
    if currentTab == "Hoops" then
        require('source.basketball'):update(dt)
    end
    
    -- Periodic garbage collection for memory management
    cleanupTimer = cleanupTimer + dt
    if cleanupTimer >= cleanupInterval then
        cleanupTimer = 0
        collectgarbage("collect")
    end

    -- Handle escape key hold-to-quit (3 second timer)
    if love.keyboard.isDown('escape') then
        escapeHoldTime = escapeHoldTime + dt
        if escapeHoldTime >= 3 then
            love.event.quit()
        end
    else
        escapeHoldTime = 0
    end

    -- Check if intro video finished playing
    if showIntroVideo and introVideo and not introVideo:isPlaying() then
        showIntroVideo = false
    end
end

-- Draw the main game interface with 4-panel layout
-- Used by love.draw when game is active
local function drawGameInterface(screenW, screenH)
    -- Get panel dimensions from the panels module
    local leftPanelWidth, middlePanelWidth, rightPanelWidth, rightPanelX = Panels.getPanelDimensions(screenW, screenH)
    local bottomLeftHeight = leftPanelWidth / 4
    local topLeftHeight = screenH - bottomLeftHeight
    
    -- Draw panel borders
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("line", 0, 0, leftPanelWidth, topLeftHeight)
    love.graphics.rectangle("line", 0, topLeftHeight, leftPanelWidth, bottomLeftHeight)
    love.graphics.rectangle("line", leftPanelWidth, 0, middlePanelWidth, screenH)
    love.graphics.rectangle("line", rightPanelX, 0, rightPanelWidth, screenH)
    
    -- Draw vertical divider between middle and right panels
    local dividerX = leftPanelWidth + middlePanelWidth
    love.graphics.setColor(0.4, 0.4, 0.4, 1)  -- Gray divider
    love.graphics.rectangle("fill", dividerX - 2, 0, 4, screenH)  -- 4px wide divider
    
    -- Get horizontal divider position from the panels module
    local animationHeight, logHeight, horizontalDividerY = Panels.getHorizontalDividerPosition(screenW, screenH)
    
    -- Draw horizontal divider between animation and log
    love.graphics.setColor(0.4, 0.4, 0.4, 1)  -- Gray divider
    love.graphics.rectangle("fill", rightPanelX, horizontalDividerY - 2, rightPanelWidth, 4)  -- 4px wide divider
    
    -- Draw event log in bottom portion of right panel (behind other UI)
    local logX = rightPanelX
    local logY = horizontalDividerY
    local logWidth = rightPanelWidth
    local logActualHeight = logHeight  -- Use logHeight from panels module
    
    -- Background for the log panel
    love.graphics.setColor(0.15, 0.15, 0.15, 1)
    love.graphics.rectangle("fill", logX, logY, logWidth, logActualHeight)
    
    -- Border for the log panel
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("line", logX, logY, logWidth, logActualHeight)
    
    -- Draw event log using the eventlog module
    EventLog.draw(logX, logY, logWidth, logActualHeight)
    
    -- Draw panel contents
    Tabs.draw(0, 0, leftPanelWidth, topLeftHeight)
    UI.drawMiddlePanel(leftPanelWidth, 0, middlePanelWidth, screenH, Tabs.getCurrentTab())
    UI.drawGamePanels(screenW, screenH, Animation.getCurrentFrame(), Animation.getProgress(), rightPanelX, rightPanelWidth, animationHeight)
    
    -- Draw UI overlays
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Exit timer display
    if escapeHoldTime > 0 then
        love.graphics.print("Exiting in " .. math.ceil(3 - escapeHoldTime) .. "...", 10, screenH - 30)
    end
    
    -- Time since last played notification
    if gameState.showTimeSinceClosed and gameState.timeSinceClosed then
        local t = gameState.timeSinceClosed
        local sinceText = string.format("Time since last played: %02d:%02d:%02d", 
            math.floor(t / 3600), math.floor((t % 3600) / 60), math.floor(t % 60))
        love.graphics.print(sinceText, (screenW - love.graphics.getFont():getWidth(sinceText)) / 2, screenH - 50)
    end
    
    -- FPS counter (conditionally shown based on settings)
    local settings = require('source.settings').settings
    if settings.showFPS then
        local fpsText = "FPS: " .. love.timer.getFPS()
        local fpsWidth = love.graphics.getFont():getWidth(fpsText)
        love.graphics.print(fpsText, screenW - fpsWidth - 10, screenH - 20)
    end
    
    -- Draw Linktree button in bottom left panel
    local bottomLeftPanelX = 0
    local bottomLeftPanelY = topLeftHeight
    local bottomLeftPanelWidth = leftPanelWidth
    local bottomLeftPanelHeight = bottomLeftHeight
    
    -- Draw the Linktree button image stretched to almost cover the panel
    if Assets.images.linktree then
        local padding = 5  -- Small padding around the button
        local buttonWidth = bottomLeftPanelWidth - (padding * 2)
        local buttonHeight = bottomLeftPanelHeight - (padding * 2)
        local buttonX = bottomLeftPanelX + padding
        local buttonY = bottomLeftPanelY + padding
        local scaleX = buttonWidth / Assets.images.linktree:getWidth()
        local scaleY = buttonHeight / Assets.images.linktree:getHeight()
        
        love.graphics.draw(Assets.images.linktree, buttonX, buttonY, 0, scaleX, scaleY)
        
        -- Draw "Meet the developer" text slightly right of center on the button
        local text = "Meet the developer"
        
        -- Set a larger font size
        local fontSize = 16
        local largeFont = love.graphics.newFont(fontSize)
        love.graphics.setFont(largeFont)
        
        local textWidth = largeFont:getWidth(text)
        local textHeight = largeFont:getHeight()
        local textX = buttonX + (buttonWidth / 2) - 10  -- Moved slightly to the left from center
        local textY = buttonY + (buttonHeight / 2) - (textHeight / 2)
        
        -- Draw the text in black
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(text, textX, textY)
        
        -- Reset to default font
        love.graphics.setFont(love.graphics.getFont())
    end
    
    -- Draw collection popout on top of everything
    if Tabs.getCurrentTab() == "Collection" then
        Collection.drawPopout()
    end
end

-- Render all visual elements
-- Handles intro video, startup screen, and main game interface
function love.draw()
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    
    -- Show intro video if active
    if showIntroVideo and introVideo then
        love.graphics.setColor(1, 1, 1, 1)
        local vw, vh = introVideo:getWidth(), introVideo:getHeight()
        local scale = math.min(screenW/vw, screenH/vh)
        love.graphics.draw(introVideo, (screenW-vw*scale)/2, (screenH-vh*scale)/2, 0, scale, scale)
        return
    end

    if gameState.gameStarted then
        -- Draw main game interface with 3-panel layout
        drawGameInterface(screenW, screenH)
    else
        -- Draw startup screen and modals
        UI.drawStartupScreen(screenW, screenH, Assets.images.startupDog)
        if showSaveSelection then
            UI.drawSaveSelectionModal(screenW, screenH)
        end
        if showNamePrompt then
            UI.drawNamePromptModal(screenW, screenH)
        end
    end
end

-- Handle clicks during startup/menu phase
-- Used by love.mousepressed when game hasn't started
local function handleStartupClicks(x, y)
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    
    -- Handle name prompt modal
    if showNamePrompt then
        local result = UI.handleNamePromptClick(x, y, screenW, screenH)
        if result == "new" then
            showNamePrompt = false
            UI.setNamePromptActive(false)
            gameState = GameState.data
        end
        return
    end
    
    -- Handle save selection modal
    if showSaveSelection then
        local selectedSave = UI.handleSaveSelectionClick(x, y, screenW, screenH)
        if selectedSave == "close" then
            showSaveSelection = false
        elseif selectedSave == "prompt_name" then
            showSaveSelection = false
            showNamePrompt = true
            UI.setNamePromptActive(true)
        elseif selectedSave == "refresh" then
            -- Modal refreshes automatically
        elseif selectedSave then
            -- Load selected save and process offline progression
            showSaveSelection = false
            local offlineSummons = GameState.processOfflineTime()
            gameState.gameStarted = true
            if gameState.timeSinceClosed then
                gameState.showTimeSinceClosed = true
                gameState.showTimeSinceClosedTimer = 5
            end
        end
        return
    end
    
    -- Handle startup screen clicks
    if UI.handleStartupClick(x, y, screenW, screenH) then
        -- Clicked "Select Save" button
        local saveFiles = UI.getSaveFiles()
        if #saveFiles == 0 then
            showNamePrompt = true
            UI.setNamePromptActive(true)
        else
            showSaveSelection = true
        end
    else
        -- Clicked anywhere else - start with most recent save or create new
        local saveFiles = UI.getSaveFiles()
        if #saveFiles == 0 then
            showNamePrompt = true
            UI.setNamePromptActive(true)
        else
            -- Process offline progression before starting game
            local offlineSummons = GameState.processOfflineTime()
            gameState.gameStarted = true
            if gameState.timeSinceClosed then
                gameState.showTimeSinceClosed = true
                gameState.showTimeSinceClosedTimer = 5
            end
        end
    end
end

-- Handle clicks during active gameplay
-- Used by love.mousepressed when game is running
local function handleGameClicks(x, y)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    
    -- Use the panels module to handle divider clicks
    if Panels.mousepressed(x, y, screenW, screenH) then
        return  -- If a divider was clicked, don't process other clicks
    end
    
    -- Get panel dimensions from the panels module
    local leftPanelWidth, middlePanelWidth, rightPanelWidth, rightPanelX = Panels.getPanelDimensions(screenW, screenH)
    local bottomLeftHeight = leftPanelWidth / 4
    local topLeftHeight = screenH - bottomLeftHeight
    
    -- Check tab clicks first
    if Tabs.mousepressed(x, y, 1, 0, 0, leftPanelWidth, topLeftHeight) then
        return
    end
    
    -- Check Linktree button click in bottom left panel
    local bottomLeftPanelX = 0
    local bottomLeftPanelY = topLeftHeight
    local bottomLeftPanelWidth = leftPanelWidth
    local bottomLeftPanelHeight = bottomLeftHeight
    
    if Assets.images.linktree then
        local padding = 5  -- Small padding around the button
        local buttonWidth = bottomLeftPanelWidth - (padding * 2)
        local buttonHeight = bottomLeftPanelHeight - (padding * 2)
        local buttonX = bottomLeftPanelX + padding
        local buttonY = bottomLeftPanelY + padding
        
        if x >= buttonX and x <= buttonX + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight then
            -- Open Linktree URL in browser
            love.system.openURL("https://linktr.ee/______sage______")
            return
        end
    end
    
    -- Handle middle panel clicks based on current tab
    local currentTab = Tabs.getCurrentTab()
    if currentTab == "Player" then
        UI.handlePlayerClick(x, y, leftPanelWidth, 0, middlePanelWidth, screenH)
    elseif currentTab == "Settings" then
        UI.handleSettingsClick(x, y, leftPanelWidth, 0, middlePanelWidth, screenH, gameState, Settings.settings, Assets)
    elseif currentTab == "Collection" then
        require('source.collection').mousepressed(x, y, 1, leftPanelWidth, 0, middlePanelWidth, screenH)
    elseif currentTab == "Inventory" then
        require('source.inventory').mousepressed(x, y, 1, leftPanelWidth, 0, middlePanelWidth, screenH)
    elseif currentTab == "Hoops" then
        require('source.basketball'):mousepressed(x, y, 1)
    end
end

-- Handle mouse click events
-- Routes clicks to appropriate UI handlers based on current state
function love.mousepressed(x, y, button, istouch, presses)
    if button ~= 1 then return end -- Only handle left clicks
    
    -- Skip intro video on click
    if showIntroVideo and introVideo then
        introVideo:pause()
        showIntroVideo = false
        return
    end

    if not gameState.gameStarted then
        handleStartupClicks(x, y)
    else
        handleGameClicks(x, y)
    end
end

-- Handle keyboard input
-- Routes key presses to appropriate handlers and manages global shortcuts
function love.keypressed(k)
    -- Handle name prompt input
    if showNamePrompt then
        UI.handleNamePromptKeyPressed(k)
        if k == "return" then
            local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
            local result = UI.handleNamePromptClick(screenW/2, screenH/2 + 50, screenW, screenH)
            if result == "new" then
                showNamePrompt = false
                UI.setNamePromptActive(false)
                gameState = GameState.data
            end
        end
        return
    end
    
    -- Route to UI system
    UI.handleKeyPressed(k)
    
    -- Debug commands (Ctrl+key combinations)
    local debugModule = require('source.debug')
    if debugModule.handleKeyPressed(k) then
        -- Key was handled by debug module
        return
    end
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        if k == "c" and debugModule.isEnabled() then
            -- Add a random character for testing
            local charactersModule = require('source.characters')
            local allCharacters = charactersModule.getSortedCharacters()
            if #allCharacters > 0 then
                local randomChar = allCharacters[math.random(#allCharacters)]
                if not gameState.characters then
                    gameState.characters = {}
                end
                local charId = tostring(randomChar.id)
                gameState.characters[charId] = (gameState.characters[charId] or 0) + 1
                local charInfo = charactersModule.getCharacterInfo(randomChar.id)
                local charName = charInfo and charInfo.name or "Unknown"
                print("Added character: " .. charName)
                addLogEntry("Debug: Added " .. charName)
            end
        elseif k == "m" and debugModule.isEnabled() then
            -- Add a random material for testing
            local inventoryModule = require('source.inventory')
            local allMaterials = inventoryModule.getMaterials()
            if #allMaterials > 0 then
                local randomMaterial = allMaterials[math.random(#allMaterials)]
                inventoryModule.addItem(randomMaterial.id, 10)  -- Add 10 of the material
                print("Added material: " .. randomMaterial.name .. " (x10)")
                addLogEntry("Debug: Added " .. randomMaterial.name .. " (x10)")
            end
        elseif k == "x" and debugMenuEnabled then
            -- Add 100 of each material for testing
            local inventoryModule = require('source.inventory')
            local allMaterials = inventoryModule.getMaterials()
            for _, material in ipairs(allMaterials) do
                inventoryModule.addItem(material.id, 100)
            end
            print("Added 100 of each material")
            addLogEntry("Debug: Added 100 of each material")
        end
    end
    
    -- Global shortcuts
    if k == "f1" then
        Settings.settings.showIntroAnimation = not Settings.settings.showIntroAnimation
        Settings.save()
        print("Intro animation " .. (Settings.settings.showIntroAnimation and "enabled" or "disabled"))
    end
end

-- Handle text input for save names and other text fields
-- Routes text to appropriate input handlers
function love.textinput(text)
    if showNamePrompt then
        UI.handleNamePromptTextInput(text)
    else
        UI.handleTextInput(text)
    end
end

-- Handle mouse movement for drag operations
-- Updates tab scrolling and slider dragging
function love.mousemoved(x, y, dx, dy)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    
    -- Use the panels module to handle divider dragging
    Panels.mousemoved(x, y, screenW, screenH)
    
    -- Get panel dimensions from the panels module
    local leftPanelWidth, middlePanelWidth, rightPanelWidth, rightPanelX = Panels.getPanelDimensions(screenW, screenH)
    local bottomLeftHeight = leftPanelWidth / 4
    local topLeftHeight = screenH - bottomLeftHeight
    
    -- Get divider dragging states from the panels module
    local isDraggingVertical, isDraggingHorizontal = Panels.getDraggingStates()
    
    -- Get horizontal divider position for cursor detection
    local _, _, horizontalDividerY = Panels.getHorizontalDividerPosition(screenW, screenH)
    
    -- Change cursor when hovering over dividers
    local dividerX = leftPanelWidth + middlePanelWidth
    local dividerTolerance = 5  -- 5 pixels of tolerance on each side of the divider
    local horizontalDividerTolerance = 5  -- 5 pixels of tolerance above and below the divider
    
    if isDraggingVertical or isDraggingHorizontal then
        -- Keep resize cursor while dragging either divider
        love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))  -- or "sizens" for horizontal
    elseif x >= dividerX - dividerTolerance and x <= dividerX + dividerTolerance then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))  -- Left-right resize cursor for vertical divider
    elseif x >= rightPanelX and x <= rightPanelX + rightPanelWidth and
          y >= horizontalDividerY - horizontalDividerTolerance and y <= horizontalDividerY + horizontalDividerTolerance then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))  -- Up-down resize cursor for horizontal divider
    else
        love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))  -- Default arrow cursor
    end
    
    -- Handle tab scrolling
    Tabs.mousemoved(x, y, dx, dy, 0, 0, leftPanelWidth, topLeftHeight)
    
    -- Handle settings panel dragging (sliders)
    if gameState.gameStarted and Tabs.getCurrentTab() == "Settings" then
        UI.handleSettingsMouseMoved(x, y, leftPanelWidth, 0, middlePanelWidth, screenH)
    elseif gameState.gameStarted and Tabs.getCurrentTab() == "Collection" then
        require('source.collection').mousemoved(x, y, dx, dy, leftPanelWidth, 0, middlePanelWidth, screenH)
    elseif gameState.gameStarted and Tabs.getCurrentTab() == "Inventory" then
        require('source.inventory').mousemoved(x, y, dx, dy, leftPanelWidth, 0, middlePanelWidth, screenH)
    elseif gameState.gameStarted and Tabs.getCurrentTab() == "Hoops" then
        require('source.basketball'):mousemoved(x, y, dx, dy)
    end
end

-- Handle mouse button release
-- Stops drag operations for tabs, sliders, and dividers
function love.mousereleased(x, y, button)
    -- Use the panels module to stop divider dragging
    Panels.mousereleased()
    
    Tabs.mousereleased(x, y, button)
    UI.handleSettingsMouseReleased()
    require('source.collection').mousereleased(x, y, button)
    require('source.inventory').mousereleased(x, y, button)
    require('source.basketball'):mousereleased(x, y, button)
end

-- Handle mouse wheel scrolling
-- Used for tab navigation in left panel
function love.wheelmoved(x, y)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local leftPanelWidth, middlePanelWidth, rightPanelWidth, rightPanelX = Panels.getPanelDimensions(screenW, screenH)
    local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
    
    local bottomLeftHeight = leftPanelWidth / 4
    local topLeftHeight = screenH - bottomLeftHeight
    if not Tabs.wheelmoved(x, y, 0, 0, leftPanelWidth, topLeftHeight, mouseX, mouseY) then
        if gameState.gameStarted and Tabs.getCurrentTab() == "Collection" then
            require('source.collection').wheelmoved(x, y, leftPanelWidth, 0, middlePanelWidth, screenH, mouseX, mouseY)
        elseif gameState.gameStarted and Tabs.getCurrentTab() == "Inventory" then
            require('source.inventory').wheelmoved(x, y, leftPanelWidth, 0, middlePanelWidth, screenH, mouseX, mouseY)
        elseif gameState.gameStarted and Tabs.getCurrentTab() == "Basketball" then
            -- No wheel events for basketball game
        end
    end
end

-- Clean up resources and save state on exit
-- Ensures proper shutdown and data persistence
function love.quit()
    -- Save window dimensions
    Settings.settings.windowWidth, Settings.settings.windowHeight = love.graphics.getWidth(), love.graphics.getHeight()
    Settings.save()
    
    -- Clean up resources
    Animation.cleanup()
    Assets.cleanup()
    if introVideo then 
        introVideo:release() 
    end
    
    -- Save game state
    GameState.save()
end