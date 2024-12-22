
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

    possible_seq = Set{Vector{Int8}}()

    for j in 1:n_lines
        for i in 1:2000-4
            push!(possible_seq, dp[i:i+3, j])
        end
    end

    best = Threads.Atomic{Int}(0)

    all_to_test = collect(possible_seq)

    Threads.@threads for seq in all_to_test
        Threads.atomic_max!(best, find_for_seq(seq, prices, dp))
    end

    best
end
