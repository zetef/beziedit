require("util")
require("bezier")

pnts = {}
bcurve = {}
sec = 3 				-- seconds to animate (default)
help = false
offx, offy = 8, 8 			-- bounding box for points

love.load = function()
	touch = 0 			-- grabbed a point
	start = false			-- started animation
	mag = 0 			-- magnitude of triangle
	d   = 0				-- the derivate at the last point
	dd  = 0				-- the acceleration
	phi = 0				-- angle of arrow
	t = 0				-- bezier t variable
	r = 1 / sec 			-- rate at which to animate (1 segment per seconds)
	name = {text = "", a = 1} 	-- name for screenshot
end

love.update = function(dt)
	if t * sec <= sec and start then
		t = t + r * dt 
		P = bezier_point(pnts, t)
		table.insert(bcurve, {P[1], P[2]})
		if #bcurve > 1 then
			n = #bcurve
			dx = bcurve[n][1] - bcurve[n-1][1]
			dy = bcurve[n][2] - bcurve[n-1][2]
			if dx == 0 then
				print("Slope: vertical")
			else
				print("Slope: " .. dy/dx)
				d = dy/dx			-- stupid inverse coordonate system
			end
			dd = math.abs(dy/dt)/1000
			print("Acceleration: " .. dd)
			phi = math.atan(d)
			dy = -dy
			-- this failsafe fixes a bug
			-- that switched the orientation
			-- of the arrow because of small
			-- values of dy
			if (dy < dt and dy > 0) or (dy > -dt and dy < 0) then
				dy = 0
			end
			if dy > 0 then
				down = false
			elseif dy < 0 then
				down = true
			end
			if phi < 0 and down then
				phi = math.pi + phi
			end
			if phi >= 0 and phi < math.pi/2 and not down then
				phi = math.pi + phi
			end
			print("Radians: " .. phi)
			print("Down: " .. tostring(down))
			print()
		end
	end

	if name.text ~= "" then				-- the alpha of screenshot filename
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
	for i = 1, #pnts - 1 do				-- draw line between points
		love.graphics.line(pnts[i][1], pnts[i][2], 
				   pnts[i+1][1], pnts[i+1][2])
	end
	love.graphics.setColor(1, 1, 1)
	for i, v in ipairs(pnts) do			-- draw points
		love.graphics.points(v[1], v[2])
		love.graphics.circle("fill", v[1], v[2], 3)
		love.graphics.print(i, v[1] - 20, v[2] - 20)
	end

	love.graphics.points(bcurve)

	if bcurve ~= nil and #bcurve > 1 then		-- draw triangle
		n = #bcurve
		M = { (bcurve[n][1]+bcurve[n-1][1])/2, 
		      (bcurve[n][2]+bcurve[n-1][2])/2 }
		c = (dd * 1.5 + 0.8)
		w = 7.5 * c
		l = w * 3 * c 
		love.graphics.setColor(dd * 4, 1 - dd * 4, 0)
		draw_triangle(M[1], M[2], l, w, phi)
	end
	love.graphics.setColor(1, 1, 1)

	love.graphics.print("Seconds of drawing " .. sec, 0, 0)
	love.graphics.print("Finished: " .. math.floor((t * sec) / sec * 100) .. "%", 0, 15)

	if help then					-- draw help
		print_help()
		if touch == 0 then
			love.graphics.print("No point is being dragged", 0, 30)
		else
			love.graphics.print("Point no. " .. touch .. " is being dragged", 0, 30)
		end
	else
		love.graphics.print("F1 - help", 0, 30)
	end

	if name.text ~= "" then				-- draw screenshot filename
		love.graphics.setColor(1, 1, 1, name.a)
		love.graphics.print(name.text .. " just saved in love save directory!", 0, 600-15)
	end
end

love.quit = function()
	print("Thanks for experimenting!")
	print("Points drawn: " .. #bcurve)
end

love.keypressed = function(key, code, isrepeat)
	if key == "space" and #pnts ~= 0 then		-- start animation
		start = not start 
	elseif key == "n" then				-- new points
		pnts = {}
		bcurve = {}
		love.load()
	elseif key == "q" then				-- quit game
		love.event.quit()
	elseif key == "c" then				-- clear bezier curve
		bcurve = {}
		love.load()
	elseif key == "s" then				-- save screenshot
		name.text = "order" .. #pnts .. "_" .. os.time() .. ".png"
		love.graphics.captureScreenshot(name.text)
	elseif key == "f1" then				-- show help
		help = not help
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
				bcurve = {}
				love.load()
			end
		end
	end
	if button == 3 then				-- middle click, insert point at tail
		table.insert(pnts, {[1] = x, [2] = y,
 			     pressed = false})
		bcurve = {}
		love.load()
	end
	

end

love.mousereleased = function(x, y, button)
	if touch ~= 0 and button == 1 then
		pnts[touch].pressed = false
		touch = 0
	end
end

love.wheelmoved = function(dx, dy)
	if sec + dy > 0 and (not start) then		-- change number of seconds of animation
		sec = sec + dy
		r = 1 / sec
	end
end
