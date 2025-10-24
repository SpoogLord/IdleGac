-- Event log module
-- Handles logging of game events and displaying them in the UI

local eventlog = {}

-- Event log storage
local eventLog = {}
local maxLogEntries = 50  -- Maximum number of log entries to keep

-- Define rarity colors
local rarityColors = {
    ["Common"] = {1.0, 1.0, 1.0},      -- White - #fff (0xffffff)
    ["Uncommon"] = {0.0, 0.37, 0.12},  -- Forest green - #005f1e (0x005f1e)
    ["Rare"] = {0.0, 0.15, 0.55},      -- Dark blue - #00278e (0x00278e)
    ["Epic"] = {0.27, 0.0, 0.55},      -- Soft purple - #44008e (0x44008e)
    ["Legendary"] = {0.65, 0.0, 1.0},  -- Bright purple - #a700ff (0xa700ff)
    ["Mythic"] = {0.0, 0.27, 1.0},     -- Bright blue - #0045ff (0x0045ff)
    ["Ascendant"] = {0.0, 0.71, 1.0},  -- Baby blue - #00b6ff (0x00b6ff)
    ["Superior"] = {0.92, 1.0, 0.0},   -- Yellow - #eaff00 (0xeaff00)
    ["Ultimate"] = {1.0, 0.68, 0.0},   -- Orange - #ffae00 (0xffae00)
    ["Deific"] = {1.0, 0.0, 0.0}       -- Red - #ff0000 (0xff0000)
}

-- Add an entry to the event log
function eventlog.addEntry(message)
    table.insert(eventLog, {text = message, time = love.timer.getTime()})
    
    -- Keep only the most recent entries
    if #eventLog > maxLogEntries then
        table.remove(eventLog, 1)  -- Remove the oldest entry from the beginning
    end
end

-- Draw the event log in the specified area
function eventlog.draw(logX, logY, logWidth, logHeight)
    -- Draw log entries with colored character names based on rarity
    local font = love.graphics.getFont()
    local lineHeight = font:getHeight() + 2
    local maxLines = math.floor(logHeight / lineHeight) - 1  -- Leave some padding

    -- Draw from bottom to top (newest entries at the bottom)
    for i = 1, maxLines do
        -- Calculate which log entry to draw (from the end of the list)
        local entryIndex = #eventLog - maxLines + i
        if entryIndex > 0 and entryIndex <= #eventLog then
            local entry = eventLog[entryIndex]
            if entry then
                -- Position from the bottom of the log area
                local y = logY + logHeight - 5 - (maxLines - i + 1) * lineHeight
                local message = entry.text
                
                -- Check if this is a summon message to color the character name
                local isSummonMessage = string.find(message, "^Summoned:")
                if isSummonMessage then
                    -- Parse the message: "Summoned: [Character Name] ([Rarity])"
                    local characterName, rarity = string.match(message, "Summoned: (.-) %((.-)%)")
                    if characterName and rarity then
                        -- Split the message into parts
                        local prefix = "Summoned: "
                        local suffix = " (" .. rarity .. ")"
                        
                        -- Draw prefix in white
                        love.graphics.setColor(1, 1, 1, 1)
                        love.graphics.print(prefix, logX + 5, y)
                        
                        -- Get text width of prefix to position the character name
                        local prefixWidth = font:getWidth(prefix)
                        
                        -- Draw character name in rarity color
                        local color = rarityColors[rarity] or {1, 1, 1} -- Default to white
                        love.graphics.setColor(color[1], color[2], color[3], 1)
                        love.graphics.print(characterName, logX + 5 + prefixWidth, y)
                        
                        -- Get text width of character name to position the suffix
                        local charNameWidth = font:getWidth(characterName)
                        
                        -- Draw suffix in white
                        love.graphics.setColor(1, 1, 1, 1)
                        love.graphics.print(suffix, logX + 5 + prefixWidth + charNameWidth, y)
                    else
                        -- If parsing fails, just print the message in white
                        love.graphics.setColor(1, 1, 1, 1)
                        love.graphics.print(message, logX + 5, y)
                    end
                else
                    -- For non-summon messages, print in white
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.print(message, logX + 5, y)
                end
            end
        end
    end
end

-- Get the event log data for external use
function eventlog.getLog()
    return eventLog
end

return eventlog