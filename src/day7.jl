
function could_be_true(target, acc, rest)
    if isempty(rest)
        return acc == target
    end

    if acc * rest[1] <= target
        if could_be_true(target, acc * rest[1], rest[2:end])
            return true
        end
    end

    could_be_true(target, acc + rest[1], rest[2:end])
end

function part1()
    s = 0

    for l in eachline("$(homedir())/aoc-input/2024/day7/input")
        a, rest = eachsplit(l, ": ")
        v = parse.(Int, split(rest))

        target = parse(Int, a)

        if could_be_true(target, v[1], v[2:end])
            s += target
        end
    end

    s
end

conc(a, b) = a * 10^ndigits(b) + b

function could_be_true2(target, acc, rest)
    if isempty(rest)
        return acc == target
    end

    if acc * rest[1] <= target
        if could_be_true2(target, acc * rest[1], rest[2:end])
            return true
        end
    end

    if acc + rest[1] <= target
        if could_be_true2(target, acc + rest[1], rest[2:end])
            return true
        end
    end

    return could_be_true2(target, conc(acc, rest[1]), rest[2:end])
end

function part2()
    s = 0

    for l in eachline("$(homedir())/aoc-input/2024/day7/input")
        a, rest = eachsplit(l, ": ")
        v = parse.(Int, split(rest))

        target = parse(Int, a)

        if could_be_true2(target, v[1], v[2:end])
            s += target
        end
    end

    s
end
