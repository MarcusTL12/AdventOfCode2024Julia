
function part1()
    reg = r"""Register A: (\d+)
Register B: 0
Register C: 0

Program: (.+)"""

    inp = read("$(homedir())/aoc-input/2024/day17/input", String)

    m = match(reg, inp)

    a = parse(Int, m.captures[1])
    # a = 37222273957364
    b, c = 0, 0

    ip = 1

    program = parse.(Int, eachsplit(m.captures[2], ','))

    function eval_combo(i)
        x = program[i]
        if 0 <= x <= 3
            x
        elseif x == 4
            a
        elseif x == 5
            b
        elseif x == 6
            c
        else
            error("!!!")
        end
    end

    out_buf = Int[]

    while ip <= length(program)
        opcode = program[ip]

        if opcode == 0
            d = eval_combo(ip + 1)
            a >>= d
            ip += 2
        elseif opcode == 1
            b ⊻= program[ip+1]
            ip += 2
        elseif opcode == 2
            x = eval_combo(ip + 1)
            b = x % 8
            ip += 2
        elseif opcode == 3
            if a != 0
                ip = program[ip+1] + 1
            else
                ip += 2
            end
        elseif opcode == 4
            b ⊻= c
            ip += 2
        elseif opcode == 5
            push!(out_buf, eval_combo(ip + 1) % 8)
            ip += 2
        elseif opcode == 6
            d = eval_combo(ip + 1)
            b = a >> d
            ip += 2
        elseif opcode == 7
            d = eval_combo(ip + 1)
            c = a >> d
            ip += 2
        end
    end

    join(out_buf, ",")
end

function eval_combo(i, a, b, c, program)
    x = program[i]
    if 0 <= x <= 3
        x
    elseif x == 4
        a
    elseif x == 5
        b
    elseif x == 6
        c
    else
        0
    end
end

function checka(a, program)
    out_n = 1

    b, c = 0, 0
    ip = 1

    while ip <= length(program)
        opcode = program[ip]

        if opcode == 0
            d = eval_combo(ip + 1, a, b, c, program)
            a >>= d
            ip += 2
        elseif opcode == 1
            b ⊻= program[ip+1]
            ip += 2
        elseif opcode == 2
            x = eval_combo(ip + 1, a, b, c, program)
            b = x % 8
            ip += 2
        elseif opcode == 3
            if a != 0
                ip = program[ip+1] + 1
            else
                ip += 2
            end
        elseif opcode == 4
            b ⊻= c
            ip += 2
        elseif opcode == 5
            if out_n > length(program)
                return 0
            end
            if eval_combo(ip + 1, a, b, c, program) % 8 == program[out_n]
                out_n += 1
            else
                return out_n
            end
            ip += 2
        elseif opcode == 6
            d = eval_combo(ip + 1, a, b, c, program)
            b = a >> d
            ip += 2
        elseif opcode == 7
            d = eval_combo(ip + 1, a, b, c, program)
            c = a >> d
            ip += 2
        end
    end

    out_n
end

function part2()
    reg = r"""Register A: (\d+)
Register B: 0
Register C: 0

Program: (.+)"""

    inp = read("$(homedir())/aoc-input/2024/day17/input", String)

    m = match(reg, inp)
    program = parse.(Int, eachsplit(m.captures[2], ','))

    a_parts = Int[]

    rec_search(a_parts, program)
end

function rec_search(a_parts, program)
    if length(a_parts) == length(program)
        a = 0
        for x in Iterators.reverse(a_parts)
            a = (a << 3) | x
        end
        return a
    end

    possibilities = Int[]
    max_match = 0

    a_bottom = 0
    for x in Iterators.reverse(a_parts)
        a_bottom = (a_bottom << 3) | x
    end

    shifter = 3 * length(a_parts)

    for a_rest in 0:2^22
        a = (a_rest << shifter) | a_bottom

        n = checka(a, program)
        if n > max_match
            empty!(possibilities)
            max_match = n
            push!(possibilities, a_rest % 8)
        end
    end

    if max_match < length(a_parts) + 2 || isempty(possibilities)
        return nothing
    end

    best_a = nothing

    for next_part in possibilities
        push!(a_parts, next_part)

        a = rec_search(a_parts, program)
        if isnothing(best_a)
            best_a = a
        elseif !isnothing(a)
            best_a = min(best_a, a)
        end

        pop!(a_parts)
    end

    best_a
end

function part2_smart()
    reg = r"""Register A: (\d+)
Register B: 0
Register C: 0

Program: (.+)"""

    inp = read("$(homedir())/aoc-input/2024/day17/input", String)

    m = match(reg, inp)
    program = parse.(Int, eachsplit(m.captures[2], ','))

    mask = 0
    bits = 0

    rec_search2(program, mask, bits, 1)
end

function rec_search2(program, mask, bits, i)
    if i > length(program)
        return bits
    end

    target = program[i]

    global_shifter = (i - 1) * 3

    best = typemax(Int)

    for a_part in 0:7
        shifter = a_part ⊻ 2

        mask1 = Int(0b111)
        mask2 = mask1 << shifter

        b = a_part ⊻ 1
        c = b ⊻ target

        c_shift = c << shifter

        common_mask = mask1 & mask2

        if (a_part ⊻ c_shift) & common_mask != 0
            continue
        end

        new_mask = (mask1 | mask2) << global_shifter
        new_bits = (a_part | c_shift) << global_shifter

        overlap = mask & new_mask

        if (new_bits ⊻ bits) & overlap != 0
            continue
        end

        if cld(64 - leading_zeros(new_bits), 3) > length(program)
            continue
        end

        best = min(
            rec_search2(program, mask | new_mask, bits | new_bits, i + 1), best
        )
    end

    best
end
