function love.load()
    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")
    --para não ficar desfocado

    sti = require 'libraries/sti'
    mapas = sti('mapas/test.lua')
    --para importar mapa (feito no Tiled nesse caso)

    player = {}
    player.x = 380
    player.y = 230
    player.speed = 5
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight()) 
    --cada quadro (da imagem de sprites do movimento do personagem) para animação do personagem é 12 por 18
    
    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    --quadros de 1-4 colunas, começando da 1° linha a cada 0.2s
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.down

    background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        --locomoção pelas setinhas
        player.anim = player.animations.right
        --animação
        isMoving = true
        --para a animação não funcionar quando ele estiver parado
    end
    
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end
    --mudar para o quadro em que ele está parado (no caso é o quadro 2)

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)
end

function love.draw()
    cam:attach()
        mapas:drawLayer(mapas.layers["terra"])
        mapas:drawLayer(mapas.layers["arvores"])
        --para cada camada do terreno feito no Tiled
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
        --nil para não mudar a rotação e o sx
        --ox=6 oy=9 (metade da largura e altura do personagem)
    cam:detach()
end