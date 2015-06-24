function D=normalise_integral_L2(D)
% Function to normalise integral (sum) of D along columns
% Useful in KL divergence computation (done with loops to avoid memory
% problems)
% Input:
%    D: data matrix
% Output:
%    D: data matrix normalised so that sum across rows equals unity
[Nv,Ng]=size(D);
Square = D.*D;
Dm=sum(Square);
for n=1:Ng;
    norm = Dm( n );
    if norm ~= 0  
    D(1:Nv,n)=D(1:Nv,n)/sqrt( norm );
    end
end;