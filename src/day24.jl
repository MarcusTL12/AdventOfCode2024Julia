using Printf

function eval_wire(wires, w)
    v = wires[w]
    v isa Bool && return v

    a, o, b = v

    a = eval_wire(wires, a)
    b = eval_wire(wires, b)

    c = if o == "OR"
        a | b
    elseif o == "AND"
        a & b
    elseif o == "XOR"
        a ⊻ b
    end

    wires[w] = c
end

function part1()
    wires = Dict{String,Union{Bool,NTuple{3,SubString{String}}}}()

    inp = read("$(homedir())/aoc-input/2024/day24/input", String)

    a, b = eachsplit(inp, "\n\n")

    for l in eachsplit(a, "\n")
        w, v = eachsplit(l, ": ")

        wires[w] = v == "1"
    end

    for l in eachsplit(b, "\n")
        isempty(l) && continue
        a, o, b, _, c = eachsplit(l)

        wires[c] = (a, o, b)
    end

    z_wires = Set{String}()

    for w in keys(wires)
        if startswith(w, 'z')
            push!(z_wires, w)
        end
    end

    z_wires = sort!(collect(z_wires))

    base = 1
    acc = 0
    for w in z_wires
        if eval_wire(wires, w)
            acc += base
        end
        base *= 2
    end

    acc
end

function parse_binary(bits)
    base = 1
    acc = 0
    for b in bits
        if b
            acc += base
        end
        base *= 2
    end

    acc
end

function part2_checker()
    wires = Dict{String,Union{Bool,NTuple{3,SubString{String}}}}()

    inp = read("$(homedir())/aoc-input/2024/day24/input", String)

    a, b = eachsplit(inp, "\n\n")

    for l in eachsplit(a, "\n")
        w, v = eachsplit(l, ": ")

        wires[w] = v == "1"
    end

    connections = Pair{SubString{String},NTuple{3,SubString{String}}}[]

    for l in eachsplit(b, "\n")
        isempty(l) && continue
        a, o, b, _, c = eachsplit(l)

        push!(connections, c => (a, o, b))
    end

    x_wires = Set{String}()

    for w in keys(wires)
        if startswith(w, 'x')
            push!(x_wires, w)
        end
    end

    x_wires = sort!(collect(x_wires))

    y_wires = Set{String}()

    for w in keys(wires)
        if startswith(w, 'y')
            push!(y_wires, w)
        end
    end

    y_wires = sort!(collect(y_wires))

    x = parse_binary(eval_wire(wires, w) for w in x_wires)
    y = parse_binary(eval_wire(wires, w) for w in y_wires)

    swaps = (
        ("rrs", "rvc"),
        ("z24", "vcg"),
        ("z20", "jgb"),
        ("z09", "rkf")
    )

    swapper_dict = Dict{String,String}()

    for (a, b) in swaps
        swapper_dict[a] = b
        swapper_dict[b] = a
    end

    for (c, (a, o, b)) in connections
        out = get(swapper_dict, c, c)

        wires[out] = (a, o, b)
    end

    z_wires = Set{String}()

    for w in keys(wires)
        if startswith(w, 'z')
            push!(z_wires, w)
        end
    end

    z_wires = sort!(collect(z_wires))

    base = 1
    acc = 0
    for w in z_wires
        if eval_wire(wires, w)
            acc += base
        end
        base *= 2
    end

    (x, y, acc)
end

function part2()
    wires = Dict{String,Union{Bool,NTuple{3,SubString{String}}}}()

    inp = read("$(homedir())/aoc-input/2024/day24/input", String)

    a, b = eachsplit(inp, "\n\n")

    for l in eachsplit(a, "\n")
        w, v = eachsplit(l, ": ")

        wires[w] = v == "1"
    end

    connections = Pair{SubString{String},NTuple{3,SubString{String}}}[]

    for l in eachsplit(b, "\n")
        isempty(l) && continue
        a, o, b, _, c = eachsplit(l)

        push!(connections, c => (a, o, b))
    end

    x_wires = Set{String}()

    for w in keys(wires)
        if startswith(w, 'x')
            push!(x_wires, w)
        end
    end

    x_wires = sort!(collect(x_wires))

    y_wires = Set{String}()

    for w in keys(wires)
        if startswith(w, 'y')
            push!(y_wires, w)
        end
    end

    y_wires = sort!(collect(y_wires))

    x = parse_binary(eval_wire(wires, w) for w in x_wires)
    y = parse_binary(eval_wire(wires, w) for w in y_wires)

    a_wires = Pair{String,String}[]

    for (c, (a, o, b)) in connections
        if o == "AND" && (startswith(a, 'x') && startswith(b, 'y') ||
                          startswith(a, 'y') && startswith(b, 'x'))

            push!(a_wires, "a" * a[2:end] => c)
        end
    end

    sort!(a_wires)

    println("A:")
    display(a_wires)

    a_trans = Dict([old => new for (new, old) in a_wires])

    b_wires = Pair{String,String}[]

    for (c, (a, o, b)) in connections
        if o == "XOR" && (startswith(a, 'x') && startswith(b, 'y') ||
                          startswith(a, 'y') && startswith(b, 'x'))

            push!(b_wires, "b" * a[2:end] => c)
        end
    end

    sort!(b_wires)

    println("B:")
    display(b_wires)

    b_trans = Dict([old => new for (new, old) in b_wires])

    c_wires = Pair{String,String}[]
    d_wires = Pair{String,String}[]

    for (c, (a, o, b)) in connections
        if o == "AND" && (haskey(b_trans, a) || haskey(b_trans, b))
            c_w, b_w = if haskey(b_trans, a)
                b, b_trans[a]
            else
                a, b_trans[b]
            end

            n = parse(Int, b_w[2:end])

            nm1 = @sprintf "%02d" (n - 1)

            push!(d_wires, "d" * b_w[2:end] => c)
            push!(c_wires, "c" * nm1 => c_w)
        end
    end

    sort!(d_wires)
    sort!(c_wires)

    println("d:")
    display(d_wires)

    println("c:")
    display(c_wires)

    d_trans = Dict([old => new for (new, old) in d_wires])
    c_trans = Dict([old => new for (new, old) in c_wires])

    for (c, (a, o, b)) in connections
        if o == "OR"

        end
    end

    for (c, (a, o, b)) in connections
        if startswith(c, 'z')
            if o != "XOR"
                println("Inconsistency: $c, $((a, o, b))")
            end
        end

        if o == "OR"
            if !(haskey(a_trans, a) && haskey(d_trans, b) ||
                 haskey(a_trans, b) && haskey(d_trans, a))
                println("Inconsistency: $c, $((a, o, b))")
            end
        end
    end
end

# ai = xi & yi
# bi = xi ⊻ yi
# di = bi & ci-1
# ci = ai | di
# zi = bi ⊻ ci-1
#
# z00 = x00 ⊻ y00          c00 = x00 & y00
# z01 = x01 ⊻ y01 ⊻ c00    c01 = x01 & y01 | (x01 ⊻ y01) & c00
# z02 = x02 ⊻ y02 ⊻ c01    c02 = x02 & y02 | (x02 ⊻ y02) & c01
#

# By Hand:
#
# Total swap: rrs,rvc,z24,vcg,z20,jgb,z09,rkf
# Sorted:     jgb,rkf,rrs,rvc,vcg,z09,z20,z24
#
