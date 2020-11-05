prompt1 = 'Please enter matrix A (in Ax = b) in the format [r1v1, r1v2; r2v1, etc.]: ';
A = input(prompt);
prompt1 = 'Please enter a column to eliminate';
d = input(prompt);

A
A = eliminateColumn(A,d)

function x = eliminateColumn(A,d)
    a = findFirstNonZeroRow(A, d);
    [m,n] = size(A);
    if a > d
        b = A(d,:);
        A(d,:) = A(a,:);
        A(a,:) = b;
    end
    while m > d
        if A(m,d) ~= 0
            c = A(m,d)/A(d,d);
            A(m,:) = A(m,:) - c * A(d,:);
        end
        m = m - 1;
    end
    x = A
end