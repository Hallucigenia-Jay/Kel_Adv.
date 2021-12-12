GameOver = Classe:extend()

function GameOver:new()
    self.imagem = love.graphics.newImage("sprites/game_over.png")
end

function GameOver:update(dt)
    if love.keyboard.isDown("space") then
        cenaAtual = "telaInicial"
    end
end

function GameOver:draw()
    love.graphics.draw(self.imagem)
    love.graphics.print("Aperte espaço para voltar ao menu", 300, altura_tela/2)
end
