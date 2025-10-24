local assets = {}

assets.images = {}
assets.videos = {}

function assets.load()
    assets.images.startupDog = love.graphics.newImage('assets/startup_dog.png')
    assets.images.settingsIcon = love.graphics.newImage('assets/settings.png')
    assets.images.checkboxEnabled = love.graphics.newImage('assets/checkbox_enabled.png')
    assets.images.checkboxDisabled = love.graphics.newImage('assets/checkbox_disabled.png')
    assets.images.closeButton = love.graphics.newImage('assets/close_button.png')
    assets.images.linktree = love.graphics.newImage('assets/Linktree.png')
end

function assets.loadIntroVideo()
    assets.videos.intro = love.graphics.newVideo('assets/intro.ogv')
    assets.videos.intro:play()
    return assets.videos.intro
end

function assets.cleanup()
    for _, img in pairs(assets.images) do
        if img then img:release() end
    end
    for _, vid in pairs(assets.videos) do
        if vid then vid:release() end
    end
end

return assets