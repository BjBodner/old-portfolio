function [] = Menu_MultipleTests()

% this is the menu for repeating the experiment on different CCg




                    prompt = {'Cg',...
                        'Initial C(For CCg Sweep)',...
                        'Final C(For CCg Sweep)',...
                        'Number Of Logarithmic Step between Initial and Final C(minimum 1)',...
                        'Number of Averaging runs at Each C/Cg(minimum 1)'};
                    dlg_title = 'Multiple Runs';
                    num_lines = 1;
                    defaultans = {'100','1','10000','1','1'};
                    Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);