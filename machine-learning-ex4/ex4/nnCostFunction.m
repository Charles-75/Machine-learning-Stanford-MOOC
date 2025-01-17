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


% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

X = [ones(m,1), X];  % Adding 1 as first column in X => adding bias
  
a1 = X; % 5000 x 401

z2 = a1 * Theta1';  % m x hidden_layer_size == 5000 x 25
a2 = sigmoid(z2); % m x hidden_layer_size == 5000 x 25
a2 = [ones(size(a2,1),1), a2]; % Adding 1 as first column in z = (Adding bias unit) % m x (hidden_layer_size + 1) == 5000 x 26

z3 = a2 * Theta2';  % m x num_labels == 5000 x 10
a3 = sigmoid(z3); % m x num_labels == 5000 x 10

h_x = a3; % m x num_labels == 5000 x 10

y_Vec = (1:num_labels)==y; % m x num_labels == 5000 x 10

%Costfunction Without regularization
J = (1/m) * sum(sum((-y_Vec.*log(h_x))-((1-y_Vec).*log(1-h_x))));  %scalar


% Part 2: Implementing Backpropogation for Theta_gra w/o Regularization %

A1 = X; % 5000 x 401

Z2 = A1 * Theta1';  % m x hidden_layer_size == 5000 x 25
A2 = sigmoid(Z2); % m x hidden_layer_size == 5000 x 25
A2 = [ones(size(A2,1),1), A2]; % Adding 1 as first column in z = (Adding bias unit) % m x (hidden_layer_size + 1) == 5000 x 26

Z3 = A2 * Theta2';  % m x num_labels == 5000 x 10
A3 = sigmoid(Z3); % m x num_labels == 5000 x 10

% h_x = a3; % m x num_labels == 5000 x 10

y_Vec = (1:num_labels)==y; % m x num_labels == 5000 x 10

delta3 = A3 - y_Vec; % 5000 x 10
delta2 = (delta3 * Theta2) .* [ones(size(Z2,1),1) sigmoidGradient(Z2)]; % 5000 x 26
delta2 = delta2(:,2:end); % 5000 x 25 %Removing delta2 for bias node

Theta1_grad = (1/m) * (delta2' * A1); % 25 x 401
Theta2_grad = (1/m) * (delta3' * A2); % 10 x 26

% %Regularization term is later added in Part 3
% Theta1_grad = (1/m) * Theta1_grad + (lambda/m) * [zeros(size(Theta1, 1), 1) Theta1(:,2:end)]; % 25 x 401
% Theta2_grad = (1/m) * Theta2_grad + (lambda/m) * [zeros(size(Theta2, 1), 1) Theta2(:,2:end)]; % 10 x 26


% Part 3: Adding Regularisation term in J and Theta_grad %
reg_term = (lambda/(2*m)) * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2))); %scalar

%Costfunction With regularization
J = J + reg_term; %scalar

%Calculating gradients for the regularization
Theta1_grad_reg_term = (lambda/m) * [zeros(size(Theta1, 1), 1) Theta1(:,2:end)]; % 25 x 401
Theta2_grad_reg_term = (lambda/m) * [zeros(size(Theta2, 1), 1) Theta2(:,2:end)]; % 10 x 26

%Adding regularization term to earlier calculated Theta_grad
Theta1_grad = Theta1_grad + Theta1_grad_reg_term;
Theta2_grad = Theta2_grad + Theta2_grad_reg_term;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
