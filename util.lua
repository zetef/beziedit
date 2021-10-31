table_remove = function(t, elem)
    local j, n = 1, #t;

    for i=1,n do
        if (i ~= elem) then
            -- Move i's kept value to j's position, if it's not already there.
            if (i ~= j) then
                t[j] = t[i]
                t[i] = nil
            end
            j = j + 1 -- Increment position of where we'll place the next kept value.
        else
            t[i] = nil
        end
    end

    return t
end

inbound = function(x1, y1, x2, y2, offx, offy)
        return  (x1 >= x2 - offx) and (x1 <= x2 + offx) and
                (y1 >= y2 - offy) and (y1 <= y2 + offy)
end

comb = function(n, k)
	if k > n then return nil end
	if k > n/2 then k = n - k end       --   (n k) = (n n-k)

	local numer, denom = 1, 1
	for i = 1, k do
		numer = numer * ( n - i + 1 )
		denom = denom * i
	end
	return numer / denom
end

in_circle = function(theta)
	local phi = theta
	while phi >= math.pi do
		phi = phi - math.pi
	end
	return phi
end

limit = function(v, min, max)
	local s = v
	if s < min then
		s = min
	elseif s > max then
		s = max
	end
	return s
end

print_help = function()
	love.graphics.print("M1 - drag points", 0, 45)
	love.graphics.print("M2 - remove point", 0, 60)
	love.graphics.print("M3 - add point to end", 0, 75)
	love.graphics.print("Rotate mouse wheel to modify time of animation", 0, 90)
	love.graphics.print("'space' - start animation", 0, 105)
	love.graphics.print("'c' - clear bezier curve on screen", 0, 120)
	love.graphics.print("'n' - get a new screen", 0, 135)
	love.graphics.print("'q' - quit", 0, 150)
	love.graphics.print("'s' - screenshot", 0, 165)
end

draw_triangle = function(x, y, length, width , angle) -- position, length, width and angle
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.polygon('fill', -length/2, -width /2, -length/2, width /2, length/2, 0)
	love.graphics.pop()
end

vec_sum = function(V1, V2)
        return { V1[1] + V2[1], V1[2] + V2[2] }
end

vec_prod = function(V1, V2)
        return { V1[1]*V2[1], V1[2]*V2[2] }
end
