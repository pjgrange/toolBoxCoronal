function D=normalise_integral(D)
% Function to normalise integral (sum) of D along columns
% Useful in KL divergence computation (done with loops to avoid memory
% problems)
% Input:
%    D: data matrix
% Output:
%    D: data matrix normalised so that sum across rows equals unity
[Nv,Ng]=size(D);
Dm=sum(D);
for n=1:Ng;
    D(1:Nv,n)=D(1:Nv,n)/Dm(n);
end;
