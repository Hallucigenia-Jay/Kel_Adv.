Jogo = Classe:extend()

function Jogo:new()
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0)
    -- 0 pois não tem gravidade

    --monstros = love.graphics.newImage('sprites/monstros.png')

    camera = require 'libraries/camera'
    cam = camera()
    anim8 = require 'libraries/anim8'

    love.graphics.setDefaultFilter("nearest", "nearest")
    --para não ficar desfocado
    
    sti = require 'libraries/sti'
    gameMap = sti('mapas/Fase01/testMap.lua')
    --para importar mapa (feito no Tiled nesse caso)

    bulletSpeed = 250
	bullets = {}

    player = {}
    player.width = 15
    player.height = 15
    player.collider = world:newBSGRectangleCollider(325, 200, 50, 100, 10)
    -- x, y, largura, altura, curvatura dos cantos
    player.collider:setFixedRotation(true)
    player.x = 325
    player.y = 200
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('sprites/kel.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight()) 
    --cada quadro (da imagem de sprites do movimento do personagem) para animação do personagem é 12 por 18

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    --quadros de 1-4 colunas, começando da 1° linha a cada 0.2s
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)
    player.anim = player.animations.down

    walls = {}
    if gameMap.layers["colisão"]then
        for i, obj in pairs(gameMap.layers["colisão"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            --para que os objetos n se desloquem quando interajir com o personagem
            table.insert(walls, wall)
        end
    end
end

function Jogo:update(dt)
    local isMoving = false

    local vx = 0
    local vy = 0
    -- significa que é velocidade 0 pra direção da colisão

    if love.keyboard.isDown("right") then
        vx = player.speed
        --player.x = player.x + player.speed
        player.anim = player.animations.right
        --animação
        isMoving = true
        --para a animação não funcionar quando ele estiver parado
    end
    
    if love.keyboard.isDown("left") then
        vx = player.speed * -1
        --player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        vy = player.speed
        --player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        vy = player.speed * -1
        --player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        player.anim:gotoFrame(2)
    end
    --mudar para o quadro em que ele está parado (no caso é o quadro 2)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)

    for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
	end

    --[[
    for k,v in ipairs(bullets) do
		local a = math.getAngle(v.x, v.y, player.x, player.y)
		v.x = v.x + math.cos(a) * v.speed * dt
		v.y = v.y + math.sin(a) * v.speed * dt
	end
    ]]

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    if cam.x < w/2 then
        cam.x = w/2
    end
    if cam.y < h/2 then
        cam.y = h/2
    end
end

function Jogo:draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["terreno"])
        gameMap:drawLayer(gameMap.layers["arvores"])
        gameMap:drawLayer(gameMap.layers["casas"]) 
        --para cada camada do terreno feito no Tiled
        
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
        --nil para não mudar a rotação e o sx
        --ox=6 oy=9 (metade da largura e altura do personagem)

        --world:draw() --é apenas para ver o contorno das colisões

        for i,v in ipairs(bullets) do
            love.graphics.circle("fill", v.x, v.y, 3)
        end

    cam:detach()

    --love.graphics.draw(monstros, 0, 0)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local startX = player.x + player.width / 2
        local startY = player.y + player.height / 2
        local mouseX = x
        local mouseY = y
        
        local angle = math.atan2((mouseY - startY), (mouseX - startX))
        
        local bulletDx = bulletSpeed * math.cos(angle)
        local bulletDy = bulletSpeed * math.sin(angle)
        local bulletCam = bulletSpeed 
        
        table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
    end
end
