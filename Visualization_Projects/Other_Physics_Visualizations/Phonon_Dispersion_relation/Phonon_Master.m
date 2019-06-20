NumberOfAtoms = 30;
% Initial Position

%AtomsXPosition = rand(NumberOfAtoms,1); %% Bond Length in Angstom


AtomsYPosition = 0*ones(NumberOfAtoms,1);
dt = 0.001; % in picoseconds;
TotalTime = 1000*dt;
%MoorsePotential =
SpringConstant1 = 1; %Newton*Meter
SpringConstant2 = 1; %Newton*Meter
Mass1 = 1;
Mass2 = 1;
M = Mass1*ones(NumberOfAtoms,1);

K = 5;


dt = 0.01; % in picoseconds;

TotalTime = 10000*dt;
k_Vector = 0:0.5:15;
for k = 0:0.5:15
k
Energy = zeros(1,round(TotalTime/dt));
AtomsXInitialPosition = (1:NumberOfAtoms)*1;%% Bond Length in Angstom

AtomsXDisplacement =  0.3*sin((1:NumberOfAtoms)*k*2*pi/NumberOfAtoms);


Acceleration = zeros(NumberOfAtoms,1).';
Velocity = zeros(NumberOfAtoms,1).';
KMatrix = zeros(NumberOfAtoms);
AtomsXDisplacement_Record = zeros(round(TotalTime/dt),NumberOfAtoms);



    for i = 1:NumberOfAtoms
        if i < NumberOfAtoms
            KMatrix(i,i+1) = K;
        end
        if i > 1
            KMatrix(i,i-1) = K;
        end
    end
    
    for Time = 0:dt:TotalTime
        for i = 1:NumberOfAtoms
            if i>1
                if i < NumberOfAtoms
                    Acceleration(i) = 1/M(i)*(-2*AtomsXDisplacement(i) + AtomsXDisplacement(i+1) + AtomsXDisplacement(i-1));
                end
            end
            if i == NumberOfAtoms
                Acceleration(i) = 1/M(i)*(-AtomsXDisplacement(i) + AtomsXDisplacement(i-1));
            end
            if i == 1
                Acceleration(i) = 1/M(i)*(-AtomsXDisplacement(i) + AtomsXDisplacement(i+1));
            end
        end
        
        AtomsXDisplacement = AtomsXDisplacement + Velocity*dt + 0.5*Acceleration*dt^2;
        Velocity = Velocity + Acceleration*dt;
        
        Energy(round(Time/dt)+1) = 0.5*M.'*(Velocity.^2).' + 0.5*sum(sum(KMatrix.*((diag(AtomsXDisplacement)*ones(NumberOfAtoms) - ones(NumberOfAtoms)*diag(AtomsXDisplacement)).^2)));
        AtomsXDisplacement_Record(round(Time/dt)+1,:) = AtomsXDisplacement;
        if Time == 0
            InitialEnergy = Energy(round(Time/dt)+1);
        end
        
        
        PlotSystem = 0;
        if PlotSystem == 1
            if mod(round(Time/dt),20) == 0
                
                scatter(AtomsXDisplacement + AtomsXInitialPosition,AtomsYPosition,100,'r','filled')
                hold on
                b = bar(AtomsXDisplacement);
                b.FaceAlpha = 0.5;
                hold off
                xlim([0 NumberOfAtoms+1])
                ylim([-1,1])
                f = getframe(gcf);
            end
        end
    end
    TimeVector = 0:dt:TotalTime;
    plot(TimeVector,Energy)
    title(['Energy as a function of time, with dt =  ' num2str(dt)])
    if max(InitialEnergy) > 0
    ylim([0 3*InitialEnergy])
    end
    
    
    
    %% fft of Atom position
    P = zeros(ceil(length(TimeVector)/2),1);
    for i = 1:NumberOfAtoms
        X = AtomsXDisplacement_Record(:,i);
        %TimeVector;
        Time = 0:length(TimeVector)/TotalTime:TotalTime;
        
        Y = fft(X);
        
        %% Part 1 - Copied Fourier Spectrum
        Fs = length(X)/TotalTime;            % Sampling frequency
        T = 1/Fs;             % Sampling period
        L = TotalTime;             % Length of signal
        t = (0:L-1)*T;        % Time vector
        
        %% Part 2 - Copied Fourier Spectrum
        P2 = abs(Y).^2/length(Y);
        P1 = P2(1:round(length(Y)/2));
        P1(2:end-1) = 2*P1(2:end-1);
        %% Part 3 - Copied Fourier Spectrum
        f = Fs*(0:length(Y)/2);
        f1 = (0:length(P1)-1)/((2*L));
        P = P + P1;
        plot(f1,P)
        xlim([0 0.3])
        
    end
    PowerSpectrum(round(k/0.5)+1,:) = P;
end

[k,f] = meshgrid(k_Vector,f1);
s = surf(k.',f.',PowerSpectrum);
s.EdgeColor = 'interp';
s.FaceColor = 'interp';
view(0,90)
ylim([0 0.2])
xlabel('Wavenumber(0 to pi/2)')
ylabel('Frequency (1/Time)')