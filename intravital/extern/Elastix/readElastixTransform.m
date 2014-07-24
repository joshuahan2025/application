function [ elastixTransforms ] = readElastixTransform(filename)
% READELASTIXTRANSFORM Read transform parameters generated by Elastix in text files.
% Author: Paul Balan�a
%
% [ elastixParameters ] = READELASTIXTRANSFORM(filename)
%
%     Input:
%        filename            Filename where to read transform parameters.
%
%     Output:
%        elastixParameters   Cell of structures containing the parameters of each transform.
%

% Directory
pathstr = fileparts(filename);

% Read every transform
transExist = 1;
elastixTransforms = {};
while transExist
    % Shift
    elastixTransforms(2:end+1) = elastixTransforms;

    % Current transform
    transStruct = readElastixParameters(filename); %#ok<AGROW>

    % Fix TransformParameters
    if transStruct.NumberOfParameters >= 20
        transStruct.TransformParameters = specialTransPara(filename);
    end

    % InitialTransformParametersFileName => Compose ?
    if ~strcmp(transStruct.InitialTransformParametersFileName{1}, 'NoInitialTransform');
        % Get filename of initial transform
        [pathstrtmp, name, ext, versn] = fileparts(transStruct.InitialTransformParametersFileName{1});
        transStruct.InitialTransformParametersFileName{1} = [name ext versn];
        filename = fullfile(pathstr, [name ext versn]);
    else
        transExist = 0;
    end
    elastixTransforms{1} = transStruct; %#ok<AGROW>
end

end

function [ transPara ] = specialTransPara(filename)
% Read special form of transform parameters.

% Open text file
filePara = fopen(filename, 'rt');
while ~feof(filePara)
    % Read line
    line = fgetl(filePara);

    % Find (TransformParameters)
    idx = findstr(line, '(TransformParameters)');
    if ~isempty(idx)
        % Read next line
        line = fgetl(filePara);
        line = strrep(line, '//', '');

        transPara = regexp(line, '(\S*)', 'match');
        transPara = str2double(transPara);
    end
end
fclose(filePara);

end