require("util")
require("bezier")

pnts = {}
bcurve = {}

love.load = function()
	touch = 0 
	start = false
	t = 0
	sec = 3 -- seconds to animate
	r = 1 / sec -- rate at which to animate (1 segment per seconds)

	offx, offy = 8, 8 -- bounding box for points

	name = {text = "", a = 1} -- name for screenshot
end

love.update = function(dt)
	if t * sec <= sec and start then
		t = t + r * dt 
		P = bezier_point(pnts, t, "bezier")
		table.insert(bcurve, {P[1], P[2]})
	end

	if name.text ~= "" then
		if name.a - dt >= 0 then
			name.a = name.a - dt
		else
			name.text = "" 
			name.a = 1
		end
	end
end

love.draw = function() 
	love.graphics.setColor(0.2, 0.2, 0.2)
	for i = 1, #pnts - 1 do
		love.graphics.line(pnts[i][1], pnts[i][2], pnts[i+1][1], pnts[i+1][2])
	end
	love.graphics.setColor(1, 1, 1)
	for i, v in ipairs(pnts) do
		love.graphics.points(v[1], v[2])
		love.graphics.circle("fill", v[1], v[2], 3)
		love.graphics.print(i, v[1] - 20, v[2] - 20)
	end
	love.graphics.points(bcurve)

	if touch == 0 then
		love.graphics.print("No point is being dragged", 0, 30)
	else

		love.graphics.print("Point no. " .. touch .. " is being dragged", 0, 30)
	end

	love.graphics.print("Seconds of drawing " .. sec, 0, 0)
	love.graphics.print("finished: " .. math.floor((t * sec) / sec * 100) .. "%", 0, 15)
	love.graphics.print("Left click to drag points", 0, 45)
	love.graphics.print("Right click to remove point", 0, 60)
	love.graphics.print("Middle click to add point to end", 0, 75)
	love.graphics.print("Press 'space' to start animation", 0, 90)
	love.graphics.print("Press 'c' to clear bezier curve on screen", 0, 105)
	love.graphics.print("Press 'n' to get a new screen", 0, 120)
	love.graphics.print("Press 'q' to quit", 0, 135)
	love.graphics.print("Press 's' to screenshot", 0, 150)
	love.graphics.print("Rotate mouse wheel to modify time of animation", 0, 165)

	if name.text ~= "" then
		love.graphics.setColor(1, 1, 1, name.a)
		love.graphics.print(name.text .. " just saved in love save directory!", 0, 180)
	end
end

love.quit = function()
	print("Thanks for experimenting!")
end

love.keypressed = function(key, code, isrepeat)
	if key == "space" and #pnts ~= 0 then
		start = not start 
	elseif key == "n" then
		pnts = {}
		bcurve = {}
		love.load()
	elseif key == "q" then
		love.event.quit()
	elseif key == "c" then
		bcurve = {}
		love.load()
	elseif key == "s" then
		name.text = "order" .. #pnts .. "_" .. os.time() .. ".png"
		love.graphics.captureScreenshot(name.text)
	end
end

love.mousemoved = function(x, y, dx, dy)
	if touch ~= 0 and (not start) then
		pnts[touch][1] = pnts[touch][1] + dx
		pnts[touch][2] = pnts[touch][2] + dy
	end
end

love.mousepressed = function(x, y, button)
	for i, v in ipairs(pnts) do
		if inbound(x, y, v[1], v[2], offx, offy) then
			if button == 1 then 		-- left click, grab n drag
				v.pressed = true
				touch = i
			elseif button == 2 then 	-- right click, remove point
				table_remove(pnts, i)
			end
		end
	end
	if button == 3 then				-- middle click, insert point at tail
		table.insert(pnts, {[1] = x, [2] = y,
 			     pressed = false})
	end

end

love.mousereleased = function(x, y, button)
	if touch ~= 0 and button == 1 then
		pnts[touch].pressed = false
		touch = 0
	end
end

love.wheelmoved = function(dx, dy)
	if sec + dy > 0 and (not start) then
		sec = sec + dy
		r = 1 / sec
	end
end
