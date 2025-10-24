-- Debug Module
-- Handles all debug functionality for the application

local debug = {}

-- Runtime-only debug mode variable (not saved between sessions)
local debugMode = false

-- Initialize debug system
function debug.init()
    -- Initialize runtime debug mode to false
    debugMode = false
end

-- Toggle global debug mode
function debug.toggleDebugMode()
    debugMode = not debugMode
    return debugMode
end

-- Check if debug mode is enabled
function debug.isEnabled()
    return debugMode
end

-- Set debug mode directly (for UI integration)
function debug.setDebugMode(enabled)
    debugMode = enabled
end

-- Debug drawing function - draws colliders or other debug info when enabled
function debug.draw()
    -- This function can be called from anywhere to draw debug info
    -- Actual debug drawing is handled by individual modules when debug mode is enabled
end

-- Debug key handling
function debug.handleKeyPressed(key)
    -- Handle debug-specific key combinations
    if key == "d" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
        local newMode = debug.toggleDebugMode()
        print("Debug mode " .. (newMode and "enabled" or "disabled"))
        return true  -- Indicate that the key was handled
    end
    return false
end

return debug