function identifiers = fcn_PrepareSubmission_getIdentifiers(varargin)

%% fcn_PrepareSubmission_getIdentifiers
%     fcn_PrepareSubmission_getIdentifiers extracts identifiers for the
%     current computer including MAC address, user, MATLAB version, OS
%     version, hostname, etc.
%
% FORMAT:
%
%      identifiers = fcn_PrepareSubmission_getIdentifiers((fid));
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      figNum: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      identifiers: a structure containing the following identifiers
%                      ispc: 1
%                     ismac: 0
%                    isunix: 0
%                 isstudent: 0
%                   license: '662891'
%                  Platform: 'PCWIN64'
%                      Arch: 'win64'
%                  HostName: 'E5-ME-L-SEBR17'
%                      User: ''
%             MATLABversion: '24.1.0.2568132 (R2024a) Update 1'
%         InstalledPackages: [1×113 struct]
%                  GPUcount: 0
%                      MACs: {6×1 cell}
%               UTCdatetime: 19-Jan-2026 16:45:19
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_PrepareSubmission_getIdentifiers
%     for a full test suite.
%
% This function was written on 2026_01_19 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_01_19 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PrepareSubmission_getIdentifiers 
%   % * Wrote the code originally, using breakDataIntoLaps as starter
%   % * Extracts identifiers for the current computer
%   % * Added UTC time query also
%
% 2026_01_22 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PrepareSubmission_getIdentifiers 
%   % * Shut off call to check GPU count. This requires extra toolboxes
%   % * Renamed getMACs to fcn_INTERNAL_getMACs for clarity


% TO-DO:
%
% 2026_01_19 by Sean Brennan, sbrennan@psu.edu
% - add NTP time query




%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 1; % The largest Number of argument inputs to the function
flag_max_speed = 0; % The default. This runs code with all error checking
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PREPARESUBMISSION_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PREPARESUBMISSION_FLAG_CHECK_INPUTS");
    MATLABFLAG_PREPARESUBMISSION_FLAG_DO_DEBUG = getenv("MATLABFLAG_PREPARESUBMISSION_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PREPARESUBMISSION_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PREPARESUBMISSION_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PREPARESUBMISSION_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PREPARESUBMISSION_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug % If debugging is on, print on entry/exit to the function
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_figNum = 999978; %#ok<NASGU>
else
    debug_figNum = []; %#ok<NASGU>
end

%% check input arguments?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0==flag_max_speed
    if flag_check_inputs
        % Are there the right number of inputs?
        narginchk(0,MAX_NARGIN);

        % % Check the studentNumber to be sure it is a number
        % fcn_DebugTools_checkInputsToFunctions(studentNumber, '1column_of_numbers',[1 1]);
		% 
        % % Check the localFolder to be sure it is a text style and a folder
        % fcn_DebugTools_checkInputsToFunctions(localFolder, '_of_char_strings');
        % fcn_DebugTools_checkInputsToFunctions(localFolder, 'DoesDirectoryExist');
		% 
        % % Check the archiveFolder to be sure it is a text style and a folder
        % fcn_DebugTools_checkInputsToFunctions(archiveFolder, '_of_char_strings');
        % fcn_DebugTools_checkInputsToFunctions(archiveFolder, 'DoesDirectoryExist');
		% 
        % % Check the timeString to be sure it is a text style
        % fcn_DebugTools_checkInputsToFunctions(timeString, '_of_char_strings');

    end
end


% % The following area checks for variable argument inputs (varargin)
% 
% % Does the user want to specify the subFolder input?
% % Set defaults first:
% subFolder = '';
% if 5 <= nargin
%     temp = varargin{1};
%     if ~isempty(temp)
%         subFolder = temp;
%     end
% end
% 
% % Does the user want to specify flagArchiveEqualFiles input?
% flagArchiveEqualFiles = 0; % Default case
% if 6 <= nargin
%     temp = varargin{2};
%     if ~isempty(temp)
%         % Set the flagArchiveEqualFiles values
%         flagArchiveEqualFiles = temp;
%     end
% end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp; %#ok<NASGU>
        flag_do_plots = 1;
    end
end


%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

identifiers = struct();
identifiers.ispc = ispc;
identifiers.ismac = ismac;
identifiers.isunix = isunix;
identifiers.isstudent = isstudent;
identifiers.license = license;
identifiers.Platform = computer;
identifiers.Arch = computer('arch');
identifiers.HostName = char(java.net.InetAddress.getLocalHost.getHostName());
identifiers.User = getenv('USER');
identifiers.MATLABversion = version;
identifiers.InstalledPackages = ver;
identifiers.GPUcount = 0; % gpuDeviceCount;
identifiers.MACs = fcn_INTERNAL_getMACs;
identifiers.UTCdatetime = fcn_debugTools_timeQueryNTPserver('time.nist.gov', [], [], -1);

%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_plots
    disp(identifiers);
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function

%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% fcn_INTERNAL_getMACs
function macs = fcn_INTERNAL_getMACs()
% getMACs Return cell array of MAC addresses (formatted XX-XX-XX-XX-XX-XX)
macs = {};
import java.net.NetworkInterface
en = NetworkInterface.getNetworkInterfaces();
while en.hasMoreElements()
    ni = en.nextElement();
    mac = ni.getHardwareAddress();
    if ~isempty(mac)
        % mac is a Java byte[] (signed int8). Convert to uint8 and format.
        b = typecast(int8(mac), 'uint8');
        macs{end+1,1} = upper(strjoin(arrayfun(@(x) sprintf('%02X', x), double(b), 'Uni', false), '-')); %#ok<AGROW>
    end
end
end % Ends fcn_INTERNAL_getMACs