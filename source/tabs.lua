-- Tabs Module
-- Manages the tabbed navigation interface for switching between game panels
-- Handles tab rendering, scrolling, selection, and user interaction

local tabs = {}

-- Tab configuration and state
local tabList = {"Player", "Collection", "Inventory", "Hoops"}  -- Available tabs
local currentTab = 1  -- Index of currently selected tab
local scrollOffset = 0  -- Vertical scroll offset for tab list
local isDragging = false  -- Whether user is dragging to scroll tabs
local dragStartY = 0  -- Starting Y position when drag began
local dragStartOffset = 0  -- Scroll offset when drag began

-- Track which tab is being pressed down for visual feedback
local pressedTab = nil

-- Draw the tab interface with visual styling
-- panelX, panelY: Position of the tab panel
-- panelWidth, panelHeight: Dimensions of the tab panel
function tabs.draw(panelX, panelY, panelWidth, panelHeight, showingSettings)
    local tabHeight = 60  -- Height of each individual tab
    local padding = 10  -- Padding around tabs
    
    -- Set clipping region to prevent tabs from drawing outside panel
    love.graphics.setScissor(panelX, panelY, panelWidth, panelHeight)
    
    -- Draw each tab in the list
    for i, tabName in ipairs(tabList) do
        local tabY = panelY + (i - 1) * tabHeight + scrollOffset  -- Calculate vertical position with scroll offset
        local isSelected = i == currentTab and not (showingSettings or false)  -- Check if this is the currently selected tab (unless settings are shown)
        local isPressed = i == pressedTab  -- Check if this tab is currently being pressed
        
        -- Only draw tabs that are visible within the panel bounds
        if tabY + tabHeight > panelY and tabY < panelY + panelHeight then
            local buttonX = panelX - padding  -- X position with padding
            local buttonY = tabY + padding  -- Y position with padding
            local buttonW = panelWidth - 5  -- Width accounting for padding
            local buttonH = tabHeight - padding  -- Height accounting for padding
            local cornerRadius = 8  -- Corner radius for rounded rectangles
            
            -- Main button fill - different colors based on state
            if isPressed then
                -- Darker color when pressed for visual feedback
                love.graphics.setColor(0.15, 0.15, 0.15, 1)
            elseif isSelected then
                -- Lighter grey for selected tab to distinguish it
                love.graphics.setColor(0.35, 0.35, 0.35, 1)
            else
                -- Default color for unselected tabs
                love.graphics.setColor(0.25, 0.25, 0.25, 1)
            end
            love.graphics.rectangle("fill", buttonX, buttonY, buttonW, buttonH, cornerRadius)
            
            -- Border styling based on tab state
            if isPressed then
                -- Darker border when pressed for tactile feedback
                love.graphics.setColor(0.4, 0.4, 0.4, 1)
            elseif isSelected then
                -- Lighter grey border for selected tab for emphasis
                love.graphics.setColor(0.7, 0.7, 0.7, 1)
            else
                -- Default border for unselected tabs
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
            end
            love.graphics.setLineWidth(2)  -- Thicker border for visibility
            love.graphics.rectangle("line", buttonX, buttonY, buttonW, buttonH, cornerRadius)
            love.graphics.setLineWidth(1)  -- Reset to default line width
            
            -- Tab text rendering
            love.graphics.setColor(1, 1, 1, 1)  -- White text for contrast
            local textWidth = love.graphics.getFont():getWidth(tabName)  -- Calculate text width for centering
            local textHeight = love.graphics.getFont():getHeight()  -- Calculate text height for centering
            love.graphics.print(tabName, panelX + (panelWidth - textWidth) / 2, buttonY + (buttonH - textHeight) / 2)
        end
    end
    
    -- Reset clipping region
    love.graphics.setScissor()
end

-- Handle mouse press events on tabs
-- x, y: Mouse position
-- button: Mouse button pressed (1 = left click)
-- panelX, panelY, panelWidth, panelHeight: Tab panel dimensions
-- Returns true if a tab was clicked or drag started, false otherwise
function tabs.mousepressed(x, y, button, panelX, panelY, panelWidth, panelHeight)
    -- Only handle left mouse button clicks within the tab panel bounds
    if button ~= 1 or x < panelX or x > panelX + panelWidth or y < panelY or y > panelY + panelHeight then
        return false
    end
    
    local tabHeight = 60  -- Height of each tab
    local padding = 10  -- Padding around tabs
    
    -- Check if any tab was clicked
    for i, tabName in ipairs(tabList) do
        local tabY = panelY + (i - 1) * tabHeight + scrollOffset  -- Calculate tab position with scroll offset
        -- Check if click is within tab bounds
        if y >= tabY + padding and y <= tabY + tabHeight - padding and tabY + tabHeight > panelY and tabY < panelY + panelHeight then
            currentTab = i  -- Set clicked tab as current tab
            pressedTab = i  -- Track which tab is pressed for visual feedback
            return true  -- Indicate that a tab was clicked
        end
    end
    
    -- If no tab was clicked, start dragging to scroll
    isDragging = true
    dragStartY = y
    dragStartOffset = scrollOffset
    return true  -- Indicate that interaction occurred
end

-- Handle mouse movement events for tab dragging and pressed state
-- x, y: Current mouse position
-- dx, dy: Change in mouse position since last event
-- panelX, panelY, panelWidth, panelHeight: Tab panel dimensions
function tabs.mousemoved(x, y, dx, dy, panelX, panelY, panelWidth, panelHeight)
    -- Handle tab scrolling when dragging
    if isDragging then
        scrollOffset = dragStartOffset + (y - dragStartY)  -- Update scroll offset based on drag distance
        tabs.clampScroll(panelHeight)  -- Clamp scroll to valid range
    -- Handle pressed tab state when not dragging
    elseif pressedTab then
        -- Check if mouse is still over the pressed tab, otherwise clear pressed state
        local tabHeight = 60
        local padding = 10
        local tabY = panelY + (pressedTab - 1) * tabHeight + scrollOffset
        -- If mouse moved outside tab bounds, clear pressed state
        if not (x >= panelX and x <= panelX + panelWidth and 
                y >= tabY + padding and y <= tabY + tabHeight - padding and 
                tabY + tabHeight > panelY and tabY < panelY + panelHeight) then
            pressedTab = nil  -- Clear pressed state if mouse moves away
        end
    end
end

-- Handle mouse release events to end dragging and clear pressed state
-- x, y: Mouse position
-- button: Mouse button released
function tabs.mousereleased(x, y, button)
    if button == 1 then
        isDragging = false  -- End dragging state
        pressedTab = nil  -- Clear pressed state when mouse is released
    end
end

-- Handle mouse wheel events for tab scrolling
-- x, y: Wheel movement (y = vertical scroll)
-- panelX, panelY, panelWidth, panelHeight: Tab panel dimensions
-- mouseX, mouseY: Current mouse position
-- Returns true if wheel event was handled, false otherwise
function tabs.wheelmoved(x, y, panelX, panelY, panelWidth, panelHeight, mouseX, mouseY)
    -- Only handle wheel events when mouse is over the tab panel
    if mouseX >= panelX and mouseX <= panelX + panelWidth and mouseY >= panelY and mouseY <= panelY + panelHeight then
        scrollOffset = scrollOffset + y * 30  -- Update scroll offset (multiplier for scroll speed)
        tabs.clampScroll(panelHeight)  -- Clamp scroll to valid range
        return true  -- Indicate that wheel event was handled
    end
    return false  -- Indicate that wheel event was not handled
end

-- Clamp scroll offset to valid range to prevent overscrolling
-- panelHeight: Height of the tab panel
function tabs.clampScroll(panelHeight)
    local tabHeight = 60  -- Height of each tab
    local totalHeight = #tabList * tabHeight  -- Total height of all tabs
    local maxScroll = math.max(0, totalHeight - panelHeight)  -- Maximum allowed scroll (prevent empty space)
    -- Clamp scroll offset between -maxScroll and 0
    scrollOffset = math.max(-maxScroll, math.min(0, scrollOffset))
end

-- Get the name of the currently selected tab
-- Returns the string name of the current tab
function tabs.getCurrentTab()
    return tabList[currentTab]
end

-- Add a new tab to the tab list
-- tabName: Name of the tab to add
function tabs.addTab(tabName)
    table.insert(tabList, tabName)
end

-- Set the current tab by name
-- tabName: Name of the tab to set as current
function tabs.setCurrentTab(tabName)
    -- Search through tab list to find matching tab
    for i, name in ipairs(tabList) do
        if name == tabName then
            currentTab = i  -- Set matching tab as current
            break
        end
    end
end

return tabs