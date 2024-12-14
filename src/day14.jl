using Images
using Printf

function part1()
    reg = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"

    inp = read("$(homedir())/aoc-input/2024/day14/input", String)

    w = 101
    h = 103
    # w, h = 11, 7

    mat = zeros(Int, h, w)

    for m in eachmatch(reg, inp)
        x, y, vx, vy = parse.(Int, m.captures)

        px = (x + 100 * vx) % w
        py = (y + 100 * vy) % h

        if px < 0
            px += w
        end
        if py < 0
            py += h
        end

        mat[py+1, px+1] += 1
    end

    # display(mat')

    c1 = sum(mat[1:h÷2, 1:w÷2])
    c2 = sum(mat[h÷2+2:end, 1:w÷2])
    c3 = sum(mat[1:h÷2, w÷2+2:end])
    c4 = sum(mat[h÷2+2:end, w÷2+2:end])

    @show c1, c2, c3, c4

    c1 * c2 * c3 * c4
end

function part2()
    reg = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"

    inp = read("$(homedir())/aoc-input/2024/day14/input", String)

    w = 101
    h = 103
    # w, h = 11, 7

    particles = NTuple{2,NTuple{2,Int}}[]

    for m in eachmatch(reg, inp)
        x, y, vx, vy = parse.(Int, m.captures)

        push!(particles, ((x, y), (vx, vy)))
    end

    seen = Set{Matrix{Int}}()

    for t in 0:10403
        mat = zeros(Int, h, w)
        for ((x, y), (vx, vy)) in particles
            px = (x + t * vx) % w
            py = (y + t * vy) % h

            if px < 0
                px += w
            end
            if py < 0
                py += h
            end

            mat[py+1, px+1] += 1
        end

        if mat ∈ seen
            @show t
            break
        end

        push!(seen, mat)

        tstr = @sprintf "%04d" t

        save("$(homedir())/tmp/frames/frame$tstr.png", Gray.((mat .!= 0) ./ 1))
    end
end
