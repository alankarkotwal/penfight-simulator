function out = angFrictionFn(x, A, B, C, D, E, F)

    out = A*x*(B+C*x)/sqrt(D+E*x+F*x^2);
    
end