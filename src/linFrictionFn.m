function out = linFrictionFn(x, A, B, C, D, E, F)

    out = A*(B+C*x)/sqrt(D+E*x+F*x^2);
    
end