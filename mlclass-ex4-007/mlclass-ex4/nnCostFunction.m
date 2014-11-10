function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
X = [ones(m,1) X];
y_k = zeros(m,num_labels);
for i = 1:1:m
     y_k(i,y(i)) = 1;
end
for i = 1:1:m
    
    a_2 = sigmoid(Theta1 * X(i,:)');
    a_2 = [1;a_2]';
    a_3 = sigmoid(a_2 * Theta2');
    for k = 1:1:num_labels
        J = J + -y_k(i,k) .* log(a_3(k)) - (1 - y_k(i,k)) .* log(1 - a_3(k)) ;
    end
end
J = J / m;
regula = 0;
%suppose only have 3 layer
%for input and hidden layer
for j = 1:size(Theta1,1)
    for i = 2:size(Theta1,2)
        regula = regula + Theta1(j,i)^2;
    end
end
for j = 1:size(Theta2,1)
    for i = 2:size(Theta2,2)
        regula = regula + Theta2(j,i)^2;
    end
end
J = J + regula*lambda/(2*m);
%compute gradient
%initialize delta3 delta2
delta3 = zeros(num_labels,1);
delta2 = zeros(hidden_layer_size+1,1);
for t=1:m
    z_2 = Theta1 * X(t,:)';
    a_2 = sigmoid(z_2);
    a_2 = [1;a_2]';
    z_3 = a_2 * Theta2';
    a_3 = sigmoid(z_3);
    delta3 = a_3' - y_k(t,:)';%10*1
    delta2 = Theta2'*delta3 .* sigmoidGradient([1;z_2]);%26*1,ignore delta2(1)
    delta2 = delta2(2:end);%25*1
    Theta2_grad = Theta2_grad + delta3 * a_2;
    Theta1_grad = Theta1_grad + delta2 * X(t,:);
end
Theta2_grad = Theta2_grad / m;
Theta1_grad = Theta1_grad / m;
%regulatization
for j = 2:size(Theta2_grad,2)
    for i = 1:size(Theta2_grad,1)
        Theta2_grad(i,j) = Theta2_grad(i,j) + lambda/m * Theta2(i,j);
    end
end
for j = 2:size(Theta1_grad,2)
    for i = 1:size(Theta1_grad,1)
        Theta1_grad(i,j) = Theta1_grad(i,j) + lambda/m * Theta1(i,j);
    end
end







% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
