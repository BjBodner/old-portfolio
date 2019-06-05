function [FullFileName] = Menu_SaveWorkSpace()


            prompt = {'Name This Preset'};
            dlg_title = 'Save Preset';
            num_lines = 1;
            Saving_Answer_defaultans = {'MyPreset1'}
            Saving_Answer = inputdlg(prompt,dlg_title,num_lines,Saving_Answer_defaultans);

            Currentdate = date;
            
            %DirNameForAutoSaves = 'C:\Users\BBB\OneDrive\Documents\Research Quantum Dots\2D\ChoicePresets';
            DirNameForAutoSaves = 'C:\Users\benjy\OneDrive\Documents\Research Quantum Dots\2D\ChoicePresets';
            
            FullFileName = strcat(DirNameForAutoSaves,'\',Saving_Answer{1},'_',Currentdate,'.mat');
           %save(FullFileName,'MainMenu_Choices')