start
%{
fail in comment
%}
end

start %{ a one-line block comment %} missing
end

start % %{ a commented block comment
end
