
function evolve(secret)
    secret = ((secret * 64) ⊻ secret) % 16777216
    secret = ((secret ÷ 32) ⊻ secret) % 16777216
    secret = ((secret * 2048) ⊻ secret) % 16777216
end

function part1()
    s = 0

    for l in eachline("$(homedir())/aoc-input/2024/day22/input")
        secret = parse(Int, l)

        for _ in 1:2000
            secret = evolve(secret)
        end

        s += secret
    end

    s
end

function find_for_seq(seq, p, dp)
    s = 0

    for j in axes(p, 2)
        r = findfirst(seq, (@view dp[:, j]))

        if !isnothing(r)
            s += p[r[end]+1, j]
        end
    end

    s
end

function part2()
    prices = Int8[]

    n_lines = 0

    for l in eachline("$(homedir())/aoc-input/2024/day22/input")
        secret = parse(Int, l)

        n_lines += 1

        push!(prices, secret % 10)

        for _ in 1:2000
            secret = evolve(secret)
            push!(prices, secret % 10)
        end
    end

    prices = reshape(prices, 2001, n_lines)

    dp = [prices[i+1, j] - prices[i, j] for i in 1:2000, j in 1:n_lines]

    typeof(dp)

    best = Threads.Atomic{Int}(0)

    all_to_test = [Int8[a, b, c, d]
                   for a in -9:9, b in -9:9, c in -9:9, d in -9:9]

    Threads.@threads for seq in all_to_test
        Threads.atomic_max!(best, find_for_seq(seq, prices, dp))
    end

    best
end
