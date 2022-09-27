function B = extendArrayVert(A,nP)
%EXTENDARRAYVERT Summary of this function goes here
%   Detailed explanation goes here

B = A;
while size(B,1) < nP
    B = vertcat(B,A(1,:));
end

end

