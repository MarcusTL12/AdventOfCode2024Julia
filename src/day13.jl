
function part1()
    inp = read("$(homedir())/aoc-input/2024/day13/input", String)

    reg = r"""Button A: X\+(\d+), Y\+(\d+)
Button B: X\+(\d+), Y\+(\d+)
Prize: X=(\d+), Y=(\d+)"""

    s = 0

    for m in eachmatch(reg, inp)
        A = reshape(parse.(Int, m.captures[1:4]), 2, 2)
        b = parse.(Int, m.captures[5:6])

        x1, x2 = A\b

        x1_int = round(Int, x1)
        x2_int = round(Int, x2)

        if abs(x1 - x1_int) < 1e-10 && abs(x2 - x2_int) < 1e-10
            s += 3x1_int + x2_int
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
        A = reshape(parse.(BigInt, m.captures[1:4]), 2, 2)
        b = parse.(BigInt, m.captures[5:6]) .+ 10000000000000

        x1, x2 = A\b

        x1_int = round(Int, x1)
        x2_int = round(Int, x2)

        if abs(x1 - x1_int) < 1e-10 && abs(x2 - x2_int) < 1e-10
            s += 3x1_int + x2_int
        end
    end

    s
end

