function out = linFrictionIntegral(x, A, B, C, D, E, F)

    out = (A*B*log((E/2 + F*x)/F^(1/2) + ...
    (F*x^2 + E*x + D)^(1/2)))/F^(1/2) + (A*C*(F*x^2 + E*x + D)^(1/2))/F - ...
    (A*C*E*log((E/2 + F*x)/F^(1/2) + (F*x^2 + E*x + D)^(1/2)))/(2*F^(3/2));

end