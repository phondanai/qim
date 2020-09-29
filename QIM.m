classdef QIM
    properties
        delta
    end
    
    methods
        function obj = QIM(delta)
            obj.delta = delta;
        end
        
        function y = embed(obj, x, m)
            % x : a vector of values to be quantized individually
            % m : a binary vector of bits to be embedded
            
            d = obj.delta;
            y = round(x/d) * d + (-1).^(m+1) * d/4.0;
        end
        
        function [z_detected, m_detected] = detect(obj, z)
            % z : The received vector, potentially modified
            % returns : A detected vector z_detected and detected message
            % m_detected
            
            shape = size(z);
            z = reshape(z,1,[]);
            
            m_detected = zeros(size(z),'like', z);
            z_detected = zeros(size(z), 'like', z);
            
            z0 = obj.embed(z, 0);
            z1 = obj.embed(z, 1);
            
            d0 = abs(z - z0);
            d1 = abs(z - z1);
            
            for i=1:length(z_detected)
                if d0(i) < d1(i)
                    m_detected(i) = 0;
                    z_detected(i) = z0(i);
                else
                    m_detected(i) = 1;
                    z_detected(i) = z1(i);
                end
            end
                    
            z_detected = reshape(z_detected, shape);
            m_detected = reshape(m_detected, shape);
                    
        end
        
        function choice = random_msg(obj, l)
            % returns: a random binary sequence of length l
            choice = randi([0 1], l, 1);
        end
            
    end
end


% Usage example

% l = 10000;
% delta = 8;
% qim = QIM(delta);
% 
% x = randi([0 255], l);

% msg = qim.random_msg(l);
% y = qim.embed(x, msg);
% [z_detected, msg_detected] = qim.detect(y);

% check bit error rate
% sum(xor(msg, msg_detected)) * 100
 


