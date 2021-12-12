TelaInicial = Classe:extend()

function TelaInicial:new()
    self.imagem = love.graphics.newImage("sprites/tela_inicial.png")
    self.opcoes = {"Jogar", "Sair"}

    self.iconeSelecao = love.graphics.newImage("sprites/pinto.png")
    self.x = largura_tela/2 - 220
    self.y = altura_tela/2 + 60

    self.escolha = 1    -- 1=Jogar 2=Sair
    self.tempoOpcao = 0
end

function TelaInicial:update(dt)
    self.tempoOpcao = self.tempoOpcao + dt

    if love.keyboard.isDown("up", "down") and self.tempoOpcao > 0.5 then
        self.tempoOpcao = 0
        if self.y == altura_tela/2 + 60 then
            self.y = altura_tela/2 + 100
            self.escolha = 2  --sair
        elseif self.y == altura_tela/2 + 100 then
            self.y = altura_tela/2 + 60
            self.escolha = 1  --jogar
        end
    end

    if love.keyboard.isDown("space") and self.tempoOpcao > 0.5 then
        self.tempoOpcao = 0
        if self.escolha == 1 then
            cenaAtual = "jogo"
            jogo:new()
        elseif self.escolha == 2 then
            love.event.quit()
        end
    end

end

function TelaInicial:draw()
    love.graphics.draw(self.imagem)
    
    for i=1, #self.opcoes do
        love.graphics.print(self.opcoes[i], largura_tela/2 - 200, altura_tela/2 + 50*i, 0, 2)
    end

    love.graphics.draw(self.iconeSelecao, self.x, self.y, 1.5, 0.3)
end
