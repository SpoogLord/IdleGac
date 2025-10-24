-- Panel management and divider dragging module
-- Handles dynamic resizing of UI panels and dividers

local panels = {}

-- Panel divider dragging state (vertical divider between middle and right panels)
local isDraggingVerticalDivider = false
local initialMiddleWidth = nil
local initialMouseX = nil

-- Animation/log divider dragging state (horizontal divider within right panel)
local isDraggingHorizontalDivider = false
local initialLogHeight = nil
local initialMouseY = nil
local logPanelHeightRatio = 0.5  -- Default: 50% of right panel for log

-- Panel sizes (with initial values)
local leftPanelWidth = 0
local middlePanelWidth = 0
local rightPanelWidth = 0
local rightPanelX = 0

-- Initialize panel sizes
function panels.initialize(screenW, screenH)
    leftPanelWidth = screenW / 5
    rightPanelWidth = screenW / 5
    middlePanelWidth = screenW - leftPanelWidth - rightPanelWidth
    rightPanelX = leftPanelWidth + middlePanelWidth
end

-- Get current panel dimensions
function panels.getPanelDimensions(screenW, screenH)
    if rightPanelWidth == 0 then
        -- Initialize with default values if not set
        panels.initialize(screenW, screenH)
    end
    
    -- Ensure middle panel width is properly calculated
    middlePanelWidth = screenW - leftPanelWidth - rightPanelWidth
    rightPanelX = leftPanelWidth + middlePanelWidth
    
    return leftPanelWidth, middlePanelWidth, rightPanelWidth, rightPanelX
end

-- Calculate horizontal divider position within right panel
function panels.getHorizontalDividerPosition(screenW, screenH)
    local rightPanelHeight = screenH
    local logHeight = rightPanelHeight * logPanelHeightRatio
    local animationHeight = rightPanelHeight - logHeight
    local horizontalDividerY = animationHeight  -- Position from top
    
    return animationHeight, logHeight, horizontalDividerY
end

-- Handle mouse pressed for panel dividers
function panels.mousepressed(x, y, screenW, screenH)
    -- Get current panel dimensions
    local leftWidth, middleWidth, rightWidth, rightX = panels.getPanelDimensions(screenW, screenH)
    
    -- Calculate the horizontal divider position within the right panel
    local rightPanelHeight = screenH
    local _, logHeight, horizontalDividerY = panels.getHorizontalDividerPosition(screenW, screenH)
    
    -- Check if clicking on the horizontal divider within the right panel
    local horizontalDividerTolerance = 5  -- 5 pixels of tolerance above and below the divider
    if x >= rightX and x <= rightX + rightWidth and
       y >= horizontalDividerY - horizontalDividerTolerance and y <= horizontalDividerY + horizontalDividerTolerance then
        isDraggingHorizontalDivider = true
        initialLogHeight = logHeight
        initialMouseY = y
        return true
    end
    
    -- Check if clicking on the vertical divider between middle and right panels
    local dividerX = leftWidth + middleWidth
    local dividerTolerance = 5  -- 5 pixels of tolerance on each side of the divider
    
    if x >= dividerX - dividerTolerance and x <= dividerX + dividerTolerance then
        isDraggingVerticalDivider = true
        initialMiddleWidth = middleWidth
        initialMouseX = x
        return true
    end
    
    return false
end

-- Handle mouse moved for panel dividers
function panels.mousemoved(x, y, screenW, screenH)
    -- Handle vertical divider dragging (between middle and right panels)
    if isDraggingVerticalDivider then
        local mouseDelta = x - initialMouseX
        local newMiddleWidth = initialMiddleWidth + mouseDelta  -- Moving mouse right increases middle panel width
        
        -- Constrain the middle panel width to reasonable limits
        local minMiddleWidth = screenW * 0.2  -- Minimum 20% of screen width
        local maxMiddleWidth = screenW * 0.7  -- Maximum 70% of screen width (leaving at least 15% for each other panel)
        
        newMiddleWidth = math.max(minMiddleWidth, math.min(maxMiddleWidth, newMiddleWidth))
        
        middlePanelWidth = newMiddleWidth
        rightPanelWidth = screenW - leftPanelWidth - middlePanelWidth
        rightPanelX = leftPanelWidth + middlePanelWidth
    end
    
    -- Handle horizontal divider dragging (between animation and log within right panel)
    if isDraggingHorizontalDivider then
        local mouseDelta = y - initialMouseY
        -- Moving mouse down should decrease animation height and increase log height
        -- So we need to decrease the animation area size (which moves the divider down)
        local newAnimationHeight = (screenH - initialLogHeight) + mouseDelta  -- Mouse movement affects animation area
        
        -- Constrain the animation panel height to reasonable limits
        local minAnimationHeight = screenH * 0.1  -- Minimum 10% of screen height for animation
        local maxAnimationHeight = screenH * 0.8  -- Maximum 80% of screen height for animation
        
        newAnimationHeight = math.max(minAnimationHeight, math.min(maxAnimationHeight, newAnimationHeight))
        
        -- Calculate log height based on remaining space
        local newLogHeight = screenH - newAnimationHeight
        
        -- Update the ratio (log height ratio)
        logPanelHeightRatio = newLogHeight / screenH
    end
end

-- Handle mouse released for panel dividers
function panels.mousereleased()
    -- Stop vertical divider dragging (between middle and right panels)
    isDraggingVerticalDivider = false
    initialMiddleWidth = nil
    initialMouseX = nil
    
    -- Stop horizontal divider dragging (between animation and log)
    isDraggingHorizontalDivider = false
    initialLogHeight = nil
    initialMouseY = nil
end

-- Get divider dragging states
function panels.getDraggingStates()
    return isDraggingVerticalDivider, isDraggingHorizontalDivider
end

-- Get log panel height ratio
function panels.getLogPanelHeightRatio()
    return logPanelHeightRatio
end

return panels