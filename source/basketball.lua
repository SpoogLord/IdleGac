-- Hoops Minigame Module
-- Implements a drag and release basketball shooting game

local basketball = {}

-- Game state
basketball.active = false
basketball.score = 0
basketball.shots = 0
basketball.ball = {}
basketball.hoop = {}
basketball.dragging = false
basketball.inFlight = false
basketball.gravity = 600  -- pixels per second squared (increased gravity)
basketball.ballRadius = 20
basketball.courtWidth = 800
basketball.courtHeight = 600  -- Increased to match middle pane height
-- Mouse tracking for momentum calculation
basketball.prevBallX = 0
basketball.prevBallY = 0
basketball.lastTime = 0
-- Track ball position relative to hoop for scoring
basketball.prevBallYRelativeToHoop = 0

function basketball:init()
    -- Initialize basketball game
    -- Sets up initial ball position, physics properties, and loads assets
    self.ball.x = 100  -- Spawn ball on the left side
    self.ball.y = 450  -- Adjusted for taller court
    self.ball.startX = self.ball.x  -- Store initial position for resets
    self.ball.startY = self.ball.y  -- Store initial position for resets
    self.ball.velocityX = 0  -- Initial horizontal velocity
    self.ball.velocityY = 0  -- Initial vertical velocity
    self.ball.rotation = 0  -- Initial rotation angle
    self.ball.rotationSpeed = 0  -- Initial rotation speed
    -- Initialize hoop table if it doesn't exist
    if not self.hoop then
        self.hoop = {}
    end
    self.hoop.x = 700  -- Hoop farther on the right side
    -- Randomize hoop height directly instead of calling function to avoid self issues
    local minHeight = 100  -- Minimum height (higher = harder)
    local maxHeight = 300  -- Maximum height (lower = easier)
    self.hoop.y = math.random(minHeight, maxHeight)  -- Random vertical position
    self.hoop.width = 80  -- Width of the hoop
    self.hoop.height = 5  -- Height of the hoop
    self.active = true  -- Enable the game
    self.score = 0  -- Initialize score counter
    self.shots = 0  -- Initialize shot counter
    -- Initialize mouse tracking variables for momentum calculation
    self.prevBallX = self.ball.x
    self.prevBallY = self.ball.y
    self.lastTime = love.timer.getTime()
    -- Initialize hoop tracking for scoring calculations
    self.prevBallYRelativeToHoop = self.ball.y - self.hoop.y
    -- Load basketball image from Hoops folder
    if love.filesystem.getInfo("assets/Hoops/basketball.png") then
        self.basketballImage = love.graphics.newImage("assets/Hoops/basketball.png")
        -- Set filter to linear for smoother scaling
        self.basketballImage:setFilter("linear", "linear")
    else
        self.basketballImage = nil
    end
    
    -- Load hoop image from Hoops folder
    if love.filesystem.getInfo("assets/Hoops/hoop.png") then
        self.hoopImage = love.graphics.newImage("assets/Hoops/hoop.png")
        -- Set filter to linear for smoother scaling
        self.hoopImage:setFilter("linear", "linear")
    else
        self.hoopImage = nil
    end
    
    -- Initialize fonts for UI elements
    self.font16 = love.graphics.newFont(16)
    self.font14 = love.graphics.newFont(14)
    
    -- Set initial hoop height and reset ball position
    self:resetBallAndHoop()
end

function basketball:resetBallAndHoop()
    -- Reset ball to starting position
    self.ball.x = self.ball.startX
    self.ball.y = self.ball.startY
    self.ball.velocityX = 0
    self.ball.velocityY = 0
    self.ball.rotation = 0
    self.ball.rotationSpeed = 0
    -- Randomize hoop height for next shot
    -- these are inverted and i dont care to fix it
    local minHeight = 200  -- 
    local maxHeight = 500  -- 
    self.hoop.y = math.random(minHeight, maxHeight)
    -- Reset hoop tracking
    self.prevBallYRelativeToHoop = self.ball.y - self.hoop.y
end

function basketball:enter()
    -- Called when entering the hoops tab
    -- This function activates the basketball game and initializes it if needed
    self.active = true  -- Enable the game
    if not self.ball.x then
        self:init()  -- Initialize game if not already done
    end
end

function basketball:exit()
    -- Called when leaving the hoops tab
    -- This function deactivates the basketball game
    self.active = false  -- Disable the game
end

function basketball:update(dt)
    -- Main game loop update function
    -- Handles physics simulation, collision detection, and game state management
    if not self.active then return end
    
    -- Update physics if ball is in flight
    if self.inFlight then
        -- Apply gravity to simulate realistic falling motion
        self.ball.velocityY = self.ball.velocityY + self.gravity * dt
        
        -- Update position based on current velocity
        self.ball.x = self.ball.x + self.ball.velocityX * dt
        self.ball.y = self.ball.y + self.ball.velocityY * dt
        
        -- Update ball rotation for visual effect
        self.ball.rotation = self.ball.rotation + self.ball.rotationSpeed * dt * 0.3  -- Even more gradual rotation update
        
        -- Check for collisions with court boundaries and handle bounces
        -- Bottom boundary (ground) - ball bounces when it hits the floor
        if self.ball.y + self.ballRadius >= self.courtHeight then
            self.ball.y = self.courtHeight - self.ballRadius  -- Position ball at boundary
            -- Bounce with energy loss to eventually stop the ball
            self.ball.velocityY = -math.abs(self.ball.velocityY) * 0.6  -- Ensure it bounces upward
            self.ball.velocityX = self.ball.velocityX * 0.8  -- Reduce horizontal speed on bounce
            
            -- Add spin based on horizontal velocity for realistic bounce effect
            self.ball.rotationSpeed = self.ball.velocityX * 0.2  -- Add rotation based on horizontal velocity
            
            -- Stop ball if velocity is very low (ball has settled)
            if math.abs(self.ball.velocityY) < 20 and math.abs(self.ball.velocityX) < 20 then
                self.inFlight = false  -- End flight state
                self.shots = self.shots + 1  -- Increment shot counter
                -- Reset ball position and randomize hoop height
                self:resetBallAndHoop()
            end
        end
        
        -- Top boundary - ball bounces when it hits the ceiling
        if self.ball.y - self.ballRadius <= 0 then
            self.ball.y = self.ballRadius  -- Position ball at boundary
            self.ball.velocityY = math.abs(self.ball.velocityY) * 0.7  -- Ensure it bounces downward
            -- Add rotation on bounce
            self.ball.rotationSpeed = self.ball.rotationSpeed + (self.ball.velocityX * 0.05)
        end
        
        -- Left boundary - ball bounces when it hits the left wall
        if self.ball.x - self.ballRadius <= 0 then
            self.ball.x = self.ballRadius  -- Position ball at boundary
            self.ball.velocityX = math.abs(self.ball.velocityX) * 0.7  -- Ensure it bounces rightward
            -- Add rotation on bounce
            self.ball.rotationSpeed = self.ball.rotationSpeed + (self.ball.velocityY * 0.05)
        end
        
        -- Right boundary - ball bounces when it hits the right wall
        if self.ball.x + self.ballRadius >= self.courtWidth then
            self.ball.x = self.courtWidth - self.ballRadius  -- Position ball at boundary
            self.ball.velocityX = -math.abs(self.ball.velocityX) * 0.7  -- Ensure it bounces leftward
            -- Add rotation on bounce
            self.ball.rotationSpeed = self.ball.rotationSpeed - (self.ball.velocityY * 0.05)
        end
        
        -- Check for collisions with middle wall and handle appropriately
        if self:checkWallCollision() then
            self:handleWallCollision()
        end
        
        -- Check for collisions with rim edges (creates 3D hoop effect)
        local hasRimCollision, rimSide = self:checkRimEdgeCollision()
        if hasRimCollision then
            self:handleRimEdgeCollision(rimSide)
        end
        
        -- Check for collisions with hoop (scoring) - only call once to prevent double scoring
        if self:checkHoopCollision() then
            self:makeScore()
        end
        
        -- Update previous position relative to hoop for next frame (used for scoring logic)
        self.prevBallYRelativeToHoop = self.ball.y - self.hoop.y
        
        -- Check if ball is out of bounds and reset if necessary
        if self.ball.x < -50 or self.ball.x > self.courtWidth + 50 or self.ball.y > self.courtHeight + 50 then
            self.inFlight = false  -- End flight state
            self.shots = self.shots + 1  -- Increment shot counter
            -- Reset ball position and randomize hoop height
            self:resetBallAndHoop()
        end
    elseif self.dragging then
        -- Store previous position and time for velocity calculation at release
        -- This allows the ball to be thrown with momentum based on the drag speed
        self.prevBallX = self.ball.x
        self.prevBallY = self.ball.y
        self.lastTime = love.timer.getTime()
        
        -- While dragging, apply force toward the mouse as if on a bungee cord
        -- This creates the slingshot effect when dragging the ball
        local mouseX, mouseY = love.mouse.getPosition()
        
        -- Calculate scale and offset to convert screen coordinates to game coordinates
        -- This handles the transformation between UI panel and game court
        local scaleX = self.panelWidth / self.courtWidth
        local scaleY = self.panelHeight / self.courtHeight
        local scale = math.min(scaleX, scaleY) * 0.95  -- Slightly smaller than panel
        local offsetX = self.panelX + (self.panelWidth - (self.courtWidth * scale)) / 2
        local offsetY = self.panelY + (self.panelHeight - (self.courtHeight * scale)) / 2
        
        -- Convert screen mouse position to game coordinates
        local gameMouseX = (mouseX - offsetX) / scale
        local gameMouseY = (mouseY - offsetY) / scale
        
        -- Apply gravity while dragging to make the physics feel more realistic
        self.ball.velocityY = self.ball.velocityY + self.gravity * dt
        
        -- Calculate direction from ball to mouse for spring physics
        local dx = gameMouseX - self.ball.x
        local dy = gameMouseY - self.ball.y
        local distance = math.sqrt(dx * dx + dy * dy)
        
        -- Apply spring physics toward mouse position (like a bungee cord)
        -- This creates the elastic drag effect
        local targetX = gameMouseX
        local targetY = gameMouseY
        
        -- Calculate the "stretch" of the bungee cord for spring force calculation
        local stretchX = targetX - self.ball.x
        local stretchY = targetY - self.ball.y
        
        -- Apply spring force (Hooke's law: F = -kx) and damping
        -- This creates realistic elastic physics
        local springConstant = 40  -- Increased spring stiffness for stronger bungee
        local dampingConstant = 10  -- Damping to prevent oscillation
        
        -- Calculate acceleration using F = ma (assuming mass = 1)
        local accelX = stretchX * springConstant - self.ball.velocityX * dampingConstant
        local accelY = stretchY * springConstant - self.ball.velocityY * dampingConstant
        
        -- Update velocity with calculated acceleration
        self.ball.velocityX = self.ball.velocityX + accelX * dt
        self.ball.velocityY = self.ball.velocityY + accelY * dt
        
        -- Update position with new velocity
        -- No additional scaling needed since physics are in game coordinates
        self.ball.x = self.ball.x + self.ball.velocityX * dt
        self.ball.y = self.ball.y + self.ball.velocityY * dt
        
        -- Keep ball within court boundaries while dragging
        -- This prevents the ball from being dragged outside the playable area
        if self.ball.x - self.ballRadius < 0 then
            self.ball.x = self.ballRadius  -- Stop at left boundary
            if self.ball.velocityX < 0 then
                self.ball.velocityX = 0  -- Stop movement in that direction
            end
        elseif self.ball.x + self.ballRadius > self.courtWidth then
            self.ball.x = self.courtWidth - self.ballRadius  -- Stop at right boundary
            if self.ball.velocityX > 0 then
                self.ball.velocityX = 0  -- Stop movement in that direction
            end
        end
        
        if self.ball.y - self.ballRadius < 0 then
            self.ball.y = self.ballRadius  -- Stop at top boundary
            if self.ball.velocityY < 0 then
                self.ball.velocityY = 0  -- Stop movement in that direction
            end
        elseif self.ball.y + self.ballRadius > self.courtHeight then
            self.ball.y = self.courtHeight - self.ballRadius  -- Stop at bottom boundary
            if self.ball.velocityY > 0 then
                self.ball.velocityY = 0  -- Stop movement in that direction
            end
        end
        
        -- Check for and prevent dragging through the middle wall
        -- This ensures the ball doesn't pass through obstacles while dragging
        if self:checkWallCollision() then
            self:handleWallCollision()
        end
        
        -- Check for and prevent dragging through rim edges (3D hoop effect)
        -- This ensures the ball doesn't pass through the hoop edges while dragging
        local hasRimCollision, rimSide = self:checkRimEdgeCollision()
        if hasRimCollision then
            self:handleRimEdgeCollision(rimSide)
        end
        
        -- Check if the ball has crossed the 1/3 line from the left (auto-release)
        -- This automatically releases the ball if it's dragged too far right
        local debugModule = require('source.debug')
        if not debugModule.isEnabled() then  -- Only auto-release when debug mode is not active
            local lineX = self.courtWidth / 3  -- Position where auto-release triggers
            if self.ball.x > lineX then
                -- Auto-release the ball and start flight
                self.dragging = false  -- End dragging state
                -- Apply a power boost to the velocity when auto-releasing
                local power = 1.5  -- Boost the velocity slightly for better throws
                self.ball.velocityX = self.ball.velocityX * power
                self.ball.velocityY = self.ball.velocityY * power
                self.inFlight = true  -- Begin flight physics
            end
        end
    end
end

function basketball:checkHoopCollision()
    -- Check if ball passes through the hoop from above (only score when going through net)
    -- This function detects when the ball goes through the hoop for scoring
    local ballLeft = self.ball.x - self.ballRadius  -- Left edge of ball
    local ballRight = self.ball.x + self.ballRadius  -- Right edge of ball
    local ballTop = self.ball.y - self.ballRadius  -- Top edge of ball
    local ballBottom = self.ball.y + self.ballRadius  -- Bottom edge of ball
    
    local hoopLeft = self.hoop.x  -- Left edge of hoop
    local hoopRight = self.hoop.x + self.hoop.width  -- Right edge of hoop
    local hoopTop = self.hoop.y  -- Top edge of hoop (where the net would be)
    
    -- Check if the ball is horizontally within the hoop area
    local inHoopHorizontally = self.ball.x > hoopLeft and self.ball.x < hoopRight
    
    -- Check if the ball just passed through the hoop from above
    -- This happens when the ball was previously above the hoop and is now below it
    local ballCurrentlyBelowHoop = self.ball.y > hoopTop  -- Ball is now below the hoop
    local ballWasAboveHoop = self.prevBallYRelativeToHoop < 0  -- Previously above the hoop
    local ballMovingDownward = self.ball.velocityY > 0  -- Ball is moving downward
    
    -- Score only when ball is moving downward, was above the hoop, and is now below it
    if inHoopHorizontally and ballWasAboveHoop and ballCurrentlyBelowHoop and ballMovingDownward then
        return true  -- Ball has passed through hoop for scoring
    end
    return false  -- No scoring collision detected
end

function basketball:checkWallCollision()
    -- Check if ball is within middle wall boundaries
    -- This function detects when the ball collides with the center wall obstacle
    local wallX = self.courtWidth / 2 - 5  -- Center minus half wall width (5 pixels from center)
    local wallWidth = 10  -- Width of the wall obstacle
    local wallHeight = self.courtHeight / 2  -- Height of the wall (half the court)
    local wallY = self.courtHeight - wallHeight  -- Wall starts from bottom and goes up halfway
    
    -- Calculate ball boundaries for collision detection
    local ballLeft = self.ball.x - self.ballRadius  -- Left edge of ball
    local ballRight = self.ball.x + self.ballRadius  -- Right edge of ball
    local ballTop = self.ball.y - self.ballRadius  -- Top edge of ball
    local ballBottom = self.ball.y + self.ballRadius  -- Bottom edge of ball
    
    -- Check if ball intersects with wall rectangle
    if ballRight > wallX and ballLeft < wallX + wallWidth and 
       ballBottom > wallY and ballTop < wallY + wallHeight then
        return true  -- Collision detected with wall
    end
    return false  -- No collision with wall
end

function basketball:handleWallCollision()
    -- Handle collision response for middle wall collisions
    -- This function responds to collisions with the middle wall obstacle
    -- Calculate wall boundaries
    local wallX = self.courtWidth / 2 - 5  -- Left edge of wall (center minus half width)
    local wallWidth = 10  -- Width of wall
    local wallHeight = self.courtHeight / 2  -- Height of wall (half court)
    local wallY = self.courtHeight - wallHeight  -- Top of wall (from bottom up)
    
    -- Determine collision side and respond accordingly
    local ballLeft = self.ball.x - self.ballRadius  -- Left edge of ball
    local ballRight = self.ball.x + self.ballRadius  -- Right edge of ball
    local ballTop = self.ball.y - self.ballRadius  -- Top edge of ball
    local ballBottom = self.ball.y + self.ballRadius  -- Bottom edge of ball
    
    -- Calculate penetration depths for each side
    local penLeft = (ballRight - wallX)  -- Penetration from the left side of wall
    local penRight = (wallX + wallWidth - ballLeft)  -- Penetration from the right side of wall
    local penTop = (ballBottom - wallY)  -- Penetration from the top side of wall
    local penBottom = (wallY + wallHeight - ballTop)  -- Penetration from the bottom side of wall
    
    -- Check collision from left side of wall (ball moving right, hits right side of wall)
    if self.ball.velocityX > 0 and ballRight > wallX and ballBottom > wallY and ballTop < wallY + wallHeight then
        -- Only push out if ball is actually penetrating
        if penLeft > 0 then
            self.ball.x = wallX - self.ballRadius  -- Position ball to the left of wall
        end
        self.ball.velocityX = -math.abs(self.ball.velocityX) * 0.7  -- Bounce with energy loss (reverse horizontal velocity)
    -- Check collision from right side of wall (ball moving left, hits left side of wall)
    elseif self.ball.velocityX < 0 and ballLeft < wallX + wallWidth and ballBottom > wallY and ballTop < wallY + wallHeight then
        -- Only push out if ball is actually penetrating
        if penRight > 0 then
            self.ball.x = wallX + wallWidth + self.ballRadius  -- Position ball to the right of wall
        end
        self.ball.velocityX = math.abs(self.ball.velocityX) * 0.7  -- Bounce with energy loss (reverse horizontal velocity)
    -- Check collision from top of wall (ball moving up, hits bottom of wall)
    elseif self.ball.velocityY < 0 and ballTop < wallY + wallHeight and ballBottom > wallY and
           ballRight > wallX and ballLeft < wallX + wallWidth then
        -- Only push out if ball is actually penetrating
        if penTop > 0 then
            self.ball.y = wallY - self.ballRadius  -- Position ball above wall
        end
        self.ball.velocityY = math.abs(self.ball.velocityY) * 0.7  -- Bounce with energy loss (moving up)
    -- Check collision from bottom of wall (rare case - ball moving down, hits top of wall)
    elseif self.ball.velocityY > 0 and ballBottom > wallY and ballTop < wallY and
           ballRight > wallX and ballLeft < wallX + wallWidth then
        -- Only push out if ball is actually penetrating
        if penBottom > 0 then
            self.ball.y = wallY + wallHeight + self.ballRadius  -- Position ball below wall
        end
        self.ball.velocityY = -math.abs(self.ball.velocityY) * 0.7  -- Bounce with energy loss (reverse vertical velocity)
    end
end





function basketball:checkRimEdgeCollision()
    -- Check for collisions with rim edges to create 3D hoop effect
    -- This function detects when the ball hits the left or right edges of the hoop
    local ballLeft = self.ball.x - self.ballRadius  -- Left edge of ball
    local ballRight = self.ball.x + self.ballRadius  -- Right edge of ball
    local ballTop = self.ball.y - self.ballRadius  -- Top edge of ball
    local ballBottom = self.ball.y + self.ballRadius  -- Bottom edge of ball
    
    -- Define small rectangular colliders for rim edges
    local rimLeft = self.hoop.x  -- Left edge of the hoop
    local rimRight = self.hoop.x + self.hoop.width  -- Right edge of the hoop
    local rimTop = self.hoop.y  -- Top edge of the hoop
    local rimBottom = self.hoop.y + self.hoop.height  -- Bottom edge of the hoop
    
    -- Position collision boxes to catch side impacts but avoid top/bottom issues
    local collisionWidth = 8  -- Narrow width for precise side collision
    local collisionHeight = self.hoop.height * 0.8  -- 80% of rim height, avoiding top/bottom extremes
    local collisionY = rimTop + (self.hoop.height - collisionHeight) / 2  -- Position vertically centered
    
    -- Left edge collider (front) - pushes ball to the left when it hits from right
    local leftFrontColliderX = rimLeft - collisionWidth  -- Positioned to the left of the rim
    local leftFrontColliderY = collisionY  -- Vertically centered
    
    -- Right edge collider (back) - pushes ball to the left when it hits from right
    local rightBackColliderX = rimRight - collisionWidth  -- Behind the front right collider
    local rightBackColliderY = collisionY  -- Vertically centered
    
    -- Check for collision with left front edge, pushes ball left
    if self.ball.velocityX > 0 and  -- Ball moving right
       ballRight > leftFrontColliderX and ballLeft < leftFrontColliderX + collisionWidth and
       ballBottom > leftFrontColliderY and ballTop < leftFrontColliderY + collisionHeight then
        return true, "left_front"  -- Collision detected with left front edge
    end
    
    -- Check for collision with right back edge, pushes ball left
    if self.ball.velocityX > 0 and  -- Ball moving right (hitting back of right side)
       ballLeft < rightBackColliderX + collisionWidth and ballRight > rightBackColliderX and
       ballBottom > rightBackColliderY and ballTop < rightBackColliderY + collisionHeight then
        return true, "right_back"  -- Collision detected with right back edge
    end
    
    return false, nil  -- No collision detected
end

function basketball:handleRimEdgeCollision(edgeSide)
    -- Handle collision response for rim edge collisions
    -- This function responds to collisions with the rim edges to create realistic bounce effects
    if edgeSide == "left_front" then
        -- Collision with front of left edge - push ball to the left
        self.ball.x = self.hoop.x - self.ballRadius  -- Position ball to the left of the rim
        self.ball.velocityX = -math.abs(self.ball.velocityX) * 0.7  -- Bounce with energy loss (push left)
    elseif edgeSide == "right_back" then
        -- Collision with back of right edge - push ball to the left
        self.ball.x = self.hoop.x + self.hoop.width - self.ballRadius  -- Position ball to the left of the right edge
        self.ball.velocityX = -math.abs(self.ball.velocityX) * 0.7  -- Bounce with energy loss (push left)
    end
end

function basketball:makeScore()
    -- Award points for successful basket and reset game state
    -- This function is called when the ball passes through the hoop from above
    self.score = self.score + 1  -- Increment score counter
    self.inFlight = false  -- End flight state
    -- Reset ball position and randomize hoop height for next shot
    self:resetBallAndHoop()
end



function basketball:mousepressed(x, y, button)
    -- Handle mouse press events for dragging the ball
    -- This function starts dragging when the user clicks on the ball
    if not self.active then return end
    
    -- Calculate scale and offset to convert screen coordinates to game coordinates
    -- This handles the transformation between UI panel and game court
    local scaleX = self.panelWidth / self.courtWidth
    local scaleY = self.panelHeight / self.courtHeight
    local scale = math.min(scaleX, scaleY) * 0.95  -- Slightly smaller than panel
    local offsetX = self.panelX + (self.panelWidth - (self.courtWidth * scale)) / 2
    local offsetY = self.panelY + (self.panelHeight - (self.courtHeight * scale)) / 2
    
    -- Convert screen coordinates to game coordinates
    local gameX = (x - offsetX) / scale
    local gameY = (y - offsetY) / scale
    
    -- Check if mouse is over the ball (circle collision detection)
    local dx = gameX - self.ball.x
    local dy = gameY - self.ball.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    -- Start dragging if mouse is over the ball and ball is not already in flight
    if distance <= self.ballRadius and not self.inFlight then
        self.dragging = true  -- Enter dragging state
        -- Initialize tracking variables for velocity calculation at release
        self.prevBallX = self.ball.x
        self.prevBallY = self.ball.y
        self.lastTime = love.timer.getTime()
        -- Initialize ball velocity to 0 when starting to drag
        self.ball.velocityX = 0
        self.ball.velocityY = 0
    end
end

function basketball:mousereleased(x, y, button)
    -- Handle mouse release events to throw the ball
    -- This function releases the ball with calculated velocity when the user lets go
    if not self.active then return end
    
    if self.dragging then
        self.dragging = false  -- Exit dragging state
        
        -- Use the current velocity of the ball at the moment of release
        -- The bungee physics have already been updating the velocity
        -- Apply a power factor to make the throw stronger
        local power = 1.5  -- Boost the velocity slightly for better throws
        self.ball.velocityX = self.ball.velocityX * power  -- Amplify horizontal velocity
        self.ball.velocityY = self.ball.velocityY * power  -- Amplify vertical velocity
        
        -- Add rotation based on the velocity for a realistic spin
        self.ball.rotationSpeed = (self.ball.velocityX * 0.03) - (self.ball.velocityY * 0.02)
        
        -- Now the ball is in flight with the preserved velocity
        self.inFlight = true  -- Enter flight state
        self.shots = self.shots + 1  -- Increment shot counter
    end
end

function basketball:mousemoved(x, y, dx, dy)
    -- Handle mouse movement events
    -- This function is called when the mouse moves, but dragging is handled in update
    if not self.active then return end
    -- Mouse movement is handled in the update function while dragging
    -- This keeps the physics calculations consistent with the main update loop
end

function basketball:draw(panelX, panelY, panelWidth, panelHeight)
    -- Render the basketball game scene
    -- This function draws all game elements including court, hoop, ball, and UI
    if not self.active then return end
    
    -- Store panel dimensions for scaling calculations
    self.panelX = panelX or 0  -- X position of the UI panel
    self.panelY = panelY or 0  -- Y position of the UI panel
    self.panelWidth = panelWidth or 800  -- Width of the UI panel
    self.panelHeight = panelHeight or 600  -- Height of the UI panel
    
    -- Calculate scale to fit court within panel, maintaining aspect ratio
    -- This ensures the court is properly sized regardless of panel dimensions
    local scaleX = self.panelWidth / self.courtWidth  -- Horizontal scale factor
    local scaleY = self.panelHeight / self.courtHeight  -- Vertical scale factor
    local scale = math.min(scaleX, scaleY) * 0.95  -- 95% to leave some margin around court
    
    -- Calculate position to center the court in the panel
    local offsetX = self.panelX + (self.panelWidth - (self.courtWidth * scale)) / 2  -- Horizontal offset to center
    local offsetY = self.panelY + (self.panelHeight - (self.courtHeight * scale)) / 2  -- Vertical offset to center
    
    -- Apply transformation to scale and position the court
    -- This creates a viewport that maps game coordinates to screen coordinates
    love.graphics.push()  -- Save current graphics state
    love.graphics.translate(offsetX, offsetY)  -- Move origin to offset position
    love.graphics.scale(scale, scale)  -- Scale everything by the calculated factor
    
    -- Draw court background
    love.graphics.setColor(0.2, 0.7, 0.2)  -- Green court color
    love.graphics.rectangle("fill", 0, 0, self.courtWidth, self.courtHeight)  -- Fill entire court area
    
    -- Draw court lines
    love.graphics.setColor(1, 1, 1)  -- White lines color
    love.graphics.setLineWidth(2 / scale)  -- Adjust line width for scaling
    love.graphics.rectangle("line", 0, 0, self.courtWidth, self.courtHeight)  -- Outline court
    
    -- Draw dashed line at 1/3 of court from the left (release line)
    -- This indicates where the ball will auto-release if dragged too far right
    local lineX = self.courtWidth / 3  -- Position of the auto-release line
    local dashLength = 15  -- Length of each dash
    local gapLength = 10  -- Gap between dashes
    love.graphics.setLineStyle("rough")  -- Use GPU-accelerated line style for performance
    -- Draw a limited number of dashes to reduce draw calls
    local dashCount = math.ceil(self.courtHeight / (dashLength + gapLength))  -- Number of dashes needed
    for i = 0, dashCount do
        local y = i * (dashLength + gapLength)  -- Vertical position of dash
        if y < self.courtHeight then
            love.graphics.line(lineX, y, lineX, math.min(y + dashLength, self.courtHeight))  -- Draw dash
        end
    end
    love.graphics.setLineStyle("smooth")  -- Reset to default line style
    
    -- Draw middle wall (from bottom halfway to top)
    -- This is an obstacle that the ball must navigate around
    local wallX = self.courtWidth / 2 - 5  -- Center minus half wall width
    local wallWidth = 10  -- Width of the wall
    local wallHeight = self.courtHeight / 2  -- Height (half the court)
    love.graphics.setColor(0.6, 0.6, 0.6)  -- Gray wall color
    love.graphics.rectangle("fill", wallX, self.courtHeight - wallHeight, wallWidth, wallHeight)  -- Draw wall
    -- Reset color to white for other elements
    love.graphics.setColor(1, 1, 1)
    
    -- Draw hoop rim using image from Hoops folder (for visual purposes only, no collision)
    -- This provides a visual representation of the hoop without affecting physics
    if self.hoopImage then
        -- Set filter to nearest neighbor to prevent blurriness when scaling
        -- This prevents the hoop texture from becoming blurry when scaled
        -- Using nearest neighbor preserves sharp edges which is ideal for the hoop texture
        self.hoopImage:setFilter("nearest", "nearest")
        
        -- Calculate scale to fit the hoop image to the hoop dimensions
        local imageWidth = self.hoopImage:getWidth()  -- Original image width
        local imageHeight = self.hoopImage:getHeight()  -- Original image height
        -- For 1:1 aspect ratio, use the same scale for both dimensions
        -- Scale based on the hoop width to match the effective width of the hoop
        local scale = self.hoop.width / imageWidth  -- Scale factor to match hoop width
        
        love.graphics.draw(self.hoopImage, 
                          self.hoop.x,  -- X position
                          self.hoop.y,  -- Y position
                          0,  -- rotation (no rotation)
                          scale,  -- x scale (width scaling)
                          scale)  -- y scale (height scaling, maintains 1:1 aspect ratio, scaled to match hoop width)
    end
    

    
    -- Draw basketball image
    -- This renders the ball with proper rotation and scaling
    if self.basketballImage then
        -- Set filter to nearest neighbor to prevent blurriness when scaling
        -- This prevents the basketball texture from becoming blurry when scaled
        -- Using nearest neighbor preserves sharp edges which is ideal for the basketball texture
        self.basketballImage:setFilter("nearest", "nearest")
        
        -- Calculate position to center the image on the ball position
        local imageWidth = self.basketballImage:getWidth()  -- Original image width
        local imageHeight = self.basketballImage:getHeight()  -- Original image height
        local scaleForRadius = (self.ballRadius * 2) / imageWidth  -- Scale based on ball radius
        
        love.graphics.draw(self.basketballImage, 
                          self.ball.x,  -- X position (center of ball)
                          self.ball.y,  -- Y position (center of ball)
                          self.ball.rotation,  -- Apply rotation
                          scaleForRadius,  -- x scale (based on ball radius)
                          scaleForRadius,  -- y scale (based on ball radius)
                          imageWidth/2,   -- origin x (center of image)
                          imageHeight/2)  -- origin y (center of image)
    end
    
    -- Draw collider visualization if debug mode is on
    -- This helps visualize collision boundaries for development/debugging
    local debugModule = require('source.debug')
    if debugModule.isEnabled() then
        love.graphics.setColor(1, 0, 0, 0.5)  -- Semi-transparent red for visibility
        love.graphics.setLineWidth(2)  -- Thicker lines for visibility
        
        -- Visualize left front collider
        local collisionWidth = 8  -- Width of collision box
        local collisionHeight = self.hoop.height * 0.8  -- Height of collision box
        local collisionY = self.hoop.y + (self.hoop.height - collisionHeight) / 2  -- Vertically centered
        local leftFrontColliderX = self.hoop.x - collisionWidth  -- Positioned to the left of hoop
        love.graphics.rectangle("line", leftFrontColliderX, collisionY, collisionWidth, collisionHeight)  -- Draw box
        
        -- Visualize right back collider
        local rightBackColliderX = self.hoop.x + self.hoop.width - collisionWidth  -- Positioned to the right of hoop
        love.graphics.rectangle("line", rightBackColliderX, collisionY, collisionWidth, collisionHeight)  -- Draw box
    end
    
    love.graphics.pop()  -- Restore previous graphics state
    
    -- Draw score in the original coordinate system
    -- This draws UI elements outside the transformed game space
    love.graphics.setColor(1, 1, 1)  -- White text color
    love.graphics.setFont(self.font16)  -- Set font for score
    love.graphics.print("Score: " .. self.score .. " / " .. self.shots, self.panelX + 10, self.panelY + 10)  -- Draw score
    
    -- Draw instructions
    love.graphics.print("Drag and release to shoot hoops!", self.panelX + 10, self.panelY + 30)  -- Draw instructions
    
    -- Draw tip under the instructions
    love.graphics.setColor(0.8, 0.8, 1, 1)  -- Light blue text color
    love.graphics.setFont(self.font14)  -- Set smaller font for tip
    love.graphics.print("Tip: extend the middle panel!", self.panelX + 10, self.panelY + 50)  -- Draw tip
end

return basketball