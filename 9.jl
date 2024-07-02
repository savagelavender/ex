function is_prime(n::Int)
    if n < 2
        return false
    end
    for i in 2:Int(sqrt(n))
        if n % i == 0
            return false
        end
    end
    return true
end

print("Введите число для проверки: ")
num = parse(Int, readline())

if is_prime(num)
    println("$num является простым числом.")
else
    println("$num не является простым числом.")
end