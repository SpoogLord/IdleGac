-- Settings Module
-- Manages application configuration with JSON persistence
-- Handles window dimensions, UI preferences, and player data

-- Default settings structure
local settings = {
    showIntroAnimation = true,    -- Whether to play intro video on startup
    windowWidth = 1728,          -- Default window width
    windowHeight = 972,          -- Default window height
    lastPlayerName = "Player",    -- Last used player name for save selection
    reduceFlashing = false,       -- Reduce brightness of animation panel
    showFPS = true               -- Whether to show the FPS counter
}

-- Save current settings to JSON file
-- Creates settings.json with current configuration
local function saveSettings()
    local success, message = love.filesystem.write('settings.json', require('source.json').encode(settings))
    if not success then
        print("Failed to save settings: " .. message)
    end
end

-- Load settings from JSON file with fallback to defaults
-- Preserves existing defaults when new settings are added
local function loadSettings()
    if love.filesystem.getInfo('settings.json') then
        local content = love.filesystem.read('settings.json')
        if content then
            local success, decoded = pcall(function()
                return require('source.json').decode(content)
            end)
            if success and decoded then
                -- Merge loaded settings with defaults (preserves new defaults)
                for k, v in pairs(decoded) do
                    settings[k] = v
                end
            end
        end
    end
    -- Ensure settings file exists
    saveSettings()
end

-- Module exports
return {
    settings = settings,      -- Settings table (read/write access)
    save = saveSettings,      -- Function to save settings to file
    load = loadSettings       -- Function to load settings from file
}