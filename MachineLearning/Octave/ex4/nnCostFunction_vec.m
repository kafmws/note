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

% plain forward propagation
% a1 = X;
% z2 = [ones(m, 1) a1] * Theta1';
% a2 = sigmoid(z2);
% z3 = [ones(m, 1) a2] * Theta2';
% a3 = sigmoid(z3);

% forward propagation
hidden_layer_output = sigmoid([ones(m,1) X] * Theta1');
output = sigmoid([ones(m, 1)  hidden_layer_output] * Theta2');
% [_, pred] = max(output, [], 2);
y_matrix = zeros(m, num_labels);
for i=1:length(y)
    y_matrix(i, y(i)) = 1;
end

% lookup each Theta contains bias unit, see input_layer_size & hidden_layer_size
penalty = lambda/(2*m) * ...
          (sum(sum(Theta1(:,2:end) .^ 2)) + sum(sum(Theta2(:,2:end) .^ 2)));
J = 0;
for i=1:m
    J = J + y_matrix(i,:)*log(output(i,:))' + (1-y_matrix(i,:))*log(1-output(i,:))';
end
J = -1/m * J + penalty;
% J = -1/m * trace(y_matrix*log(output)' + (1-y_matrix)*log(1-output)') + penalty;

% back propagation
%   data-driven forward propagation
a={X};      % activation
z={X};
m = m;
theta = {Theta1, Theta2};
layer_size = [input_layer_size hidden_layer_size num_labels];
L = length(layer_size);
for i=2:L
    z = [z; [ones(m, 1) a{i-1}] * theta{i-1}'];
    a = [a; sigmoid(z{i})];
end
%   data-driven back propagation
%   =====get sample output vector=====
y_matrix = zeros(m, num_labels);
for i=1:length(y)
    y_matrix(i, y(i)) = 1;
end 
%   =====get sample output vector=====
delta={};
delta{L} = a{L} - y_matrix;
for i=fliplr(2:L-1)
    % delta{i} = delta{i+1} * theta{i}(:,2:end) .* a{i} .* (1-a{i});
    delta{i} = (delta{i+1} * theta{i})(:, 2:end) .* (a{i} .* (1-a{i}));
end

D={};
for i=1:L-1
    % DELTA = [DELTA; delta{i+1}' * a{i}];
    D = [D; delta{i+1}' * a{i} ./ m];
end

% theta error
Theta1_grad = [zeros(size(D{1}, 1), 1) D{1}];
Theta2_grad = [zeros(size(D{2}, 1), 1) D{2}];

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
