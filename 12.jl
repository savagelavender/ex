function back_substitution(A, b)
    n = size(A, 1)
    x = zeros(n)
    
    for i = n:-1:1
        sum_val = b[i]
        for j = i+1:n
            sum_val -= A[i,j] * x[j]
        end
        if A[i,i] == 0
            return "Матрица не является невырожденной"
        end
        x[i] = sum_val / A[i,i]
    end
    
    return x
end

# Генерируем случайную верхнетреугольную матрицу
n = 1000
A = zeros(n,n)
for i = 1:n
    for j = i:n
        A[i,j] = rand()
    end
end

# Генерируем случайный вектор правых частей
b = rand(n)

# Применяем обратный ход алгоритма Гаусса
x = back_substitution(A, b)

# Вычисляем вектор невязки
r = zeros(n)
for i = 1:n
    sum_val = b[i]
    for j = 1:n
        sum_val -= A[i,j] * x[j]
    end
    r[i] = sum_val
end

# Вычисляем норму вектора невязки
residual = 0.0
for i = 1:n
    global residual += abs(r[i])
end
residual = sqrt(residual)

println("Норма вектора невязки: ", residual)