-- Animation Module
-- Manages gacha animation playback with memory-efficient frame loading
-- Handles 4047 frame sequence with dynamic loading and speed control

local animation = {}

-- Animation state
local gachaFrames = {}          -- Frame cache (only stores current frame)
local frameTimer = 0            -- Timer for frame advancement
local frameRate = 1/29.5        -- Base frame rate (29.5 FPS)
local maxFrames = 4047          -- Total frames in animation sequence
local globalFrameIndex = 1      -- Current frame position
local cacheSize = 3             -- Legacy cache size (now only uses 1 frame)

-- Summon timing (independent of animation)
local summonTimer = 0           -- Time accumulator for summons
local lastGachaSpeed = 1        -- Track the last gacha speed for proper progress calculation
local baseSummonInterval = maxFrames / 29.5  -- Time for one full animation cycle at base speed

-- ============================================================================
-- ANIMATION INITIALIZATION AND CONTROL
-- ============================================================================

-- Initialize animation system by loading first frame
-- Called once during game startup
function animation.init()
    -- Load only the first frame to minimize memory usage
    gachaFrames[1] = love.graphics.newImage('assets/gachaFrames/frame0001.png')
end

-- Set animation to specific frame (used when loading save)
-- Clamps frame to valid range and loads the frame image
function animation.setFrame(frame)
    globalFrameIndex = math.max(1, math.min(maxFrames, frame))
    if gachaFrames[1] then 
        gachaFrames[1]:release() 
    end
    gachaFrames[1] = love.graphics.newImage('assets/gachaFrames/frame' .. string.format('%04d', globalFrameIndex) .. '.png')
end

-- Get current frame index for save persistence
-- Returns the current position in the animation sequence
function animation.getCurrentFrameIndex()
    return globalFrameIndex
end

-- ============================================================================
-- ANIMATION UPDATE
-- ============================================================================

-- Update animation frame based on speed and time
-- Called every frame by main.lua with current gacha speed multiplier
function animation.update(dt, gachaSpeed)
    -- Calculate summon interval based on current speed
    local currentSummonInterval = baseSummonInterval / gachaSpeed
    
    -- Handle speed change: adjust timer to maintain consistent progress
    if lastGachaSpeed ~= gachaSpeed and lastGachaSpeed ~= 0 then
        -- Convert current progress to time at new speed
        local currentProgress = summonTimer / (baseSummonInterval / lastGachaSpeed)
        summonTimer = currentProgress * currentSummonInterval
    end
    
    -- Update time-based summon system (lag-independent)
    summonTimer = summonTimer + dt
    lastGachaSpeed = gachaSpeed  -- Update last speed for next frame
    
    -- Handle multiple summons if the timer exceeds the interval
    -- This prevents skipping summons when speed changes
    while summonTimer >= currentSummonInterval do
        summonTimer = summonTimer - currentSummonInterval
        -- Trigger summon regardless of animation state
        local charactersModule = require('source.characters')
        local drawnCharacter = charactersModule.drawCharacter()
        if drawnCharacter then
            local characterInfo = charactersModule.getCharacterInfo(drawnCharacter.id)
            local characterName = characterInfo and characterInfo.name or "Unknown"
            -- Log the summon event using the global function from main
            if _G.addLogEntry then
                _G.addLogEntry("Summoned: " .. characterName .. " (" .. charactersModule.getRarityName(characterInfo.rarity) .. ")")
            end
            print("Drew character: " .. characterName .. " (ID: " .. drawnCharacter.id .. ")")
            
            -- Auto-save after each summon (without logging)
            local gameState = require('source.gamestate')
            gameState.save()
        else
            print("No character drawn this summon")
        end
    end
    
    -- Sync animation frame to summon progress
    -- Calculate progress based on summon timer and interval to maintain smooth animation
    local progress = summonTimer / currentSummonInterval
    -- Ensure progress doesn't go above 1 (in case of accumulated time)
    progress = math.min(progress, 1.0)
    local targetFrame = math.floor(progress * maxFrames) + 1
    targetFrame = math.max(1, math.min(maxFrames, targetFrame))
    if targetFrame ~= globalFrameIndex then
        globalFrameIndex = targetFrame
        
        -- Load new frame (release old one first)
        if gachaFrames[1] then 
            gachaFrames[1]:release() 
        end
        gachaFrames[1] = love.graphics.newImage('assets/gachaFrames/frame' .. string.format('%04d', globalFrameIndex) .. '.png')
        
        -- Save current frame position for persistence
        if gameState then
            gameState.animationFrame = globalFrameIndex
        end
    end
end

-- ============================================================================
-- ANIMATION ACCESS AND CLEANUP
-- ============================================================================

-- Get current frame texture for rendering
-- Returns the currently loaded frame image
function animation.getCurrentFrame()
    return gachaFrames[1]
end

-- Get summon progress as percentage (0.0 to 1.0)
-- Used for progress bar display in UI
function animation.getProgress()
    local summonInterval = baseSummonInterval / (gameState and gameState.gachaSpeed or 1)
    return summonTimer / summonInterval
end

-- Clean up animation resources on shutdown
-- Releases all loaded frame textures
function animation.cleanup()
    for i = 1, #gachaFrames do
        if gachaFrames[i] then
            gachaFrames[i]:release()
        end
    end
end

return animation