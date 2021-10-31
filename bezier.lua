require("util")

lerp = function(P1, P2, t)
        return vec_sum( vec_prod(P1, {1-t, 1-t}), vec_prod(P2, {t, t}) )
end

bezier_point = function(points, t)
        -- abandon  ecursion altogether
        s = {[1] = 0, [2] = 0}
        n = #points
        for i = 0, n-1 do
                c = comb(n, i) * (1-t)^(n-i) * t^i
                s = vec_sum(s, vec_prod({c, c}, points[i+1]))
        end
        c = comb(n, n) * (1-t)^(n-n) * t^n
        s = vec_sum(s, vec_prod({c,c}, points[n]))
        return s
end
