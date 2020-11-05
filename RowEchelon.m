prompt1 = 'Please enter matrix A in the format [r1v1, r1v2; r2v1, etc.]: ';
A = input(prompt1);
A = isInputCorrect(A, prompt1);
A = rowEchelon(A)

function x = rowEchelon(A)
    [m,n] = size(A);
    if m > n
        m = n;
    end
    
    i = 1;
    while i <= m
        A = eliminateColumn(A,i);
        i = i + 1;
    end
    x = A;
end

%A is the matrix, d is the column
function x = eliminateColumn(A,d)
    a = findFirstNonZeroRow(A, d);
    [m,n] = size(A);
    if a > d
        b = A(d,:);
        A(d,:) = A(a,:);
        A(a,:) = b;
    end
    while m > d
        if A(m,d) ~= 0 && A(d,d) ~= 0
            c = A(m,d)/A(d,d);
            A(m,:) = A(m,:) - c * A(d,:);
        end
        m = m - 1;
    end
    x = A;
end

function x = findFirstNonZeroRow(A, d)
    [m,~] = size(A);
    i = d;
    while A(i,d) == 0
        i = i + 1;
        if i > m
            break
        end
    end
    if i > m
        i = -1;
    end
    x = i;
end

function x = isInputCorrect(y, prompt);
    prompt2 = 'Is this correct (please answer with "y" or "n")? ';
    y
    str = input(prompt2, 's');
    if contains(str, 'n')
        x = input(prompt);
        isInputCorrect(x, prompt);
    else
        x = y;
    end
end