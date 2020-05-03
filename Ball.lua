Ball = Class{}

speedx=0
speedy=0

function Ball:init(x,y,width,height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height

    self.dx=math.random(2) == 1 and -100 or 100
    self.dy=math.random(-50,50)
end

function Ball:reset()
    self.x=VIRTUAL_WIDTH/2-3
    self.y=VIRTUAL_HEIGHT/2-3
    self.dx=math.random(2) == 1 and -100 or 100
    self.dy=math.random(-50,50)
end

function Ball:pause()
    speedx=self.dx
    speedy=self.dy
    self.dx=0
    self.dy=0 
end

function Ball:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end
    if self.y > box.y + box.height or self.y + self.height < box.y then 
        return false
    end
    return true
end

function Ball:resume()
    self.dx=speedx
    self.dy=speedy
end

function Ball:update(dt)
    self.x=self.x + self.dx*dt
    self.y=self.y + self.dy*dt
end

function Ball:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end