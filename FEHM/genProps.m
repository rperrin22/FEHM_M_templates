classdef genProps
    % genProps
    % This class builds files that supply an FEHM run with information
    % about the material properties of a mesh and the boundary conditions.
    % It is meant to serve as an easy way to generate the necessary files,
    % but also to serve as a record of what was used, and how to reproduce
    % the necessary information.

    properties
        prefix
        rpi_filename
        hfi_filename
        crust_age
        zones
        por_A
        por_B
        por_C
        por_D
        k_A
        k_B
        k_KW
        k_KR
        perm_A
        perm_B
        perm_C
        perm_D
        perm_E
        perm_F
        perm_G
        perm_H
        perm_I
        comp_A
        comp_B
        comp_C
        comp_D
        comp_E
        comp_F
        comp_G
        comp_GRAV
        comp_RHOW
        comp_RHOG
        comp_SPECHEAT
    end

    methods
        function obj = genProps(prefix,zones)
            % Initialize the object.  Most categories are empty and need to
            % be populated with functions
            obj.prefix = prefix;
            obj.rpi_filename = sprintf('%s.rpi',prefix);
            obj.hfi_filename = sprintf('%s.hfi',prefix);
            obj.zones = zones;
        end

        function obj = paramPor(obj,por_A,por_B,por_C,por_D)
            % Populate the porosity parameters for the following function
            % FUN=@(depth)A.*exp(B.*depth)+C+D.*depth;

            % assertions
            assert(length(por_A)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(por_B)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(por_C)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(por_D)==length(obj.zones),'parameter vector length must match zone lengths');

            % assign parameters
            obj.por_A = por_A; 
            obj.por_B = por_B; 
            obj.por_C = por_C; 
            obj.por_D = por_D; 
        end

        function obj = paramCond(obj,k_A,k_B,k_KW,k_KR)
            % Populate the thermal conductivity parameters for the following function
            %     FUN=@(depth,porosity)A+B.*depth+(KW.^porosity).*(KR.^(1-porosity));

            % assertions
            assert(length(k_A)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(k_B)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(k_KW)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(k_KR)==length(obj.zones),'parameter vector length must match zone lengths');

            % assign parameters
            obj.k_A = k_A; 
            obj.k_B = k_B; 
            obj.k_KW= k_KW ;
            obj.k_KR = k_KR; 
        end     

        function obj = paramComp(obj,comp_A,comp_B,comp_C,comp_D,comp_E,comp_F,comp_G,comp_GRAV,comp_RHOW,comp_RHOG,comp_SPECHEAT)
            % Populate the compressibility parameters for the following function
            %     LINEARPOROSITY=@(depth)RHOW.*GRAV.*depth.*(C-1-D.*depth.^2./2)+RHOG.*GRAV.*depth.*(depth-C+D.*depth.^2./2);
            %     EXPONENTIALPOROSITY=@(depth)GRAV.*depth.*(RHOG-RHOW)+GRAV.*E.*(RHOW-RHOG).*(1-exp(-F.*depth))./F;
            %     OVERBURDEN=@(depth)max(LINEARPOROSITY(depth),25);
            %     FUN=@(depth,porosity)A+B.*depth+0.435.*G.*(1-porosity)./OVERBURDEN(depth);

            % assertions
            assert(length(comp_A)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_B)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_C)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_D)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_E)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_F)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_G)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_GRAV)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_RHOW)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_RHOG)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(comp_SPECHEAT)==length(obj.zones),'parameter vector length must match zone lengths');

            % assign parameters
            obj.comp_A = comp_A ; 
            obj.comp_B = comp_B ; 
            obj.comp_C=  comp_C;
            obj.comp_D= comp_D;
            obj.comp_E= comp_E;
            obj.comp_F= comp_F;
            obj.comp_G=  comp_G;
            obj.comp_GRAV = comp_GRAV;
            obj.comp_RHOW = comp_RHOW;
            obj.comp_RHOG = comp_RHOG;
            obj.comp_SPECHEAT =  comp_SPECHEAT;
        end

        function obj = paramPerm(obj,perm_A,perm_B,perm_C,perm_D,perm_E,perm_F,perm_G,perm_H,perm_I)
            % Populate the permeability parameters for the following function
            %     VOID=@(porosity)porosity./(1-porosity);%void ratio
            %     POWERLAW=@(porosity)C.*1e-18.*(VOID(porosity).^D);
            %     EXPONENTIAL=@(porosity)E.*exp(F.*VOID(porosity));
            %     MORINSILVA83=@(porosity)G.*0.0001.*10.^(H.*VOID(porosity)+I);
            %     FUN=@(depth,porosity)A+B.*depth+POWERLAW(porosity)+EXPONENTIAL(porosity)+MORINSILVA83(porosity);


            % assertions
            assert(length(perm_A)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_B)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_C)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_D)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_E)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_F)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_G)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_H)==length(obj.zones),'parameter vector length must match zone lengths');
            assert(length(perm_I)==length(obj.zones),'parameter vector length must match zone lengths');

            % assign parameters
            obj.perm_A = perm_A;
            obj.perm_B = perm_B;
            obj.perm_C = perm_C;
            obj.perm_D = perm_D;
            obj.perm_E =  perm_E;
            obj.perm_F = perm_F;
            obj.perm_G = perm_G;
            obj.perm_H = perm_H;
            obj.perm_I =  perm_I;
        end

        function obj = createRPI(obj)
            fidout = fopen(obj.rpi_filename,'w+');

            fprintf(fidout,'%%ROCKPROP input file (rpi)\n');
            fprintf(fidout,'\n');
            fprintf(fidout,'%%Define equations for each property and zones to apply to, in MATLAB syntax.\n');
            fprintf(fidout,'%%Begin each property section with the property name.\n');
            fprintf(fidout,'%%End each equation and zone definition with a "stop" statement.\n');
            fprintf(fidout,'%%The final "stop" statement for each property should be led by the property name (e.g. porositystop).\n');
            fprintf(fidout,'%%All property, stop, and propertystop statements should be in all lowercase.\n');
            fprintf(fidout,'\n');
            fprintf(fidout,'%%The final function in each set must be called "FUN", but may contain any number of subfunctions.\n');
            fprintf(fidout,'%%Use ALL CAPS for all variable or function definitions, to avoid confusion with the main program.\n');
            fprintf(fidout,'%%The "FUN" function for porosity must include an input for depth.\n');
            fprintf(fidout,'%%All other "FUN" functions must include inputs for both depth and porosity.\n');
            fprintf(fidout,'\n');
            fprintf(fidout,'%%ANISOTROPY is a 3-element array which defines anisotropy for conductivity and permeability.\n');
            fprintf(fidout,'%%This is not a required call, and defaults to isotropic: [1,1,1].\n');
            fprintf(fidout,'\n');
            fprintf(fidout,'%%The compressibility section must include definitions in each zone for both grain density and specific heat of grains.\n');
            fprintf(fidout,'%%These values are required for output to the .rock file, and may also be used to define "FUN".\n');
            fprintf(fidout,'%%Use "RHOG" for grain density.\n');
            fprintf(fidout,'%%Use "SPECHEAT" for specific heat of grains.\n');
            fprintf(fidout,'\n');

            fprintf(fidout,'porosity\n');
            fprintf(fidout,'\n');
            for count = 1:length(obj.zones)
                fprintf(fidout,'ZONES=%d; %%REQUIRED DEFINITION\n',obj.zones(count));
                fprintf(fidout,'\n');
                fprintf(fidout,'A=%.2f;\n',obj.por_A(count));
                fprintf(fidout,'B=%.2f;\n',obj.por_B(count));
                fprintf(fidout,'C=%.2f;\n',obj.por_C(count));
                fprintf(fidout,'D=%.2f;\n',obj.por_D(count));
                fprintf(fidout,'\n');
                fprintf(fidout,'FUN=@(depth)A.*exp(B.*(depth/1000))+C+D.*depth;\n');
                if count==length(obj.zones)
                    fprintf(fidout,'porositystop\n\n\n\n\n');
                else
                    fprintf(fidout,'stop\n\n\n\n');
                end
            end

            fprintf(fidout,'\n');
            fprintf(fidout,'conductivity\n');
            fprintf(fidout,'\n');
            for count = 1:length(obj.zones)
                fprintf(fidout,'ZONES=%d; %%REQUIRED DEFINITION\n',obj.zones(count));
                fprintf(fidout,'ANISOTROPY=[1,1,1];\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'A=%.2f;\n',obj.k_A(count));
                fprintf(fidout,'B=%.2f;\n',obj.k_B(count));
                fprintf(fidout,'KW=%.2f;\n',obj.k_KW(count));
                fprintf(fidout,'KR=%.2f;\n',obj.k_KR(count));
                fprintf(fidout,'\n');
                fprintf(fidout,'FUN=@(depth,porosity)A+B.*depth+(KW.^porosity).*(KR.^(1-porosity));\n');
                if count==length(obj.zones)
                    fprintf(fidout,'conductivitystop\n\n\n\n\n');
                else
                    fprintf(fidout,'stop\n\n\n\n');
                end
            end

            fprintf(fidout,'\n');
            fprintf(fidout,'permeability\n');
            fprintf(fidout,'\n');
            for count = 1:length(obj.zones)
                fprintf(fidout,'ZONES=%d; %%REQUIRED DEFINITION\n',obj.zones(count));
                fprintf(fidout,'ANISOTROPY=[1,1,1];\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'A=%.2e;\n',obj.perm_A(count));
                fprintf(fidout,'B=%.2f;\n',obj.perm_B(count));
                fprintf(fidout,'C=%.2f;\n',obj.perm_C(count));
                fprintf(fidout,'D=%.2f;\n',obj.perm_D(count));
                fprintf(fidout,'E=%.2f;\n',obj.perm_E(count));
                fprintf(fidout,'F=%.2f;\n',obj.perm_F(count));
                fprintf(fidout,'G=%.2f;\n',obj.perm_G(count));
                fprintf(fidout,'H=%.2f;\n',obj.perm_H(count));
                fprintf(fidout,'I=%.2f;\n',obj.perm_I(count));
                fprintf(fidout,'VOID=@(porosity)porosity./(1-porosity);%%void ratio\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'POWERLAW=@(porosity)C.*1e-18.*(VOID(porosity).^D);\n');
                fprintf(fidout,'EXPONENTIAL=@(porosity)E.*exp(F.*VOID(porosity));\n');
                fprintf(fidout,'MORINSILVA83=@(porosity)G.*0.0001.*10.^(H.*VOID(porosity)+I);\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'FUN=@(depth,porosity)A+B.*depth+POWERLAW(porosity)+EXPONENTIAL(porosity)+MORINSILVA83(porosity);\n');
                if count==length(obj.zones)
                    fprintf(fidout,'permeabilitystop\n\n\n\n\n');
                else
                    fprintf(fidout,'stop\n\n\n\n');
                end
            end

            fprintf(fidout,'\n');
            fprintf(fidout,'compressibility\n');
            fprintf(fidout,'\n');
            for count = 1:length(obj.zones)
                fprintf(fidout,'ZONES=%d; %%REQUIRED DEFINITION\n',obj.zones(count));
                fprintf(fidout,'ANISOTROPY=[1,1,1];\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'A=%.2e;\n',obj.comp_A(count));
                fprintf(fidout,'B=%.2f;\n',obj.comp_B(count));
                fprintf(fidout,'C=%.2f;\n',obj.comp_C(count));
                fprintf(fidout,'D=%.2f;\n',obj.comp_D(count));
                fprintf(fidout,'E=%.2f;\n',obj.comp_E(count));
                fprintf(fidout,'F=%.2f;\n',obj.comp_F(count));
                fprintf(fidout,'G=%.2f;\n',obj.comp_G(count));
                fprintf(fidout,'GRAV=%.2f;\n',obj.comp_GRAV(count));
                fprintf(fidout,'RHOW=%.2f;\n',obj.comp_RHOW(count));
                fprintf(fidout,'RHOG=%.2f;\n',obj.comp_RHOG(count));
                fprintf(fidout,'SPECHEAT=%.2f;\n',obj.comp_SPECHEAT(count));
                fprintf(fidout,'\n');
                fprintf(fidout,'LINEARPOROSITY=@(depth)RHOW.*GRAV.*depth.*(C-1-D.*depth.^2./2)+RHOG.*GRAV.*depth.*(depth-C+D.*depth.^2./2);\n');
                fprintf(fidout,'EXPONENTIALPOROSITY=@(depth)GRAV.*depth.*(RHOG-RHOW)+GRAV.*E.*(RHOW-RHOG).*(1-exp(-F.*depth))./F;\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'OVERBURDEN=@(depth)max(LINEARPOROSITY(depth),25);\n');
                fprintf(fidout,'\n');
                fprintf(fidout,'FUN=@(depth,porosity)A+B.*depth+0.435.*G.*(1-porosity)./OVERBURDEN(depth);\n');
                if count==length(obj.zones)
                    fprintf(fidout,'compressibilitystop');
                else
                    fprintf(fidout,'stop\n\n\n\n');
                end
            end

            fclose(fidout);

        end

        function obj = createHFI(obj,age)
            obj.crust_age = age;
            tmp_A = 0.5e-6;
            % write the .hfi file
            fidout = fopen(obj.hfi_filename,'w+');
            fprintf(fidout,'%%HEATFLUX input file (hfi)\n');
            fprintf(fidout,'\n');
            fprintf(fidout,'%% The final function for heatflux must be named "HFLX", but may contain any number of subfunctions.\n');
            fprintf(fidout,'%% HFLX must also be a function of x, y, and z, even if some or all of these dependencies are null.\n');
            fprintf(fidout,'%% Use ALL CAPS for all variable or function definitions, to avoid confusion with the main program.\n');
            fprintf(fidout,'\n');
            fprintf(fidout,'hflx\n');
            fprintf(fidout,'A=%.2e %%MegaWatts\n',tmp_A);
            fprintf(fidout,'AGE=%.2f\n',obj.crust_age);
            fprintf(fidout,'HFLX=@(x,y,z)%.2e./%.2f.^(.5)\n',tmp_A,obj.crust_age);
            fprintf(fidout,'stop\n');
            fclose(fidout);

        end

    end
end