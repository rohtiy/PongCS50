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
    smallFont = love.graphics.newFont('font.ttf',8)

    scoreFont = love.graphics.newFont('font.ttf',32)

    player1Score = 0
    player2Score = 0

    servingPlayer =  math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = true,
    })

    love.window.setTitle("Pong")

    paddle1 = Paddle(5,20,5,20)
    paddle2 = Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)
    ball = Ball(VIRTUAL_WIDTH/2-3,VIRTUAL_HEIGHT/2-3,6,6)

    paddle_sound = love.audio.newSource('sound/paddle.wav','static')
    score_sound = love.audio.newSource('sound/score.wav','static')
    wall_hit_sound = love.audio.newSource('sound/wall_hit.wav','static')
    gameStart_sound = love.audio.newSource('sound/game_start.wav','static')
    gameWining_sound = love.audio.newSource('sound/game_won.wav','static')
 
    if servingPlayer== 1 then
        ball.dx = -100
    elseif servingPlayer==2 then
        ball.dx = 100
    end

    gameState = 'start'

end

function love.update(dt)
        

    if gameState == 'play' then
    
        paddle1:update(dt)
        paddle2:update(dt)
        ball:update(dt)

       
        

        if ball.x<0 then 
            love.audio.play(score_sound)
            player2Score = player2Score + 1
            if player2Score == 10 then
            winningPlayer = 2
            gameState = 'won'
            else
                ball:reset()
                servingPlayer = 1
                ball.dx= 100
                gameState = 'serve'
            end
        end

        if ball.x>VIRTUAL_WIDTH then
            love.audio.play(score_sound)
            player1Score = player1Score + 1
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'won'
            else
                ball:reset()
                servingPlayer = 2
                ball.dx= - 100
                gameState = 'serve'
            end
        end


        if ball:collides(paddle1) then
            love.audio.play(paddle_sound)
            ball.dx=-ball.dx
        end

        if ball:collides(paddle2) then
            love.audio.play(paddle_sound)
            ball.dx=-ball.dx
        end

        if ball.y<=0 then
            love.audio.play(wall_hit_sound)
            ball.dy=-ball.dy
            ball.y=0
        end

        if ball.y>=VIRTUAL_HEIGHT-6 then
            love.audio.play(wall_hit_sound)
            ball.dy=-ball.dy
            ball.y=VIRTUAL_HEIGHT-6
        end



        if love.keyboard.isDown('w') then
            paddle1.dy= -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            paddle1.dy= PADDLE_SPEED
        else
            paddle1.dy = 0
        end


        if love.keyboard.isDown('up') then
            paddle2.dy= -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy= PADDLE_SPEED
        else 
            paddle2.dy = 0
        end
        
    end

end

function love.resize(w,h)
    push:resize(w,h)
end



function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key ==  'return' then 
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState== 'serve' then 
            gameState = 'play'
        elseif gameState == 'won' then
            player1Score = 0
            player2Score = 0
            gameState = 'start'
        end 
    elseif key == 'z' then 
        ball.dx=ball.dx*2
        ball.dy=ball.dy*2
    elseif key == 'c' then
        ball.dx=ball.dx/2
        ball.dy=ball.dy/2
   elseif key == 'space' then
        if gameState == 'play' then
            gameState = 'pause'
            ball:pause()
        elseif gameState == 'pause' then
            gameState='play'
            ball:resume()
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,45/255,52/255,255/255)
    paddle1:render()
    paddle2:render()
    ball:render()

    love.graphics.setFont(smallFont)
    if gameState =="start" then
        love.graphics.printf("Hello Pong!",0,20, VIRTUAL_WIDTH,'center');
        love.graphics.printf("Press Enter to start the game",0,32,VIRTUAL_WIDTH,'center')
        love.audio.play(gameStart_sound);
    elseif gameState == 'serve' then
        love.graphics.printf('Player' .. tostring(servingPlayer) .."'s turn",0,20,VIRTUAL_WIDTH,'center')
        love.graphics.printf("Press Enter to serve",0,32,VIRTUAL_WIDTH,'center')
    elseif gameState == 'won' then 
        love.audio.play(gameWining_sound)
        love.graphics.printf('Player' .. tostring(winningPlayer) .." won",0,20,VIRTUAL_WIDTH,'center')
        love.graphics.printf("Press Enter to restart game",0,32,VIRTUAL_WIDTH,'center')
    end
   

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score,VIRTUAL_WIDTH/2 - 50 , VIRTUAL_HEIGHT/5)
    love.graphics.print(player2Score,VIRTUAL_WIDTH/2 + 30 , VIRTUAL_HEIGHT/5)

    displayFPS()

    push:apply('end')

end

function displayFPS()
    love.graphics.setColor(0,1,0,1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: '.. tostring(love.timer.getFPS()),40,20)
    love.graphics.setColor(1,1,1,1)
end