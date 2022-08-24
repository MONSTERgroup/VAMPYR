function B = extendArrayVert(A,nP)
%EXTENDARRAYHORZ Summary of this function goes here
%   Detailed explanation goes here
s = inputname(1);

B = A;
while size(B,1) < nP
    B = vertcat(B,A(1,:));
end


warning('Extended %s to match number of phases.', s);

end

