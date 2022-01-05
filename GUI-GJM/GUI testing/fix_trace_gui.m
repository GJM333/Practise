function varargout = fix_trace_gui(varargin)
% FIX_TRACE_GUI MATLAB code for fix_trace_gui.fig
%      FIX_TRACE_GUI, by itself, creates a new FIX_TRACE_GUI or raises the existing
%      singleton*.
%
%      H = FIX_TRACE_GUI returns the handle to a new FIX_TRACE_GUI or the handle to
%      the existing singleton*.
%
%      FIX_TRACE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIX_TRACE_GUI.M with the given input arguments.
%
%      FIX_TRACE_GUI('Property','Value',...) creates a new FIX_TRACE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fix_trace_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fix_trace_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fix_trace_gui

% Last Modified by GUIDE v2.5 24-Nov-2021 15:11:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fix_trace_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @fix_trace_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT

% BEGIN copy: https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/JjsKfUb8r8k
% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try 
    % normalize fonts 
    fnames = fieldnames(handles);   % get all GUI elements 
    d1 = handles.(fnames{1}).Position(3)/handles.GUIfiguresize(1); 
    d2 = handles.(fnames{1}).Position(4)/handles.GUIfiguresize(2); 
    pixelfactor = min(d1,d2); 
    for i=1:length(fnames) 
        field = handles.(fnames{i}); 
        try field.FontSize; 
            if strcmp(field.Type,'uitable') 
                % not yet supported cause FontSize change does not effect 
                % all part of the table 
            else 
                set(field,'FontSize',pixelfactor*field.UserData.GUIfontsize); 
            end 
        catch 
        end 
    end 
catch 
end 
guidata(hObject, handles);

end
% END copy

% --- Executes just before fix_trace_gui is made visible.
function fix_trace_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fix_trace_gui (see VARARGIN)

addpath('utils');
addpath(genpath('../functions'));
addpath(genpath('../third_party_functions/'));

% BEGIN copy: https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/JjsKfUb8r8k
% Center figure on screen and store origin figure size (GUIfiguresize) 
set(hObject,'Units','pixels');    % force for top figure 
figuresize = get(hObject,'Position'); 
handles.GUIfiguresize = figuresize(3:4); % only need [xsize,ysize] 
screensize = get(0,'ScreenSize'); 
xpos = ceil((screensize(3)-figuresize(3))/2); % center horizontally 
ypos = ceil((screensize(4)-figuresize(4))/2); % center vertically 
set(hObject,'Position',[xpos,ypos,figuresize(3:4)]); 

% For all GUI-elements except top figure: 
fnames = fieldnames(handles); 
for i=2:length(fnames) 
    field = handles.(fnames{i}); 
    % set Units to 'normalized' 
    try field.Units; 
        field.Units = 'normalized'; 
    catch 
    end 
    % set FontUnits to 'points' and store origin font size (UserData.GUIfontsize) 
    try field.FontUnits; 
        field.FontUnits = 'points'; 
        if strcmp(field.Type,'uitable') 
            % not yet supported cause UserData can't be used and layout 
            % doesn't react completely on FontSize changes 
        else 
            field.UserData.GUIfontsize = field.FontSize; 
        end 
    catch 
    end 
end 
set(hObject,'Units','pixels');    % might be changed before 
% END copy

% set tooltipstring
set(handles.text_file_path, 'TooltipString', sprintf('Folder storing the nuclear images.\nImage sequences or stacks only.'));
set(handles.edit_file_path, 'TooltipString', sprintf('Enter the path to the folder.'));
set(handles.pushbutton_select_path, 'TooltipString', sprintf('Select the folder.'));
set(handles.text_prefix, 'TooltipString', sprintf('Format of filenames.\nUse %%t for Frame IDs.\nUse %%0Nt for prefix zeros.'));
set(handles.edit_prefix, 'TooltipString', sprintf('Enter the format of filenames.'))
set(handles.text80, 'TooltipString', sprintf('Frames to load.'));
set(handles.edit_first_imported_frame_id, 'TooltipString', sprintf('Enter ID of the first frame.\nMust be a non-negative integer.'));
set(handles.edit_last_imported_frame_id, 'TooltipString', sprintf('Enter ID of the last frame.\nMust be a non-negative integer.'));
set(handles.text_mask_path, 'TooltipString', sprintf('Folder storing the mask images. \nImage sequences or stacks only.'));
set(handles.edit_mask_path, 'TooltipString', sprintf('Enter the path to the folder'));
set(handles.text_mask_prefix, 'TooltipString', sprintf('Format of filenames.\nUse %%t for Frame IDs.\nUse %%0Nt for prefix zeros.'));
set(handles.edit_mask_prefix, 'TooltipString', sprintf('Enter the format of filenames.'));
set(handles.text_extMAT, 'TooltipString', sprintf('Path to the MAT file storing the previous correction information. \nLeave empty if not available'));
set(handles.edit_extMAT_path, 'TooltipString', sprintf('Enter the path to the MAT file.'));
set(handles.text_cmos, 'TooltipString', sprintf('Path to the MAT file storing the camera dark noise.\nLeave empty if not available.'));
set(handles.edit_cmos, 'TooltipString', sprintf('Enter the path to the MAT file.'));
set(handles.pushbutton_cmos, 'TooltipString', sprintf('Select the MAT file.'));
set(handles.text_bias, 'TooltipString', sprintf('Path to the MAT file storing the illumination bias.\nLeave empty if not available.'));
set(handles.edit_bias, 'TooltipString', sprintf('Enter the path to the MAT file.'));
set(handles.pushbutton_bias, 'TooltipString', sprintf('Select the MAT file.'));
set(handles.text_path_tracedata, 'TooltipString', sprintf('Path to the hdf5 file storing the tracedata.'));
set(handles.edit_path_tracedata, 'TooltipString', sprintf('Enter the path to the hdf5 file.'));
set(handles.pushbutton_path_tracedata, 'TooltipString', sprintf('Select the existing training dataset.'));
set(handles.text_path_output, 'TooltipString', sprintf('Path to the folder storing the output.'));
set(handles.edit_path_output, 'TooltipString', sprintf('Enter the path to the folder.'));
set(handles.pushbutton_path_output, 'TooltipString', sprintf('Select the folder.'));
set(handles.pushbutton_import_to_workspace, 'TooltipString', sprintf('Load images and start training.'));

set(handles.pushbutton_go_by_10_frames_prev, 'TooltipString', sprintf('Go backward by 10 frames.\nShortcut: Down Arrow'));
set(handles.pushbutton_go_by_10_frames_next, 'TooltipString', sprintf('Go forward by 10 frames.\nShortcut: Up Arrow'));
set(handles.pushbutton_go_by_1_frame_prev, 'TooltipString', sprintf('Go backward by 10 frames.\nShortcut: Left Arrow'));
set(handles.pushbutton_go_by_1_frame_next, 'TooltipString', sprintf('Go forward by 10 frames.\nShortcut: Right Arrow'));
set(handles.edit_go_to, 'TooltipString', sprintf('Enter Frame ID.\nMust be a loaded Frame ID.'));
set(handles.pushbutton_go_to_frame_ID, 'TooltipString', sprintf('Go to the frame.'));
set(handles.text81, 'TooltipString', sprintf('Intensity range for display.'));
set(handles.edit_intensity_low, 'TooltipString', sprintf('Enter the lower bound.\nMust be a non-negative number.'));
set(handles.edit_intensity_high, 'TooltipString', sprintf('Enter the upper bound.\nMust be a non-negative number.'));
set(handles.pushbutton_clear, 'TooltipString', sprintf('Clear one training data.') )
set(handles.pushbutton_clear_all, 'TooltipString', sprintf('Clear all training data.'));
set(handles.pushbutton_finish, 'TooltipString', sprintf('Finish training.'));


% Choose default command line output for fix_trace_gui
handles.output = hObject;

% initialize data structures
handles.file_path = []; % selected file paths
handles.prefix = []; % prefix of file names (e.g. 1_1_1_mIFP_)
handles.imported_frame_id = []; % first:last id
handles.mask_path = []; % selected mask paths
handles.mask_prefix = []; %prefix of mask file names
handles.extMAT_path = []; % selected path for existing correction info
handles.cmos_path = []; % cmosoffset path
handles.bias_path = []; % bias path
handles.tracedata_path = []; % selected path for tracedata
handles.output_path = []; % selected path for output
handles.curr_frame_id = []; % current frame id for display
handles.curr_ellipse_id = []; % current selected ellipse id
handles.curr_cell_id = []; % current cell id for motion classification
handles.fix_traces = []; % save all correction info
handles.lf = [];

% set visibility of structure
set(handles.uipanel_nav_frames, 'Visible', 'Off');
set(handles.table_fix_traces, 'Visible', 'Off');
set(handles.pushbutton_clear_all, 'Visible', 'Off');
set(handles.pushbutton_clear, 'Visible', 'Off');
set(handles.pushbutton_finish, 'Visible', 'Off');
set(handles.pushbutton_notation, 'Visible', 'Off' );
set(handles.pushbutton_showLineage, 'Visible', 'Off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fix_trace_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = fix_trace_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

%% SETTING
function edit_file_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_file_path as text
%        str2double(get(hObject,'String')) returns contents of edit_file_path as a double

handles.file_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.file_path);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in pushbutton_select_path.
function pushbutton_select_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selpath = uigetdir;
if (selpath ~= 0)
    handles.file_path = adjust_path(selpath, 0);
    set(handles.edit_file_path, 'String', handles.file_path);
end
guidata(hObject, handles);

end

function edit_prefix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_prefix as text
%        str2double(get(hObject,'String')) returns contents of edit_prefix as a double

handles.prefix = get(hObject, 'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_prefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_first_imported_frame_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_first_imported_frame_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_first_imported_frame_id as text
%        str2double(get(hObject,'String')) returns contents of edit_first_imported_frame_id as a double

% check whether the input string is a valid number

val = str2double(get(hObject, 'String'));
if (isnan(val) || val < 0 || val ~= floor(val))
    waitfor(errordlg('Invalid value. Please enter a non-negative integer.', 'Error'));
    set(hObject, 'String', '');
else
    if (val > str2double(get(handles.edit_last_imported_frame_id, 'String')))
        set(hObject, 'String', get(handles.edit_last_imported_frame_id, 'String'));
        set(handles.edit_last_imported_frame_id, 'String', num2str(val));
    end
end
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_first_imported_frame_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_first_imported_frame_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_last_imported_frame_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_last_imported_frame_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_last_imported_frame_id as text
%        str2double(get(hObject,'String')) returns contents of edit_last_imported_frame_id as a double

val = str2double(get(hObject, 'String'));
if (isnan(val) || val < 0 || val ~= floor(val))
    waitfor(errordlg('Invalid value. Please enter a non-negative integer.', 'Error'));
    set(hObject, 'String', '');
else
    if (val < str2double(get(handles.edit_first_imported_frame_id, 'String')))
        set(hObject, 'String', get(handles.edit_first_imported_frame_id, 'String'));
        set(handles.edit_first_imported_frame_id, 'String', num2str(val));
    end
end
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_last_imported_frame_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_last_imported_frame_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_mask_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mask_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mask_path as text
%        str2double(get(hObject,'String')) returns contents of edit_mask_path as a double
handles.mask_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.mask_path);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit_mask_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mask_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_select_mask_path.
function pushbutton_select_mask_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_mask_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selmaskpath = uigetdir;
if (selmaskpath ~= 0)
    handles.mask_path = adjust_path(selmaskpath, 0);
    set(handles.edit_mask_path, 'String', handles.mask_path);
end
guidata(hObject, handles);

end

function edit_mask_prefix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mask_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mask_prefix as text
%        str2double(get(hObject,'String')) returns contents of edit_mask_prefix as a double
handles.mask_prefix = get(hObject, 'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_mask_prefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mask_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_extMAT_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_extMAT_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_extMAT_path as text
%        str2double(get(hObject,'String')) returns contents of edit_extMAT_path as a double
handles.extMAT_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.extMAT_path);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit_extMAT_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_extMAT_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in pushbutton_extMAT.
function pushbutton_extMAT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_extMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ file, path ] = uigetfile({'*.mat','*.MAT'}, 'Select previous mat file');
if (file ~= 0)
    handles.extMAT_path = adjust_path([path, file], 0);
    set(handles.edit_extMAT_path, 'String', handles.extMAT_path);
end
guidata(hObject, handles);

end

function edit_cmos_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cmos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cmos as text
%        str2double(get(hObject,'String')) returns contents of edit_cmos as a double

handles.cmos_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.cmos_path);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_cmos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cmos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_cmos.
function pushbutton_cmos_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cmos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ file, path ] = uigetfile({'*.mat','*.MAT'}, 'Select Camera Dark Noise');
if (file ~= 0)
    handles.cmos_path = adjust_path([path, file], 0);
    set(handles.edit_cmos, 'String', handles.cmos_path);
end
guidata(hObject, handles);

end

function edit_bias_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bias as text
%        str2double(get(hObject,'String')) returns contents of edit_bias as a double

handles.bias_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.bias_path);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_bias_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_bias.
function pushbutton_bias_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ file, path ] = uigetfile({'*.mat','*.MAT'}, 'Select Illumination Bias');
if (file ~= 0)
    handles.bias_path = adjust_path([path, file], 0);
    set(handles.edit_bias, 'String', handles.bias_path);
end
guidata(hObject, handles);

end

function edit_path_tracedata_Callback(hObject, eventdata, handles)
% hObject    handle to edit_path_tracedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_path_tracedata as text
%        str2double(get(hObject,'String')) returns contents of edit_path_tracedata as a double

handles.tracedata_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.tracedata_path);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_path_tracedata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_path_tracedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in pushbutton_path_tracedata.
function pushbutton_path_tracedata_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_path_tracedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ file, path ] = uigetfile({'*.h5','*.hdf5'}, 'Select target tracedata');
if (file ~= 0)
    handles.tracedata_path = adjust_path([path, file], 0);
    set(handles.edit_path_tracedata, 'String', handles.tracedata_path);
end
guidata(hObject, handles);

end

function edit_path_output_Callback(hObject, eventdata, handles)
% hObject    handle to edit_path_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_path_output as text
%        str2double(get(hObject,'String')) returns contents of edit_path_output as a double

handles.output_path = adjust_path(get(hObject, 'String'), 0);
set(hObject, 'String', handles.output_path);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_path_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_path_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in pushbutton_path_output.
function pushbutton_path_output_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_path_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selpath = uigetdir;
if (selpath ~= 0)
    handles.output_path = adjust_path(selpath, 0);
    set(handles.edit_path_output, 'String', handles.output_path);
end
guidata(hObject, handles);

end

% --- Executes on button press in pushbutton_import_to_workspace.
function pushbutton_import_to_workspace_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_import_to_workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set visibility of buttons
f = waitbar(0, 'Loading Data.'); pause(0.01);
handles = set_setting_enability( handles, 'Off' );

% obtain the data
start_frame_id = str2double(get(handles.edit_first_imported_frame_id, 'String'));
end_frame_id = str2double(get(handles.edit_last_imported_frame_id, 'String'));

% check if any field is empty
if (isempty(start_frame_id) || isempty(end_frame_id) || isempty(handles.prefix) || isempty(handles.file_path) || ...
        isempty(handles.tracedata_path) || isempty(handles.output_path))
    % display error message
    close(f);
    waitfor(errordlg('Some fields are empty!','Error'));
    
    % resume visibility of buttons
    handles = set_setting_enability( handles, 'On' );
    guidata(hObject, handles);
    return;
end

% frames, prepare data structure
handles.imported_frame_id = start_frame_id:end_frame_id;
num_imported_frame_id = length(handles.imported_frame_id);
temp(1:num_imported_frame_id) = struct('image', {{}}, 'ellipse_info', {{}});
handles.figure1.UserData = temp;

% import existing correction file
if isempty(handles.extMAT_path)
    handles.fix_traces = [];
    set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
else
    try
        h = load(handles.extMAT_path);
        handles.fix_traces = h.corHistory;
        set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
    catch
        handles.fix_traces = [];
        set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
        waitfor(warndlg('Existing dataset is not valid. Will not import it.','Warning'));
    end
end

% import cmosoffset
try
    h = load(handles.cmos_path);
    cmosoffset = h.cmosoffset;
catch
    % display warning message
    if (~isempty(handles.cmos_path))
        waitfor(warndlg('Fail to load cmosoffset. Will not correct camera dark noise.', 'Warning'));
    end
    cmosoffset = 0;
end

% import bias
try
    h = load(handles.bias_path);
    bias = h.bias;
catch
    % display warning message
    if (~isempty(handles.bias_path))
        waitfor(warndlg('Fail to load bias. Will not correct illumination bias.', 'Warning'));
    end
    bias = 1;
end

% import image files
waitbar(0.25, f); pause(0.01);
try
    [filename_format, image_info_order] = convert_filename_format(struct('filename_format', handles.prefix, 'image_type', 'gui'));
    for i=1:num_imported_frame_id
        image_info = {1, 1, 1, 0, handles.imported_frame_id(i), 'mCherry', 'a', 'A'};
        image_path = [handles.file_path, sprintf(filename_format, image_info{image_info_order})];
        if (length(imfinfo(image_path)) == 1)
            I = imread(image_path);
        else
            try
                I = imread(image_path, 'Index', handles.imported_frame_id(i));
            catch
                I = imread(image_path, 'Frames', handles.imported_frame_id(i));
            end
        end
        handles.figure1.UserData(i).image = max((double(I)-cmosoffset)./bias, 1);
    end
catch
    % display error message
    close(f);
    waitfor(errordlg('Error reading images.','Error'));
    
    % resume visibility of buttons
    handles = set_setting_enability( handles, 'On' );
    handles.imported_frame_id = [];
    handles.figure1.UserData = [];
    guidata(hObject, handles);
    return
end

% import tracedata - modified by Jiasui 2021/9/4
if isempty(handles.mask_prefix) == 1
    waitbar(0.75, f); pause(0.01);
    try
        handles = importTracedata( handles, 0 );
    catch
        % display error message
        close(f);
        waitfor(errordlg('Tracedata not found!','Error'));

        % resume visibility of buttons
        handles = set_setting_enability( handles, 'On' );
        handles.imported_frame_id = [];
        handles.figure1.UserData = [];
        guidata(hObject, handles);
        return
    end  
% import the masks
elseif isempty(handles.mask_prefix) == 0
    waitbar(0.75, f); pause(0.01);
    try
    [filename_format, image_info_order] = convert_filename_format(struct('filename_format', handles.mask_prefix, 'image_type', 'gui'));
    overview = h5read(handles.tracedata_path,'/genealogy');
        for i=1:num_imported_frame_id
            image_info = {1, 1, 1, 0, handles.imported_frame_id(i), 'mCherry', 'a', 'A'};
            image_path = [handles.mask_path, sprintf(filename_format, image_info{image_info_order})];
            if (length(imfinfo(image_path)) == 1)
                I = imread(image_path);
            else
                try
                    I = imread(image_path, 'Index', handles.imported_frame_id(i));
                catch
                    I = imread(image_path, 'Frames', handles.imported_frame_id(i));
                end
            end
            all_parametric_para = {};
            all_boundary_points = {};
            all_internal_points = {};
            % loop through every cell in frame
            for j = 1:length(overview)
                cell_start_frame = overview(j,1);
                cell_end_frame = overview(j,2);
                if handles.imported_frame_id(i) >= cell_start_frame && handles.imported_frame_id(i) <= cell_end_frame
                    curr_cell_data = h5read(handles.tracedata_path,['/c',num2str(j),'/data']);
                    if size(curr_cell_data,2) == 1
                        curr_cell_data = curr_cell_data';
                    end
                    curr_cell_x = curr_cell_data((handles.imported_frame_id(i)-cell_start_frame+1), 1);
                    curr_cell_y = curr_cell_data((handles.imported_frame_id(i)-cell_start_frame+1), 2);
                    % separate mitosis event
                    if ~isempty(find(overview(:,3)==j,1)) && handles.imported_frame_id(i) == cell_end_frame
                        all_parametric_para{end+1} = [j;1;curr_cell_x;curr_cell_y;NaN]; % 1 for mitosis
                    elseif isempty(find(overview(:,3)==j,1)) && handles.imported_frame_id(i) == cell_end_frame
                        all_parametric_para{end+1} = [j;2;curr_cell_x;curr_cell_y;NaN]; % 2 for apoptosis
                    else
                        all_parametric_para{end+1} = [j;0;curr_cell_x;curr_cell_y;NaN]; % 0 for migration
                    end

                    % find the boundary of cell j in frame i using mask
                    single_mask = I == j ;
                    cur_boundary = bwperim(single_mask);
                    [row_bou,col_bou] = find(cur_boundary == 1);
                    points = [col_bou(1:length(col_bou)),row_bou(1:length(row_bou))];
                    n_point = 1;
                    cur = points(1,:);
                    curve = zeros(length(points),2);
                    while size(points,1)>1
                        curve(n_point,1) = cur(1);
                        curve(n_point,2) = cur(2);
                        cur_indices = find(points(:,1) == cur(1) & points(:,2) == cur(2));
                        points (cur_indices,:) = [];
                        % dsearchn is not a pretty way to find the closest pixel, change if
                        % possible
                        cp_indices = dsearchn(points,cur); % returns indices of closests pixel
                        cur = points(cp_indices,:);
                        n_point = n_point+1;
                    end
                    % adding last point to array
                    curve(n_point,1) = cur(1);
                    curve(n_point,2) = cur(2);
                    all_boundary_points{end+1} = curve;

                    cur_inter = single_mask - cur_boundary;
                    [row_int,col_int] = find(cur_inter == 1);
                    all_internal_points{end+1} = [col_int,row_int];
                end
            end
            handles.figure1.UserData(i).ellipse_info = struct('all_parametric_para',{all_parametric_para'},'all_boundary_points',{all_boundary_points'},'all_internal_points',{all_internal_points'});
        end
    catch
        % display error message
        close(f);
        waitfor(errordlg('Error reading mask.','Error'));

        % resume visibility of buttons
        handles = set_setting_enability( handles, 'On' );
        handles.imported_frame_id = [];
        handles.figure1.UserData = [];
        guidata(hObject, handles);
        return
    end  
end

close(f);

% % setting up slider
% set(handles.slider_frame, 'value', start_frame_id);
% set(handles.slider_frame, 'min', start_frame_id);
% set(handles.slider_frame, 'max', end_frame_id);
% set(handles.slider_frame, 'SliderStep', [1/(end_frame_id-1), 1/(end_frame_id-1)*10]);
% initialize other stuffs
set(handles.axes1, 'Visible', 'On');
set(handles.uipanel_nav_frames, 'Visible', 'On');
set(handles.table_fix_traces, 'Visible', 'On');
set(handles.pushbutton_clear, 'Visible', 'On');
set(handles.pushbutton_clear_all, 'Visible', 'On');
set(handles.pushbutton_finish, 'Visible', 'On');
set(handles.pushbutton_notation, 'Visible', 'On' );
set(handles.pushbutton_showLineage, 'Visible', 'On');
handles.curr_frame_id = 1;
set(handles.edit_intensity_low, 'String', num2str(round(min(min(handles.figure1.UserData(handles.curr_frame_id).image)))));
set(handles.edit_intensity_high, 'String', num2str(round(max(max(handles.figure1.UserData(handles.curr_frame_id).image)))));

% get intensity range
min_intensity = str2double(get(handles.edit_intensity_low, 'String'));
max_intensity = str2double(get(handles.edit_intensity_high, 'String'));
temp = handles.figure1.UserData(handles.curr_frame_id).image;
temp = (min(max(temp, min_intensity), max_intensity) - min_intensity)/(max_intensity-min_intensity);

% plot first figure
set(handles.text_curr_frame_id, 'String', num2str(handles.imported_frame_id(handles.curr_frame_id)));
cla(handles.axes1); h_image = imshow(temp, 'Parent', handles.axes1);
hold on; set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
% handles = plot_image(handles);

guidata(hObject, handles);
end

%% NAVIGATION OF FRAMES
% --- Executes on button press in pushbutton_go_by_1_frame_prev.
function pushbutton_go_by_1_frame_prev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_by_1_frame_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.curr_frame_id = handles.curr_frame_id - 1;
if (handles.curr_frame_id < 1)
    handles.curr_frame_id = handles.curr_frame_id + length(handles.imported_frame_id);
end
handles.curr_ellipse_id = [];
% handles = set_morphology_state_enability(handles, 'Off');
% handles = set_motion_state_enability(handles, 'Off');
handles = plot_image(handles);
guidata(hObject, handles);

end

% --- Executes on button press in pushbutton_go_by_1_frame_next.
function pushbutton_go_by_1_frame_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_by_1_frame_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.curr_frame_id = handles.curr_frame_id + 1;
if (handles.curr_frame_id > length(handles.imported_frame_id))
    handles.curr_frame_id = handles.curr_frame_id - length(handles.imported_frame_id);
end
handles.curr_ellipse_id = [];
% handles = set_morphology_state_enability(handles, 'Off');
% handles = set_motion_state_enability(handles, 'Off');
handles = plot_image(handles);
guidata(hObject, handles);

end

% --- Executes on button press in pushbutton_go_by_10_frames_prev.
function pushbutton_go_by_10_frames_prev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_by_10_frames_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.curr_frame_id = handles.curr_frame_id - 10;
while (handles.curr_frame_id < 1)
    handles.curr_frame_id = handles.curr_frame_id + length(handles.imported_frame_id);
end
handles.curr_ellipse_id = [];
% handles = set_morphology_state_enability(handles, 'Off');
% handles = set_motion_state_enability(handles, 'Off');
handles = plot_image(handles);
guidata(hObject, handles);

end

% --- Executes on button press in pushbutton_go_by_10_frames_next.
function pushbutton_go_by_10_frames_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_by_10_frames_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.curr_frame_id = handles.curr_frame_id + 10;
while (handles.curr_frame_id > length(handles.imported_frame_id))
    handles.curr_frame_id = handles.curr_frame_id - length(handles.imported_frame_id);
end
handles.curr_ellipse_id = [];
% handles = set_morphology_state_enability(handles, 'Off');
% handles = set_motion_state_enability(handles, 'Off');
handles = plot_image(handles);
guidata(hObject, handles);

end

function edit_go_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_go_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_go_to as text
%        str2double(get(hObject,'String')) returns contents of edit_go_to as a double

% check whether the input string is a valid number
val = str2double(get(hObject, 'String'));
if ~ismember(val, handles.imported_frame_id)
    waitfor(errordlg('Invalid Frame ID.','Error'));
    set(hObject, 'String', []);
    set(handles.pushbutton_go_to_frame_ID, 'Enable', 'off');
else
    set(handles.pushbutton_go_to_frame_ID, 'Enable', 'on');
end
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_go_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_go_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in pushbutton_go_to_frame_ID.
function pushbutton_go_to_frame_ID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_to_frame_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = str2double(get(handles.edit_go_to, 'String'));
handles.curr_frame_id = find(val == handles.imported_frame_id, 1);
handles.curr_ellipse_id = [];
% handles = set_morphology_state_enability(handles, 'Off');
% handles = set_motion_state_enability(handles, 'Off');
handles = plot_image(handles);
guidata(hObject, handles);

end

function edit_to_cell_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_to_cell_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_to_cell_id as text
%        str2double(get(hObject,'String')) returns contents of edit_to_cell_id as a double

% check whether the input string is a valid number
val = str2double(get(hObject, 'String'));
if (isnan(val) || val~=floor(val) || val<=0)
    waitfor(errordlg('Invalid value. Please enter a positive integer.','Error'));
    set(handles.pushbutton_to_cell_id, 'Enable', 'off');
    set(hObject, 'String', '');
else
    set(handles.pushbutton_to_cell_id, 'Enable', 'on');
end
guidata(hObject, handles);

end
% --- Executes during object creation, after setting all properties.
function edit_to_cell_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_to_cell_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in pushbutton_to_cell_id.
function pushbutton_to_cell_id_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_to_cell_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set current cell id
cell_id = str2double(get(handles.edit_to_cell_id, 'String'));
all_parametric_para = handles.figure1.UserData(handles.curr_frame_id).ellipse_info.all_parametric_para;

% find the position of directed cell
all_cell_id = [all_parametric_para{:,1}];
handles.curr_ellipse_id = find(all_cell_id(1,:) == cell_id);

% re-plot image
if isempty(handles.curr_ellipse_id)
    waitfor(warndlg('Cell id is not valid in current frame. Will not label it.','Warning'));
else
    handles = plot_image( handles );
end

guidata(hObject, handles);
end

function edit_go_to_clone_Callback(hObject, eventdata, handles)
% hObject    handle to edit_go_to_clone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_go_to_clone as text
%        str2double(get(hObject,'String')) returns contents of edit_go_to_clone as a double

val = str2double(get(hObject, 'String'));
if (isnan(val) || val~=floor(val) || val<0)
    waitfor(errordlg('Invalid value. Please enter a positive integer.','Error'));
    set(handles.pushbutton_go_to_clone_ID, 'Enable', 'off');
    set(hObject, 'String', '');
else
    set(handles.pushbutton_go_to_clone_ID, 'Enable', 'on');
end
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit_go_to_clone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_go_to_clone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in pushbutton_go_to_clone_ID.
function pushbutton_go_to_clone_ID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_to_clone_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f = waitbar(0, 'Loading Data.'); pause(0.01);
clone_id = str2double(get(handles.edit_go_to_clone, 'String'));
if isempty(handles.mask_prefix) == 1
    handles = importTracedata( handles, clone_id );
else
    waitfor(errordlg('The mask annotation does not support this function','Error'));
end
waitbar(0.5, f); pause(0.01);
handles = plot_image(handles);
close(f);
guidata(hObject, handles)
end

function edit_intensity_low_Callback(hObject, eventdata, handles)
% hObject    handle to edit_intensity_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_intensity_low as text
%        str2double(get(hObject,'String')) returns contents of edit_intensity_low as a double

val = str2double(get(hObject, 'String'));
if (isnan(val) || val < 0)
    waitfor(errordlg('Invalid value. Please enter a non-negative number.','Error'));
    set(hObject, 'String', num2str(round(min(min(handles.figure1.UserData(handles.curr_frame_id).image)))));
else
    if (val > str2double(get(handles.edit_intensity_high, 'String')))
        set(hObject, 'String', get(handles.edit_intensity_high, 'String'));
        set(handles.edit_intensity_high, 'String', num2str(val));
    end
end
handles = plot_image(handles);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_intensity_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_intensity_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_intensity_high_Callback(hObject, eventdata, handles)
% hObject    handle to edit_intensity_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_intensity_high as text
%        str2double(get(hObject,'String')) returns contents of edit_intensity_high as a double

val = str2double(get(hObject, 'String'));
if (isnan(val) || val < 0)
    waitfor(errordlg('Invalid value. Please enter a non-negative number.','Error'));
    set(hObject, 'String', num2str(round(max(max(handles.figure1.UserData(handles.curr_frame_id).image)))));
else
    if (val < str2double(get(handles.edit_intensity_low, 'String')))
        set(hObject, 'String', get(handles.edit_intensity_low, 'String'));
        set(handles.edit_intensity_low, 'String', num2str(val));
    end
end
handles = plot_image(handles);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_intensity_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_intensity_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

%% CONTROL BUTTONS
% --- Executes on button press in pushbutton_clear_all.
function pushbutton_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = questdlg('Are you sure to clear all data?', 'Warning','Yes','Cancel','Cancel');
switch answer
    case 'Yes'
        handles.fix_traces = [];
        set(handles.table_fix_traces,'Data',[]);
        guidata(hObject, handles);
    case 'Cancel'
        return
end
end

% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.selected_trace)
    handles.fix_traces(handles.selected_trace,:) = []; 
    set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
    handles.selected_trace = [];
end

guidata(hObject, handles);
end

% --- Executes on button press in pushbutton_finish.
function pushbutton_finish_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

corHistory = handles.fix_traces;
loc = [find(handles.prefix == '_')];
prefix = handles.prefix(1:loc(1,3)-1);
save([handles.output_path, 'correction_', prefix, '.mat'], 'corHistory');

% reset the program
handles.file_path = []; set(handles.edit_file_path, 'String', '');
handles.prefix = []; set(handles.edit_prefix, 'String', '');
handles.imported_frame_id = []; set(handles.edit_first_imported_frame_id, 'String', ''); set(handles.edit_last_imported_frame_id, 'String', '');
handles.mask_path = []; set(handles.edit_mask_path, 'String', '');
handles.mask_prefix = []; set(handles.edit_mask_prefix, 'String', '');
handles.extMAT_path = []; set(handles.edit_extMAT_path, 'String', '');
handles.cmos_path = []; set(handles.edit_cmos, 'String', '');
handles.bias_path = []; set(handles.edit_bias, 'String', '');
handles.tracedata_path = []; set(handles.edit_path_tracedata, 'String', '');
handles.output_path = []; set(handles.edit_path_output, 'String', '');
handles.curr_frame_id = [];
handles.curr_ellipse_id = [];
handles.curr_cell_id = [];
handles.figure1.UserData = [];
handles.morphology_training_set = {};
handles.motion_training_set = [];

cla(handles.axes1);

handles = set_setting_enability(handles, 'On');
% set(handles.pushbutton_go_to_frame_ID, 'Enable', 'off');
set(handles.axes1, 'Visible', 'Off');
set(handles.uipanel_nav_frames, 'Visible', 'Off');
set(handles.table_fix_traces, 'Visible', 'Off'); handles.fix_traces = [];
set(handles.pushbutton_clear, 'Visible', 'Off');
set(handles.pushbutton_clear_all, 'Visible', 'Off');
set(handles.pushbutton_finish, 'Visible', 'Off');

guidata(hObject, handles);

end

%% SELF_DEFINED FUNCTIONS
function [ handles ] = set_setting_enability( handles, state )

set(handles.edit_file_path, 'Enable', state);
set(handles.pushbutton_select_path, 'Enable', state);
set(handles.edit_prefix, 'Enable', state);
set(handles.edit_first_imported_frame_id, 'Enable', state);
set(handles.edit_last_imported_frame_id, 'Enable', state);
set(handles.edit_mask_path, 'Enable', state);
set(handles.pushbutton_select_mask_path,'Enable', state);
set(handles.edit_mask_prefix,'Enable', state);
set(handles.edit_extMAT_path,'Enable', state);
set(handles.pushbutton_extMAT,'Enable', state);
set(handles.edit_cmos, 'Enable', state);
set(handles.pushbutton_cmos, 'Enable', state);
set(handles.edit_bias, 'Enable', state);
set(handles.pushbutton_bias, 'Enable', state);
set(handles.edit_path_tracedata, 'Enable', state);
set(handles.pushbutton_path_tracedata, 'Enable', state);
set(handles.edit_path_output, 'Enable', state);
set(handles.pushbutton_path_output, 'Enable', state);
set(handles.pushbutton_import_to_workspace, 'Enable', state);

end

function [ handles ] = plot_image( handles )

% get intensity range
min_intensity = str2double(get(handles.edit_intensity_low, 'String'));
max_intensity = str2double(get(handles.edit_intensity_high, 'String'));
temp = handles.figure1.UserData(handles.curr_frame_id).image;
temp = (min(max(temp, min_intensity), max_intensity) - min_intensity)/(max_intensity-min_intensity);

% set current figure number
set(handles.text_curr_frame_id, 'String', num2str(handles.imported_frame_id(handles.curr_frame_id)));

% plot base image
 
% if handles.curr_frame_id==handles.imported_frame_id(1)
%     cla(handles.axes1);
%     h_image = imshow(temp, 'Parent', handles.axes1);
% else

hImg = get(handles.axes1, 'Children');
h_image = get(handles.axes1, 'Parent');
cla(handles.axes1,hImg(end));
%     hImg = hImg(end);
%set(handles.axes1, 'Children', hImg);    
set(hImg(end), 'CData', temp);
% end
hold on; set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
xlim = get(handles.axes1, 'XLim');
ylim = get(handles.axes1, 'YLim');

% plot existing ellipses
all_boundary_points = handles.figure1.UserData(handles.curr_frame_id).ellipse_info.all_boundary_points;
all_parametric_para = handles.figure1.UserData(handles.curr_frame_id).ellipse_info.all_parametric_para;
if isempty(handles.mask_prefix) 
    centerX = cellfun( @(a) a(3,1), all_parametric_para);
    centerY = cellfun( @(a) a(4,1), all_parametric_para);
    centers = [centerX,centerY];
    rads = zeros(1,size(centers,1))+10;
    h_image = viscircles(centers,rads,'color',[0.8, 0.5, 0.5],'LineWidth', 1);
    set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
    for i = 1:length(all_boundary_points)
        if isempty(all_boundary_points{i})
            continue;
        end
        if min(all_boundary_points{i}(:,1)) >= xlim(1,1) && max(all_boundary_points{i}(:,1)) <= xlim(1,2) && min(all_boundary_points{i}(:,2)) >= ylim(1,1) && max(all_boundary_points{i}(:,2)) <= ylim(1,2) % only plot text within the field of view.
            if all_parametric_para{i}(2) == 0
                c = [0.5, 0.8, 0.5];
            elseif all_parametric_para{i}(2) == 1
                c = [1, 1, 0];
            elseif all_parametric_para{i}(2) == 2
                c = [0.8, 0.5, 0.5];
            end
            h_image = text(double(all_parametric_para{i}(3)), double(all_parametric_para{i}(4)), num2str(all_parametric_para{i}(1)), 'Color', c, 'FontSize', 10);
            set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
        end
    end
else
    for i=1:length(all_boundary_points)
        if isempty(all_boundary_points{i})
            continue;
        end
        % only plot cells within field of view
        if min(all_boundary_points{i}(:,1)) >= xlim(1,1) && max(all_boundary_points{i}(:,1)) <= xlim(1,2) && min(all_boundary_points{i}(:,2)) >= ylim(1,1) && max(all_boundary_points{i}(:,2)) <= ylim(1,2)
            h_image = plot(all_boundary_points{i}(:,1), all_boundary_points{i}(:,2), 'Color', [0.8, 0.5, 0.5], 'LineWidth', 1);
            set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
            if all_parametric_para{i}(2) == 0
                c = [0.5, 0.8, 0.5];
            elseif all_parametric_para{i}(2) == 1
                c = [1, 1, 0];
            elseif all_parametric_para{i}(2) == 2
                c = [0.8, 0.5, 0.5];
            end
            h_image = text(all_parametric_para{i}(3), all_parametric_para{i}(4), num2str(all_parametric_para{i}(1)), 'Color', c, 'FontSize', 10);
            set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
        end
    end
end

% plot the currently selected ellipse
if (~isempty(handles.curr_ellipse_id)) 
    if isempty(handles.mask_prefix)
        rad = 10;
        center = [all_parametric_para{handles.curr_ellipse_id}(3),all_parametric_para{handles.curr_ellipse_id}(4)];
        h_image = rectangle('Position',[center-rad, 2*rad, 2*rad],'Curvature',[1 1],'FaceColor','red','Edgecolor','none');
        set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
    else
        h_image = patch(all_boundary_points{handles.curr_ellipse_id}(:,1), all_boundary_points{handles.curr_ellipse_id}(:,2), ...
            'red', 'FaceAlpha', 1);
        set(h_image, 'ButtonDownFcn', @fig_image_ButtonDownFcn);
    end
end
hold off;

end


function fig_image_ButtonDownFcn(hObject, eventdata)

% check whether the mouse position is within an ellipse
handles = guidata(hObject);
temp_hObject = handles.axes1;
cursorPoint = round(get(handles.axes1, 'CurrentPoint'));
cursorPoint(1,1) = min(max(cursorPoint(1,1), 1), size(handles.figure1.UserData(handles.curr_frame_id).image, 2));
cursorPoint(1,2) = min(max(cursorPoint(1,2), 1), size(handles.figure1.UserData(handles.curr_frame_id).image, 1));

all_internal_points = handles.figure1.UserData(handles.curr_frame_id).ellipse_info.all_internal_points;
all_parametric_para = handles.figure1.UserData(handles.curr_frame_id).ellipse_info.all_parametric_para;
ellipse_id = false(size(all_internal_points, 1), 1);
for i=1:size(all_internal_points, 1)
    id = find(all_internal_points{i}(:,1) == cursorPoint(1,1) & all_internal_points{i}(:,2) == cursorPoint(1,2), 1);
    if (~isempty(id))
        ellipse_id(i) = true;
    end
end

% look for cell id within an ellipse_id
cell_para = all_parametric_para(ellipse_id);
if (length(cell_para)~= 1)
    return;
end
cell_id = cell_para{1}(1);
ellipse_id = find(ellipse_id);
if (length(ellipse_id)~= 1)
    return;
end
handles.curr_ellipse_id = ellipse_id;

% exam click type
pause(0.3);
val1=str2double(get(handles.edit_first_imported_frame_id,'string'));
val2= handles.curr_frame_id+val1-1;
switch handles.figure1.SelectionType
    case 'normal'
        handles.fix_traces = [handles.fix_traces;[cell_id,val2,0,0]];
        set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
    case 'open'
        handles.fix_traces = [handles.fix_traces;[cell_id,0,0,1]];
        set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
    case 'alt'
        if handles.fix_traces(end,4) == 1
            handles.fix_traces(end,2) = val2;
            handles.fix_traces(end,3) = cell_id;
        else
            handles.fix_traces(end,3) = cell_id;
        end
        set(handles.table_fix_traces,'Data', handles.fix_traces,'ColumnEditable',true);
end

%save data after every click
corHistory = handles.fix_traces;
loc = [find(handles.prefix == '_')];
prefix = handles.prefix(1:loc(1,3)-1);
save([handles.output_path, 'correction_', prefix, '.mat'], 'corHistory');

handles = plot_image(handles);
guidata(temp_hObject, handles);
end

function [handles] = importTracedata( handles, cloneNum )
overview = h5read(handles.tracedata_path,'/genealogy');
jitters = h5read(handles.tracedata_path,'/jitters');
lf = LineageForest(handles.tracedata_path);
handles.lf = lf;
[traceMat,currIDList] = lf.convertToMat(cloneNum); % convert to a matrix of TraceNum by frameNum by featureNum 
currIDList = currIDList';
image_size_of_x = size(handles.figure1.UserData(1).image,2);
image_size_of_y = size(handles.figure1.UserData(1).image,1);
rad = 10;
% loop through every frame
for i= 1:length(handles.imported_frame_id)
    % find internal pixels and boundary pixels positions
    currFrameInfo = squeeze(traceMat(:,handles.imported_frame_id(i),:));
%     if size(currFrameInfo,2) == 1
%         currFrameInfo = currFrameInfo';
%     end
    currCellX = currFrameInfo(:,1) - jitters(handles.imported_frame_id(i),1);
    currCellY = currFrameInfo(:,2) - jitters(handles.imported_frame_id(i),2);
    oneDimPosList = (image_size_of_y * (round(currCellX)-1) + round(currCellY))';
    currCircCenter = zeros(image_size_of_y,image_size_of_x,'double');
    currCircCenter(oneDimPosList(~isnan(currCellX))) = currIDList(~isnan(currCellX)); % nan isn't accepted
    currCirc = imdilate(currCircCenter,strel('disk',rad));
    currBound = bwperim(currCirc).*currCirc;
    currInter = currCirc-currBound;
    all_internal_points = struct2cell(regionprops(currInter,'PixelList'));
    all_boundary_points = struct2cell(regionprops(currBound,'PixelList'));
    
    % trade off part for track linking bug
    if cloneNum == 0
        all_internal_points = all_internal_points(~isnan(currCellX));
        all_boundary_points = all_boundary_points(~isnan(currCellX));
    else
        all_internal_points = all_internal_points(~cellfun('isempty',all_internal_points));
        all_boundary_points = all_boundary_points(~cellfun('isempty',all_boundary_points));
    end
    % identify events such as mitosis, apoptosis and migration
%             isDaughter = ~overview(:,3) == 0;
%             isFirstFrame = overview(:,1) == i;
%             isAfterMitosis = isDaughter.*isFirstFrame;
    mothList = unique(overview(:,3));
    isMother = zeros(size(overview,1),1);% 0 for migration
    isMother(mothList(2:end)) = 1;
    isEndFrame = overview(:,2) == i;% this method only works for all information, not for one clone.
    isBeforeMitosis = isMother.*isEndFrame; % 1 for mitosis. Mitosis is true if current frame is end frame and the current cell is a mother cell
    isApoptosis = ~isMother.*isEndFrame.*2; % 2 for apoptosis. Apoptosis is true if current frame is end frame and the current cel isn't a mother cell
    currBehaviors = isBeforeMitosis + isApoptosis; % cobine the logical variable, assume there won't be a cell have mutiple behavior at the same frame.
    allParaList = [currIDList(~isnan(currCellX))';currBehaviors(~isnan(currCellX))'; currCellX(~isnan(currCellX))'; currCellY(~isnan(currCellX))'];
    all_parametric_para = mat2cell(allParaList,size(allParaList,1),ones(1,size(allParaList,2)));%no empty list
    handles.figure1.UserData(i).ellipse_info = struct('all_parametric_para',{all_parametric_para'},'all_boundary_points',{all_boundary_points'},'all_internal_points',{all_internal_points'});
end
end
%% KEYPRESS FUNCTION
% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

% try to examine whether images has been loaded or not
if (strcmp(get(handles.uipanel_nav_frames, 'Visible'), 'Off'))
    return
end
% checking if the position of the mouse is out/inside of figure area
guiSize = get(hObject,'Position'); 
figSize = handles.axes1.Position(3:4).*guiSize(3:4);
if eventdata.Source.CurrentPoint(1,1) > figSize(1,1) ...
        || eventdata.Source.CurrentPoint(1,2) > figSize(1,2)
    return
end


if (eventdata.VerticalScrollCount > 0)
    pushbutton_go_by_1_frame_next_Callback(handles.pushbutton_go_by_1_frame_next, eventdata, handles);
elseif (eventdata.VerticalScrollCount < 0)
    pushbutton_go_by_1_frame_prev_Callback(handles.pushbutton_go_by_1_frame_prev, eventdata, handles);
end

end

% --- Executes when selected cell(s) is changed in table_fix_traces.
function table_fix_traces_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table_fix_traces (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    handles.selected_trace = eventdata.Indices(1);
    guidata(hObject, handles);
end

end

% --- Executes when entered data in editable cell(s) in table_fix_traces.
function table_fix_traces_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table_fix_traces (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
handles.fix_traces = handles.table_fix_traces.Data;
guidata(hObject, handles);
end

% --- Executes on button press in pushbutton_showLineage.
function pushbutton_showLineage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_showLineage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clone_id = str2double(get(handles.edit_go_to_clone, 'String'));
lf = handles.lf;

% if exist([handles.tracedata_path(1:end-4),'_backup.h5/'],'file')>0
%     lf.rollback();
%     lf.correctAll(handles.fix_traces, 0);
if ~isempty(handles.fix_traces)
    lf.correctAll(handles.fix_traces, 0);
    lf.plotLineageMap(clone_id,'data(:,12)./data(:,6)','isFillGapSelected',0);
    lf.rollback();
else
    lf.plotLineageMap(clone_id,'data(:,12)./data(:,6)','isFillGapSelected',0);
end

handles.lf = lf;
guidata(hObject, handles);

end

% --- Executes on button press in pushbutton_notation.
function pushbutton_notation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_notation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eventMat = [1,2,3];
% fig = uifigure;
colName = {'cell_id', 'frame_num', 'event'};
% eventMat = eventMat(:,vars);
% t = readtable('patients.xls');
% vars = {'Age','Systolic','Diastolic','Smoker'};
% t = t(1:15,vars);
% uit = uitable(fig,'Data',eventMat);
fig = uifigure('Name','Notation Table');
uit = uitable(fig,'Units','normalized','Position',[.1 .1 .8 .9],'Data',eventMat,'ColumnName', colName);
uit.ColumnEditable = true;
end
