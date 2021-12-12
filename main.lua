largura_tela = love.graphics.getWidth()
altura_tela = love.graphics.getHeight()

function love.load()
    Classe = require "classic"
    require "cenas/jogo"
    require "cenas/telaInicial"

    jogo = Jogo()
    telaInicial = TelaInicial()

    cenas = {
        jogo = jogo,
        telaInicial = telaInicial
    }
    cenaAtual = "telaInicial"
end

function love.update(dt)
    cenas[cenaAtual]:update(dt)
end

function love.draw()
    cenas[cenaAtual]:draw()
end
