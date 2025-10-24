-- Button Module
-- Handles button rendering with selection states
-- Manages button assets and provides drawing functionality

local button = {}

-- Button asset storage
local buttonAssets = {}

-- Load button assets from file system
-- Initializes button image with nearest neighbor filtering for crisp edges
function button.load()
    -- Load button image asset
    buttonAssets.button = love.graphics.newImage('assets/button.png')
    -- Set filter to nearest neighbor to prevent blurriness when scaling
    buttonAssets.button:setFilter('nearest', 'nearest')
end

-- Draw button with optional selection highlighting
-- x, y: Position to draw the button
-- width, height: Dimensions to scale the button to
-- isSelected: Boolean indicating if button should be highlighted
function button.draw(x, y, width, height, isSelected)
    -- Set color based on selection state (blue highlight when selected)
    love.graphics.setColor(isSelected and {0.8, 0.8, 1, 1} or {1, 1, 1, 1})
    -- Draw button image scaled to requested dimensions
    love.graphics.draw(buttonAssets.button, x, y, 0, width / buttonAssets.button:getWidth(), height / buttonAssets.button:getHeight())
end

-- Clean up button assets to free memory
-- Releases button image resource
function button.cleanup()
    if buttonAssets.button then
        buttonAssets.button:release()
    end
end

return button