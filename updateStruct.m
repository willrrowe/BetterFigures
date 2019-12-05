function [strct] = updateStruct( strct, varargin)
%updateStruct(struct, nameValuePairs)
% struct - The current struct.
% nameValuePairs - name-value pairs to change or add to the struct.

    nArgs = length(varargin);
    if round(nArgs/2)~=nArgs/2
       error('EXAMPLE needs propertyName/propertyValue pairs')
    end

    for pair = reshape(varargin,2,[]) % pair is {propName;propValue}
        strct.(pair{1}) = pair{2};
    end
    
end

