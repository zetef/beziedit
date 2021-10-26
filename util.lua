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

vec_sum = function(V1, V2)
        return { V1[1] + V2[1], V1[2] + V2[2] }
end

vec_prod = function(V1, V2)
        return { V1[1]*V2[1], V1[2]*V2[2] }
end
