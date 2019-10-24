%% Change the setup frequency in Matlab in a little smarter way
% center frequency in MHz; everything will change based on this.
frequency = 700; %MHz
sweepStart = frequency - (frequency * 0.1);
sweepStop = frequency + (frequency * 0.1);

%% Change the setup frequency in Matlab in a little smarter way
script = fopen('hfss_script.py', 'wt');

fprintf(script, 'import os\n');
fprintf(script, 'project_file = os.path.join(os.path.expanduser("~"), "Desktop")\n');
fprintf(script, 'project_file = os.path.join(project_file, "AntennaTemplate.aedt")\n');
fprintf(script, 'import ScriptEnv\n');
fprintf(script, 'ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")\n');
fprintf(script, 'oDesktop.RestoreWindow()\n');
fprintf(script, 'oDesktop.OpenProject(project_file)\n');
fprintf(script, 'oProject = oDesktop.SetActiveProject("AntennaTemplate")\n');
fprintf(script, 'oDesign = oProject.SetActiveDesign("HFSSDesign1")\n');
fprintf(script, 'oDesign.ChangeProperty(["NAME:AllTabs", ["NAME:HfssTab", ["NAME:PropServers", "AnalysisSetup:Setup8"],\n');
fprintf(script, '            ["NAME:ChangedProps", [ "NAME:Solution Freq", "MustBeInt:=", False, "Value:=", "%fMHz"]]]])\n', frequency);
fprintf(script, 'oDesign.ChangeProperty([ "NAME:AllTabs", ["NAME:HfssTab", ["NAME:PropServers", "AnalysisSetup:Setup8:Sweep1"],\n');
fprintf(script, '            ["NAME:ChangedProps", [ "NAME:Start", "MustBeInt:=", False, "Value:=", "%fMHz"]]]])\n', sweepStart);
fprintf(script, 'oDesign.ChangeProperty([ "NAME:AllTabs", [ "NAME:HfssTab", [ "NAME:PropServers", "AnalysisSetup:Setup8:Sweep1" ],\n');
fprintf(script, '            [ "NAME:ChangedProps", [ "NAME:Stop", "MustBeInt:=", False, "Value:=", "%fMHz"]]]])\n', sweepStop);

fclose(script);
system('"C:\Program Files\AnsysEM\AnsysEM16.0\Win64\ansysedt.exe" -RunScript "hfss_script.py"')