WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    smallFont = love.graphics.newFont('RetroGaming.ttf',8)

    scoreFont = love.graphics.newFont('RetroGaming.ttf',32)
    
    player1Score = 0
    player2Score = 0

  push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
      fullscree = false,
      vsync = true,
      resizable = false,
  })

player1Y=30
player2Y=VIRTUAL_HEIGHT-40

ballX= VIRTUAL_WIDTH/2-3
ballY=VIRTUAL_HEIGHT/2-3

ballDX= math.random(2) == 1 and -200 or 200
ballDY =math.random(-100,100)


gameState = 'start'

end

function love.update(dt)
    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then
        paddle1.dy= -PADDLE_SPEED
       
    elseif love.keyboard.isDown('s') then
        paddle1.dy= PADDLE_SPEED
    end

    if love.keyboard.isDown('up') then
        paddle2.dy= -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy= PADDLE_SPEED
    end

    if gameState == 'play' then
       ballX = ballX + ballDX * dt
       ballY = ballY + ballDY * dt  
    end

    if gameState=='score' then
        ballX = VIRTUAL_WIDTH/2-3
        ballY = VIRTUAL_HEIGHT/2-3
        gameState='start'
    end 

    if gameState =='reset' then
        
    end

    if ballY >= player1Y-5 and ballY<=player1Y+20 and ballX <= 10 then
        ballDX = - ballDX
    elseif ballY >= player2Y-5 and ballY<=player2Y+20 and ballX >=VIRTUAL_WIDTH-20 then
        ballDX = - ballDX
    end

    if ballY >= VIRTUAL_HEIGHT-5 or ballY <= 0 then
        ballDY = -ballDY
    end

    if ballX <=0 then 
        player2Score = player2Score + 1
        gameState='score'

    elseif ballX >=VIRTUAL_WIDTH then
        player1Score= player1Score+1
        gameState='score'
    end

end



function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key ==  'return' then 
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then 
            gameState = 'start'
            ballX= VIRTUAL_WIDTH/2-3
            ballY=VIRTUAL_HEIGHT/2-3

            ballDX= math.random(2) == 1 and -100 or 100
            ballDY =math.random(-50,50)
        end
    end
    if gameState == 'reset' then
        if key =="enter" then
            gameState = 'start'
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,45/255,52/255,255/255)

    love.graphics.rectangle('fill',ballX,ballY,6,6)
    love.graphics.rectangle('fill',5,player1Y,5,24)
    love.graphics.rectangle('fill',VIRTUAL_WIDTH-10,player2Y,5,24)
    love.graphics.setFont(smallFont)
    love.graphics.printf("Hello Pong!",
    0,
    20, 
    VIRTUAL_WIDTH,
    'center');

    if player2Score >= 10 then
        love.graphics.print("Player2 Won",VIRTUAL_HEIGHT/2-8,VIRTUAL_WIDTH/3)
        gameState='reset'
    elseif player1Score >= 10 then
        love.graphics.print("Player1 Won",VIRTUAL_HEIGHT/2-8,VIRTUAL_WIDTH/3)
        gameState='reset'
    end
  
    love.graphics.setFont(scoreFont)

    love.graphics.print(player1Score,VIRTUAL_WIDTH/2 - 50 , VIRTUAL_HEIGHT/5)
    love.graphics.print(player2Score,VIRTUAL_WIDTH/2 + 30 , VIRTUAL_HEIGHT/5)

    push:apply('end')

end