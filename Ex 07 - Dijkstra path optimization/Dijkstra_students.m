clc 
close all
clear all
node = {'London', 'Zurich', 'Milan', 'Paris', 'Wien', 'Istanbul', 'Kyoto'};
% arc columns = start node, end node, cost
arc = [1 2 3; ...
       2 1 3; ...
       1 4 10; ... 
       4 1 10; ...
       2 3 1; ...
       3 2 1; ... 
       3 4 13; ... 
       4 3 13; ... 
       3 5 8; ...
       5 3 8; ...
       4 5 3; ...
       5 4 3; ...
       5 6 6; ...
       6 5 6; ...
       6 4 2; ...
       4 6 2; ...
       6 7 4; ...
       7 6 4; ...
       2 7 18; ... 
       7 2 18; ];

 % Departure node 
first_id = find(strcmp(node,'Milan'));
 
 % Arrival node
final_id = find(strcmp(node,'Kyoto'));   
 
 % Costs: Initialize by setting all to infinity
ttn = inf(size(node));
% but the departure: cost 0
ttn(first_id) = 0;
 % prev_id: for each node the previous in the minimum path: set NaN
prev_id = nan(size(node));
 % but the departure: reachable from itself
prev_id(first_id) = first_id; 
 % visited_id: already visited / explored nodes vector: set empty

visited_id = zeros(size(node));
 % id_to_visit: nodes that can be (costs already estimated) visited / explored: at the beginning only the departure
id_to_visit = [ first_id ];

while ~all(visited_id) % something exists to check: for example until the arrival has been visited / explored
    min_id = 0;
    min_size = Inf;
    for i = 1:length(ttn)
        if ttn(i) < min_size && visited_id(i) == 0
           min_size = ttn(i);
           min_id = i;
        end
    end
    visiting = min_id;
    visited_id(visiting) = 1;
    
    for i = 1:length(arc)
       if arc(i,1) ==  visiting
           if ttn(visiting) + arc(i,3) < ttn(arc(i,2))
               ttn(arc(i,2)) = ttn(visiting) + arc(i,3);
               prev_id(arc(i,2)) = visiting;
           end
       end
    end
end


current = final_id;
path = [];
while current ~= first_id
    path = [node(current), path];
    current = prev_id(current);
end
path = [node(current), path];
fprintf('The shortest path from Milan to Kyoto is: \n');
path
final_cost=ttn(final_id);
fprintf('The shortest path from Milan to Kyoto costs: %d \n', final_cost);


