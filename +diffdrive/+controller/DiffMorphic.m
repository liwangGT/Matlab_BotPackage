classdef DiffMorphic < bot.Controller
% The "bot.DiffMorphic" class diffeomorphic LQR controller class for
% differential drive robots.
%
% NOTES:
%   To get more information on this class type "doc bot.DiffMorphic" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +somePackage, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 17-FEB-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    d % (1 x 1 positive number) Diffeomorphic offset value.
    Q % (2 x 2 semi-positive definite matrix) State LQR cost weighting matrix.
    R % (2 x 2 positive definite matrix) Input LQR cost weighting matrix.
end

%% Constructor -----------------------------------------------------------------
methods
    function DiffMorphicObj = DiffMorphic(d,Q,R)
        % Constructor function for the "DiffMorphic" class.
        %
        % SYNTAX:
        %   DiffMorphicObj = bot.DiffMorphic(d,Q,R)
        %
        % INPUTS:
        %   d - (1 x 1 positive number) [1] 
        %       Sets the "DiffMorphicObj.d" property.
        %
        %   Q - (2 x 2 semi-positive definite matrix) [eye(2)] 
        %       Sets the "DiffMorphicObj.Q" property.
        %
        %   R - (2 x 2 positive definite matrix) [eye(2)] 
        %       Sets the "DiffMorphicObj.R" property.
        %
        % OUTPUTS:
        %   DiffMorphicObj - (1 x 1 bot.DiffMorphic object) 
        %       A new instance of the "bot.DiffMorphic" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,3)

        % Apply default values
        if nargin < 1, d = 1; end
        if nargin < 2, Q = eye(2); end
        if nargin < 3, R = eye(2); end
        
        % Initialize superclass
%         nInputs = 2;
%         DiffMorphicObj = DiffMorphicObj@bot.Controller(nInputs);
        
        % Assign properties
        DiffMorphicObj.d = d;
        DiffMorphicObj.Q = Q;
        DiffMorphicObj.R = R;
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
methods
    function DiffMorphicObj = set.d(DiffMorphicObj,d)
        assert(isnumeric(d) && isreal(d) && isequal(size(d),[1,1]),...
            'bot:DiffMorphic:set:d',...
            'Input argument "d" must be a 1 x 1 real number.')

        DiffMorphicObj.d = d;
    end
    
    function DiffMorphicObj = set.Q(DiffMorphicObj,Q)
        assert(isnumeric(Q) && isreal(Q) && isequal(size(Q),[2,2]),...
            'bot:DiffMorphic:set:Q',...
            'Input argument "Q" must be a 2 x 2 real number.')

        DiffMorphicObj.Q = Q;
    end
    
    function DiffMorphicObj = set.R(DiffMorphicObj,R)
        assert(isnumeric(R) && isreal(R) && isequal(size(R),[2,2]),...
            'bot:DiffMorphic:set:R',...
            'Input argument "R" must be a 2 x 2 real number.')

        DiffMorphicObj.R = R;
    end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function input = func(controllerObj,diffDriveObj)
        % See superclass method description.
        %
        %-----------------------------------------------------------------------
        
        %% Parameters
        d = controllerObj.d;
        Q = controllerObj.Q;
        R = controllerObj.R;

        %% Variables
        % System state
        x = diffDriveObj.state.position(1:2);
        theta = diffDriveObj.state.orientation.yaw;
        xBar = diffDriveObj.desiredState.position(1:2); % Setpoint
        xTilde = xBar - x;
        thetaBar = atan2(xTilde(2),xTilde(1));

        % Diffmorphic state
        z = x + d*[cos(theta); sin(theta)];
        zBar = xBar + d*[cos(thetaBar); sin(thetaBar)];
        zTilde = (z - zBar); 

        % Linearization
        A = zeros(2);
        B = [cos(theta) -d*sin(theta); sin(theta) d*cos(theta)];

        %% Calculate
        K = lqr(A,B,Q,R);
        u = -K*zTilde;

        v = u(1);
        w = u(2);
        
        input = diffDriveObj.linAngVel2motorValues(v,w);
        
    end
end
%-------------------------------------------------------------------------------
    
end
