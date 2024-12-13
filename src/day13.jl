
function part1()
    inp = read("$(homedir())/aoc-input/2024/day13/input", String)

    reg = r"""Button A: X\+(\d+), Y\+(\d+)
Button B: X\+(\d+), Y\+(\d+)
Prize: X=(\d+), Y=(\d+)"""

    s = 0

    for m in eachmatch(reg, inp)
        A = Rational.(reshape(parse.(Int, m.captures[1:4]), 2, 2))
        b = Rational.(parse.(Int, m.captures[5:6]))

        x1, x2 = A \ b

        if isinteger(x1) && isinteger(x2)
            s += 3Int(x1) + Int(x2)
        end
    end

    s
end

function part2()
    inp = read("$(homedir())/aoc-input/2024/day13/input", String)

    reg = r"""Button A: X\+(\d+), Y\+(\d+)
Button B: X\+(\d+), Y\+(\d+)
Prize: X=(\d+), Y=(\d+)"""

    s = 0

    for m in eachmatch(reg, inp)
        A = Rational.(reshape(parse.(Int, m.captures[1:4]), 2, 2))
        b = Rational.(parse.(Int, m.captures[5:6])) .+ 10000000000000

        x1, x2 = A \ b

        if isinteger(x1) && isinteger(x2)
            s += 3Int(x1) + Int(x2)
        end
    end

    s
end
