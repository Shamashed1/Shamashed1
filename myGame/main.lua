function love.load()

    volume=0.070

    wf = require 'libraries/windfield'
    world = wf.newWorld (0, 0)

    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/testmap..lua')

    player = {}
    player.collider = world:newBSGRectangleCollider(400, 250, 50, 100, 10)
    player.collider:setFixedRotation(true)
    player.x = 400
    player.y = 200
    player.speed = 300
    player.sprite =love.graphics.newImage('sprites/parrot.png')
    player.spriteSheet =love.graphics.newImage('sprites/pixil-frame-0 (1).png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(),  player.spriteSheet:getHeight() )

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.left

    background = love.graphics.newImage('sprites/background.png')

    sounds = {}
    sounds.backroundmusic = love.audio.newSource("sounds/backround music.mp3", "stream")
    sounds.backroundmusic:setLooping(true)

    sounds.backroundmusic:play()

    walls = {}
    if gameMap.layers["Walls"] then
        for i, obj in pairs(gameMap.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

function love.update(dt)
    
    local isMoving = false
    local vy = 0
    local vx = 0

   -- print(volume)

    if volume < 0 then
        volume = 0
    end

    if volume > 0.2 then
        volume = 0.2
    end

    if love.keyboard.isDown("right") then
    vx = player.speed
    player.anim = player.animations.right
    isMoving = true
    end

    if love.keyboard.isDown("left") then
    vx = player.speed * -1
    player.anim = player.animations.left
    isMoving = true
    end

    if love.keyboard.isDown("down") then
    vy = player.speed
    player.anim = player.animations.down
    isMoving = true
    end
    
    if love.keyboard.isDown("up") then
    vy = player.speed * -1
    player.anim = player.animations.up
    isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.collider:setLinearVelocity(vx, vy)

    sounds.backroundmusic:setVolume(volume)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)
    
    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then
        cam.x = w/2
    end

    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW- w/2) then
        cam.x = (mapW- w/2)
    end

    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        player.anim:draw(player.spriteSheet,player.x, player.y, nil, 6, nil, 6, 9)
        gameMap:drawLayer(gameMap.layers["Trees"])
        --world:draw()
    cam:detach()
end

function love.keypressed(key)
    if key == "n" then
        sounds.backroundmusic:stop()
    end
    
    if key == "m" then
        sounds.backroundmusic:setLooping(true)
        sounds.backroundmusic:play()
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    if key == "v" then
        volume = volume - 0.01
    end
    
    if key == "b" then
        print("increae")
        volume = volume + 0.01
    end
    
end

--enemy sprite
--
--
--
--
--sword
--damadge/hearts
--loot
--puase menu
--veriey of wepons
--veriey of loot/coin